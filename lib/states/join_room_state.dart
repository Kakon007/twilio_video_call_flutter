import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:twilio_video_calls/services/twilio_service.dart';
part 'join_room_state.g.dart'; //This will automatically generated after: flutter pub run build_runner build

@singleton
class JoinRoomState = JoinRoomStateBase with _$JoinRoomState;

enum JoinRoomMode {
  roomLoading,

  roomLoaded,

  roomError
}

abstract class JoinRoomStateBase with Store {
  TwilioFunctionsService backendService = TwilioFunctionsService.instance;

  @observable
  String error = '';

  @observable
  String name = '';
  @observable
  String token = '';
  @observable
  String identity = '';

  @observable
  JoinRoomMode? joinRoomMode;

  @action
  void setMode(JoinRoomMode? value) {
    joinRoomMode = value;
  }

  @action
  clearInfo() {
    name = '';
    token = '';
    identity = '';
    error = '';
  }

  @action
  submit() async {
    setMode(JoinRoomMode.roomLoading);
    String? accessToken;
    try {
      if (name.isNotEmpty) {
        final twilioRoomTokenResponse = await backendService.createToken(name);
        accessToken = twilioRoomTokenResponse['accessToken'];
      }

      if (accessToken != null) {
        token = accessToken;
        identity = name;
        setMode(JoinRoomMode.roomLoaded);
      } else {
        setMode(JoinRoomMode.roomError);
        error = 'Access token is empty!';
      }
    } catch (e) {
      setMode(JoinRoomMode.roomError);
      error = 'Something wrong happened when getting the access token';
    } finally {}
  }
}
