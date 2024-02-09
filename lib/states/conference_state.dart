import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'dart:async';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:twilio_programmable_video/twilio_programmable_video.dart';
import 'package:twilio_video_calls/models/participant_buffer.dart';
import 'package:twilio_video_calls/models/participant_widget.dart';
import 'package:uuid/uuid.dart';
part 'conference_state.g.dart'; //This will automatically generated after: flutter pub run build_runner build

@singleton
class ConferenceState = ConferenceStateBase with _$ConferenceState;

enum ConferenceMode {
  /// Initial State
  conferenceInitial,

  /// State, when conference is loaded
  conferenceLoaded,
}

abstract class ConferenceStateBase with Store {
  @observable
  String token = "";
  @observable
  String identity = "";

  @observable
  ObservableList<ParticipantWidget> participantsList =
      ObservableList<ParticipantWidget>();

  @observable
  CameraCapturer? _cameraCapturer;

  Room? _room;
  @observable
  String? trackId;

  @observable
  List<StreamSubscription> streamSubscriptions = [];

  @observable
  ConferenceMode? mode;

  @observable
  bool isMicrophoneOn = true;

  @observable
  bool isCameraOn = true;

  StreamController<bool> _onVideoEnabledStreamController =
      StreamController<bool>.broadcast();
  StreamController<bool> _onAudioEnabledStreamController =
      StreamController<bool>.broadcast();

  final List<ParticipantBuffer> _participantBuffer = [];

  //set conference mode
  @action
  void setMode(ConferenceMode value) {
    mode = value;
  }

  //build participant widget
  @action
  ParticipantWidget _buildParticipant({
    required Widget child,
    required String? id,
    required bool audioEnabled,
    required bool videoEnabled,
    RemoteParticipant? remoteParticipant,
  }) {
    return ParticipantWidget(
      id: id,
      audioEnabled: audioEnabled,
      videoEnabled: videoEnabled,
      isRemote: remoteParticipant != null,
      child: child,
    );
  }

  @action
  connect() async {
    // when we are reconnect to the room, we must reinitialize video
    // and audio enable streams
    if (_onVideoEnabledStreamController.isClosed ||
        _onAudioEnabledStreamController.isClosed) {
      _onVideoEnabledStreamController = StreamController<bool>.broadcast();
      _onAudioEnabledStreamController = StreamController<bool>.broadcast();
    }
    setMode(ConferenceMode.conferenceInitial);
    debugPrint('[ APPDEBUG ] ConferenceRoom.connect()');

    try {
      await TwilioProgrammableVideo.setAudioSettings(
          speakerphoneEnabled: true, bluetoothPreferred: false);

      var sources = await CameraSource.getSources();
      _cameraCapturer = CameraCapturer(
        sources.firstWhere((source) => source.isFrontFacing),
      );
      trackId = const Uuid().v4();

      debugPrint("\x1B[33mToken: $token\x1B[0m");
      var connectOptions = ConnectOptions(
        token,
        preferredAudioCodecs: [OpusCodec()],
        audioTracks: [LocalAudioTrack(isMicrophoneOn, 'audio_track-$trackId')],
        dataTracks: [
          LocalDataTrack(
            DataTrackOptions(name: 'data_track-$trackId'),
          )
        ],
        videoTracks: [LocalVideoTrack(true, _cameraCapturer!)],
        enableNetworkQuality: true,
        networkQualityConfiguration: NetworkQualityConfiguration(
          remote: NetworkQualityVerbosity.NETWORK_QUALITY_VERBOSITY_MINIMAL,
        ),
        enableDominantSpeaker: true,
      );

      //connect to the room with our connect options
      _room = await TwilioProgrammableVideo.connect(connectOptions);
      // listen conference statuses
      if (_room != null) {
        streamSubscriptions.add(_room!.onConnected.listen(_onConnected));
        streamSubscriptions.add(_room!.onDisconnected.listen(_onDisconnected));
        streamSubscriptions.add(_room!.onReconnecting.listen(_onReconnecting));
        streamSubscriptions
            .add(_room!.onConnectFailure.listen(_onConnectFailure));
      }
    } catch (err) {
      debugPrint('[ APPDEBUG ] $err');
      rethrow;
    }
  }

