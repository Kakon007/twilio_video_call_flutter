import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:twilio_video_calls/states/conference_state.dart';
import 'package:twilio_video_calls/utils/di.dart';

class BottomButtonBar extends StatelessWidget {
  BottomButtonBar({super.key});

  final conferenceState = serviceLocator<ConferenceState>();
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Align(
            alignment: const Alignment(1, 0.9),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.call_end_sharp,
                      color: Colors.blue,
                    ),
                    onPressed: () async {
                      conferenceState.disconnect();
                      Navigator.of(context).pop();
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      conferenceState.isMicrophoneOn
                          ? Icons.mic
                          : Icons.mic_off,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      conferenceState.toggleAudioEnabled();
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      conferenceState.isCameraOn
                          ? Icons.videocam
                          : Icons.videocam_off,
                      color: Colors.blue,
                    ),
                    onPressed: () async {
                      conferenceState.toggleVideoEnabled();
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.switch_video,
                      color: Colors.blue,
                    ),
                    onPressed: () async {
                      conferenceState.switchCamera();
                    },
                  ),
                ],
              ),
            )),
      );
    });
  }
}
