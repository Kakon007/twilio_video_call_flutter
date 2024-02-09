// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conference_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConferenceState on ConferenceStateBase, Store {
  late final _$tokenAtom =
      Atom(name: 'ConferenceStateBase.token', context: context);

  @override
  String get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(String value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  late final _$identityAtom =
      Atom(name: 'ConferenceStateBase.identity', context: context);

  @override
  String get identity {
    _$identityAtom.reportRead();
    return super.identity;
  }

  @override
  set identity(String value) {
    _$identityAtom.reportWrite(value, super.identity, () {
      super.identity = value;
    });
  }

  late final _$participantsListAtom =
      Atom(name: 'ConferenceStateBase.participantsList', context: context);

  @override
  ObservableList<ParticipantWidget> get participantsList {
    _$participantsListAtom.reportRead();
    return super.participantsList;
  }

  @override
  set participantsList(ObservableList<ParticipantWidget> value) {
    _$participantsListAtom.reportWrite(value, super.participantsList, () {
      super.participantsList = value;
    });
  }

  late final _$_cameraCapturerAtom =
      Atom(name: 'ConferenceStateBase._cameraCapturer', context: context);

  @override
  CameraCapturer? get _cameraCapturer {
    _$_cameraCapturerAtom.reportRead();
    return super._cameraCapturer;
  }

  @override
  set _cameraCapturer(CameraCapturer? value) {
    _$_cameraCapturerAtom.reportWrite(value, super._cameraCapturer, () {
      super._cameraCapturer = value;
    });
  }

  late final _$trackIdAtom =
      Atom(name: 'ConferenceStateBase.trackId', context: context);

  @override
  String? get trackId {
    _$trackIdAtom.reportRead();
    return super.trackId;
  }

  @override
  set trackId(String? value) {
    _$trackIdAtom.reportWrite(value, super.trackId, () {
      super.trackId = value;
    });
  }

  late final _$streamSubscriptionsAtom =
      Atom(name: 'ConferenceStateBase.streamSubscriptions', context: context);

  @override
  List<StreamSubscription<dynamic>> get streamSubscriptions {
    _$streamSubscriptionsAtom.reportRead();
    return super.streamSubscriptions;
  }

  @override
  set streamSubscriptions(List<StreamSubscription<dynamic>> value) {
    _$streamSubscriptionsAtom.reportWrite(value, super.streamSubscriptions, () {
      super.streamSubscriptions = value;
    });
  }

  late final _$modeAtom =
      Atom(name: 'ConferenceStateBase.mode', context: context);

  @override
  ConferenceMode? get mode {
    _$modeAtom.reportRead();
    return super.mode;
  }

  @override
  set mode(ConferenceMode? value) {
    _$modeAtom.reportWrite(value, super.mode, () {
      super.mode = value;
    });
  }

  late final _$isMicrophoneOnAtom =
      Atom(name: 'ConferenceStateBase.isMicrophoneOn', context: context);

  @override
  bool get isMicrophoneOn {
    _$isMicrophoneOnAtom.reportRead();
    return super.isMicrophoneOn;
  }

  @override
  set isMicrophoneOn(bool value) {
    _$isMicrophoneOnAtom.reportWrite(value, super.isMicrophoneOn, () {
      super.isMicrophoneOn = value;
    });
  }

  late final _$isCameraOnAtom =
      Atom(name: 'ConferenceStateBase.isCameraOn', context: context);

  @override
  bool get isCameraOn {
    _$isCameraOnAtom.reportRead();
    return super.isCameraOn;
  }

  @override
  set isCameraOn(bool value) {
    _$isCameraOnAtom.reportWrite(value, super.isCameraOn, () {
      super.isCameraOn = value;
    });
  }

  late final _$connectAsyncAction =
      AsyncAction('ConferenceStateBase.connect', context: context);

  @override
  Future connect() {
    return _$connectAsyncAction.run(() => super.connect());
  }

  late final _$disconnectAsyncAction =
      AsyncAction('ConferenceStateBase.disconnect', context: context);

  @override
  Future<void> disconnect() {
    return _$disconnectAsyncAction.run(() => super.disconnect());
  }

  late final _$toggleVideoEnabledAsyncAction =
      AsyncAction('ConferenceStateBase.toggleVideoEnabled', context: context);

  @override
  Future<void> toggleVideoEnabled() {
    return _$toggleVideoEnabledAsyncAction
        .run(() => super.toggleVideoEnabled());
  }

  late final _$toggleAudioEnabledAsyncAction =
      AsyncAction('ConferenceStateBase.toggleAudioEnabled', context: context);

  @override
  Future<void> toggleAudioEnabled() {
    return _$toggleAudioEnabledAsyncAction
        .run(() => super.toggleAudioEnabled());
  }

  late final _$ConferenceStateBaseActionController =
      ActionController(name: 'ConferenceStateBase', context: context);

  @override
  void setMode(ConferenceMode value) {
    final _$actionInfo = _$ConferenceStateBaseActionController.startAction(
        name: 'ConferenceStateBase.setMode');
    try {
      return super.setMode(value);
    } finally {
      _$ConferenceStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  ParticipantWidget _buildParticipant(
      {required Widget child,
      required String? id,
      required bool audioEnabled,
      required bool videoEnabled,
      RemoteParticipant? remoteParticipant}) {
    final _$actionInfo = _$ConferenceStateBaseActionController.startAction(
        name: 'ConferenceStateBase._buildParticipant');
    try {
      return super._buildParticipant(
          child: child,
          id: id,
          audioEnabled: audioEnabled,
          videoEnabled: videoEnabled,
          remoteParticipant: remoteParticipant);
    } finally {
      _$ConferenceStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _onConnected(Room room) {
    final _$actionInfo = _$ConferenceStateBaseActionController.startAction(
        name: 'ConferenceStateBase._onConnected');
    try {
      return super._onConnected(room);
    } finally {
      _$ConferenceStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _onParticipantConnected(RoomParticipantConnectedEvent event) {
    final _$actionInfo = _$ConferenceStateBaseActionController.startAction(
        name: 'ConferenceStateBase._onParticipantConnected');
    try {
      return super._onParticipantConnected(event);
    } finally {
      _$ConferenceStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _onParticipantDisconnected(RoomParticipantDisconnectedEvent event) {
    final _$actionInfo = _$ConferenceStateBaseActionController.startAction(
        name: 'ConferenceStateBase._onParticipantDisconnected');
    try {
      return super._onParticipantDisconnected(event);
    } finally {
      _$ConferenceStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _addRemoteParticipantListeners(RemoteParticipant remoteParticipant) {
    final _$actionInfo = _$ConferenceStateBaseActionController.startAction(
        name: 'ConferenceStateBase._addRemoteParticipantListeners');
    try {
      return super._addRemoteParticipantListeners(remoteParticipant);
    } finally {
      _$ConferenceStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _addOrUpdateParticipant(RemoteParticipantEvent event) {
    final _$actionInfo = _$ConferenceStateBaseActionController.startAction(
        name: 'ConferenceStateBase._addOrUpdateParticipant');
    try {
      return super._addOrUpdateParticipant(event);
    } finally {
      _$ConferenceStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic reload() {
    final _$actionInfo = _$ConferenceStateBaseActionController.startAction(
        name: 'ConferenceStateBase.reload');
    try {
      return super.reload();
    } finally {
      _$ConferenceStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
token: ${token},
identity: ${identity},
participantsList: ${participantsList},
trackId: ${trackId},
streamSubscriptions: ${streamSubscriptions},
mode: ${mode},
isMicrophoneOn: ${isMicrophoneOn},
isCameraOn: ${isCameraOn}
    ''';
  }
}