  // disconnect from the room, reinitialize conference state to initial values
  // dispose streams and subscriptions
  @action
  Future<void> disconnect() async {
    debugPrint('[ APPDEBUG ] ConferenceRoom.disconnect()');
    if (_room != null) {
      await _room!.disconnect();
      await _room!.dispose();
      await TwilioProgrammableVideo.disableAudioSettings();
      _disposeStreamsAndSubscriptions();
      _cameraCapturer = null;
      _room = null;
      trackId = null;
      participantsList.clear();
      _participantBuffer.clear();
      isMicrophoneOn = true;
      isCameraOn = true;
    }
  }

  @action
  void _onConnected(Room room) {
    debugPrint(
        '[ APPDEBUG ] ConferenceRoom._onConnected => state: ${room.state}');

    // When connected for the first time, add remote participant listeners
    streamSubscriptions
        .add(_room!.onParticipantConnected.listen(_onParticipantConnected));
    streamSubscriptions.add(
        _room!.onParticipantDisconnected.listen(_onParticipantDisconnected));
    var localParticipant = room.localParticipant;
    if (localParticipant == null) {
      debugPrint(
          '[ APPDEBUG ] ConferenceRoom._onConnected => localParticipant is null');
      return;
    }

    // Only add ourselves when connected for the first time too.
    participantsList.add(_buildParticipant(
      child: localParticipant.localVideoTracks[0].localVideoTrack.widget(),
      id: identity,
      audioEnabled: true,
      videoEnabled:
          (localParticipant.localVideoTracks.isNotEmpty) ? true : false,
    ));

    for (final remoteParticipant in room.remoteParticipants) {
      var participant = participantsList.firstWhereOrNull(
          (participant) => participant.id == remoteParticipant.sid);
      if (participant == null) {
        debugPrint(
            '[ APPDEBUG ] Adding participant that was already present in the room ${remoteParticipant.sid}, before I connected');
        _addRemoteParticipantListeners(remoteParticipant);
      }
    }
    reload();
  }

  @action
  void _onParticipantConnected(RoomParticipantConnectedEvent event) {
    debugPrint(
        '[ APPDEBUG ] ConferenceRoom._onParticipantConnected, ${event.remoteParticipant.sid}');
    _addRemoteParticipantListeners(event.remoteParticipant);
    reload();
  }

  @action
  void _onParticipantDisconnected(RoomParticipantDisconnectedEvent event) {
    debugPrint(
        '[ APPDEBUG ] ConferenceRoom._onParticipantDisconnected: ${event.remoteParticipant.sid}');
    participantsList.removeWhere(
        (ParticipantWidget p) => p.id == event.remoteParticipant.sid);
    reload();
  }

  @action
  void _addRemoteParticipantListeners(RemoteParticipant remoteParticipant) {
    streamSubscriptions.add(
        remoteParticipant.onAudioTrackDisabled.listen(_onAudioTrackDisabled));
    streamSubscriptions.add(
        remoteParticipant.onAudioTrackEnabled.listen(_onAudioTrackEnabled));

    streamSubscriptions.add(
        remoteParticipant.onVideoTrackDisabled.listen(_onVideoTrackDisabled));
    streamSubscriptions.add(
        remoteParticipant.onVideoTrackEnabled.listen(_onVideoTrackEnabled));

    streamSubscriptions.add(remoteParticipant.onVideoTrackSubscribed
        .listen(_addOrUpdateParticipant));
    streamSubscriptions.add(remoteParticipant.onAudioTrackSubscribed
        .listen(_addOrUpdateParticipant));
  }

