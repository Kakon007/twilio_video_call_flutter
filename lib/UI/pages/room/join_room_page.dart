import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:twilio_video_calls/UI/pages/conference/conference_page.dart';
import 'package:flutter/material.dart';
import 'package:twilio_video_calls/services/permission_request.dart';
import 'package:twilio_video_calls/states/join_room_state.dart';
import 'package:twilio_video_calls/utils/di.dart';
import 'package:twilio_video_calls/states/conference_state.dart';

class JoinRoomPage extends StatefulWidget {

  const JoinRoomPage({super.key});

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  final conferenceState = serviceLocator<ConferenceState>();

  final joinRoomState = serviceLocator<JoinRoomState>();

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    PermissionRequest.requestBluetoothConnect();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Observer(builder: (_) {
            var isLoading = false;
            if (joinRoomState.joinRoomMode == JoinRoomMode.roomLoading) {
              isLoading = true;
            }

            return Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            key: const Key('enter-name'),
                            decoration: InputDecoration(
                              labelText: 'Enter your name',
                              enabled: !isLoading,
                            ),
                            controller: _nameController,
                            onChanged: (newValue) =>
                                joinRoomState.name = newValue,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          (isLoading == true)
                              ? const LinearProgressIndicator()
                              : ElevatedButton(
                                  onPressed: () async {
                                    _nameController.clear();
                                    await joinRoomState.submit();
                                    if (context.mounted) {
                                      if (joinRoomState.joinRoomMode ==
                                          JoinRoomMode.roomLoaded) {
                                        await Navigator.of(context).push(
                                          MaterialPageRoute<ConferencePage>(
                                              fullscreenDialog: true,
                                              builder: (BuildContext context) {
                                                conferenceState.identity =
                                                    joinRoomState.identity;
                                                conferenceState.token =
                                                    joinRoomState.token;
                                                conferenceState.connect();
                                                joinRoomState.clearInfo();
                                                return ConferencePage();
                                              }),
                                        );
                                      }
                                    }
                                  },
                                  child: const Text('Enter the room')),
                          (joinRoomState.joinRoomMode == JoinRoomMode.roomError)
                              ? Text(
                                  joinRoomState.error,
                                  style: const TextStyle(color: Colors.red),
                                )
                              : Container(),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    )
                  ]),
            );
          }),
        ),
      ),
    );
  }
}