  @action
  void _addOrUpdateParticipant(RemoteParticipantEvent event) {
    debugPrint(
        '[ APPDEBUG ] ConferenceRoom._addOrUpdateParticipant(), ${event.remoteParticipant.sid}');
    var participant = participantsList.firstWhereOrNull(
      (ParticipantWidget participant) =>
          participant.id == event.remoteParticipant.sid,
    );

    if (participant != null) {
      debugPrint(
          '[ APPDEBUG ] Participant found: ${participant.id}, updating A/V enabled values');
      if (event is RemoteVideoTrackEvent) {
        _setRemoteVideoEnabled(event);
      } else if (event is RemoteAudioTrackEvent) {
        _setRemoteAudioEnabled(event);
      }
    } else {
      final bufferedParticipant = _participantBuffer.firstWhereOrNull(
        (ParticipantBuffer participant) =>
            participant.id == event.remoteParticipant.sid,
      );
      if (bufferedParticipant != null) {
        _participantBuffer.remove(bufferedParticipant);
      } else if (event is RemoteAudioTrackEvent) {
        debugPrint(
            'Audio subscription came first, waiting for the video subscription...');
        _participantBuffer.add(
          ParticipantBuffer(
            id: event.remoteParticipant.sid,
            audioEnabled:
                event.remoteAudioTrackPublication.remoteAudioTrack?.isEnabled ??
                    true,
          ),
        );
        return;
      }
      if (event is RemoteVideoTrackSubscriptionEvent) {
        debugPrint(
            '[ APPDEBUG ] New participant, adding: ${event.remoteParticipant.sid}');
        participantsList.insert(
          0,
          _buildParticipant(
            child: event.remoteVideoTrack.widget(),
            id: event.remoteParticipant.sid,
            remoteParticipant: event.remoteParticipant,
            audioEnabled: bufferedParticipant?.audioEnabled ?? true,
            videoEnabled:
                event.remoteVideoTrackPublication.remoteVideoTrack?.isEnabled ??
                    true,
          ),
        );
        reload();
      }
    }
  }

  @action
  Future<void> toggleVideoEnabled() async {
    final tracks = _room!.localParticipant?.localVideoTracks ?? [];
    final localVideoTrack = tracks.isEmpty ? null : tracks[0].localVideoTrack;
    if (localVideoTrack == null) {
      debugPrint(
          'ConferenceRoom.toggleVideoEnabled() => Track is not available yet!');
      return;
    }
    await localVideoTrack.enable(!localVideoTrack.isEnabled);

    var index = participantsList
        .indexWhere((ParticipantWidget participant) => !participant.isRemote);
    if (index < 0) {
      return;
    }
    participantsList[index] = participantsList[index]
        .copyWith(videoEnabled: localVideoTrack.isEnabled);
    debugPrint(
        'ConferenceRoom.toggleVideoEnabled() => ${localVideoTrack.isEnabled}');
    _onVideoEnabledStreamController.add(localVideoTrack.isEnabled);

    isCameraOn = localVideoTrack.isEnabled;
  }

  Future<void> switchCamera() async {
    debugPrint('ConferenceRoom.switchCamera()');
    final sources = await CameraSource.getSources();
    if (sources.length > 1) {
      final source = sources.firstWhere((source) {
        if (_cameraCapturer!.source!.isFrontFacing) {
          return source.isBackFacing;
        }
        return source.isFrontFacing;
      });

      await _cameraCapturer!.switchCamera(source);
    } else if (sources.isNotEmpty) {
      await _cameraCapturer!.switchCamera(sources.first);
    }
  }

  @action
  Future<void> toggleAudioEnabled() async {
    final tracks = _room!.localParticipant?.localAudioTracks ?? [];
    final localAudioTrack = tracks.isEmpty ? null : tracks[0].localAudioTrack;
    if (localAudioTrack == null) {
      debugPrint(
          'ConferenceRoom.toggleAudioEnabled() => Track is not available yet!');
      return;
    }
    await localAudioTrack.enable(!localAudioTrack.isEnabled);

    var index = participantsList
        .indexWhere((ParticipantWidget participant) => !participant.isRemote);
    if (index < 0) {
      return;
    }
    participantsList[index] = participantsList[index]
        .copyWith(audioEnabled: localAudioTrack.isEnabled);
    debugPrint(
        'ConferenceRoom.toggleAudioEnabled() => ${localAudioTrack.isEnabled}');
    _onAudioEnabledStreamController.add(localAudioTrack.isEnabled);

    isMicrophoneOn = localAudioTrack.isEnabled;
  }

  void _setRemoteAudioEnabled(RemoteAudioTrackEvent event) {
    var index = participantsList.indexWhere((ParticipantWidget participant) =>
        participant.id == event.remoteParticipant.sid);
    if (index < 0) {
      return;
    }
    participantsList[index] = participantsList[index].copyWith(
        audioEnabled: event.remoteAudioTrackPublication.isTrackEnabled);
  }

  void _setRemoteVideoEnabled(RemoteVideoTrackEvent event) {
    var index = participantsList.indexWhere((ParticipantWidget participant) =>
        participant.id == event.remoteParticipant.sid);
    if (index < 0) {
      return;
    }
    participantsList[index] = participantsList[index].copyWith(
        videoEnabled: event.remoteVideoTrackPublication.isTrackEnabled);
  }

  @action
  reload() {
    setMode(ConferenceMode.conferenceInitial);
    setMode(ConferenceMode.conferenceLoaded);
  }

  Future<void> _disposeStreamsAndSubscriptions() async {
    await _onAudioEnabledStreamController.close();
    await _onVideoEnabledStreamController.close();
    for (var streamSubscription in streamSubscriptions) {
      await streamSubscription.cancel();
    }
  }

  void _onAudioTrackDisabled(RemoteAudioTrackEvent event) {
    debugPrint(
        'ConferenceRoom._onAudioTrackDisabled(), ${event.remoteParticipant.sid}, ${event.remoteAudioTrackPublication.trackSid}, isEnabled: ${event.remoteAudioTrackPublication.isTrackEnabled}');
    _setRemoteAudioEnabled(event);
  }

  void _onAudioTrackEnabled(RemoteAudioTrackEvent event) {
    debugPrint(
        'ConferenceRoom._onAudioTrackEnabled(), ${event.remoteParticipant.sid}, ${event.remoteAudioTrackPublication.trackSid}, isEnabled: ${event.remoteAudioTrackPublication.isTrackEnabled}');
    _setRemoteAudioEnabled(event);
  }

  void _onVideoTrackDisabled(RemoteVideoTrackEvent event) {
    debugPrint(
        'ConferenceRoom._onVideoTrackDisabled(), ${event.remoteParticipant.sid}, ${event.remoteVideoTrackPublication.trackSid}, isEnabled: ${event.remoteVideoTrackPublication.isTrackEnabled}');
    _setRemoteVideoEnabled(event);
  }

  void _onVideoTrackEnabled(RemoteVideoTrackEvent event) {
    debugPrint(
        'ConferenceRoom._onVideoTrackEnabled(), ${event.remoteParticipant.sid}, ${event.remoteVideoTrackPublication.trackSid}, isEnabled: ${event.remoteVideoTrackPublication.isTrackEnabled}');
    _setRemoteVideoEnabled(event);
  }

  void _onConnectFailure(RoomConnectFailureEvent event) {
    debugPrint(
        '[ APPDEBUG ] ConferenceRoom._onConnectFailure: ${event.exception}');
  }

  void _onDisconnected(RoomDisconnectedEvent event) {
    debugPrint('[ APPDEBUG ] ConferenceRoom._onDisconnected');
  }

  void _onReconnecting(RoomReconnectingEvent room) {
    debugPrint('[ APPDEBUG ] ConferenceRoom._onReconnecting');
  }
}
