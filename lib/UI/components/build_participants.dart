import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:twilio_video_calls/states/conference_state.dart';
import 'package:twilio_video_calls/utils/di.dart';

class BuildParticipants extends StatelessWidget {
  const BuildParticipants({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final conferenceState = serviceLocator<ConferenceState>();
    return Observer(builder: (_) {
      return Stack(children: [
        ListView.builder(
            itemCount: conferenceState.participantsList.length,
            itemBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: height * 0.5,
                child: Stack(
                  children: [
                    conferenceState.participantsList[index].child,
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!conferenceState
                              .participantsList[index].videoEnabled)
                            const CircleAvatar(
                              maxRadius: 40,
                              backgroundColor: Colors.transparent,
                              child: FittedBox(
                                child: Icon(
                                  Icons.videocam_off,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          if (!conferenceState
                              .participantsList[index].audioEnabled)
                            const CircleAvatar(
                              maxRadius: 40,
                              backgroundColor: Colors.transparent,
                              child: FittedBox(
                                child: Icon(
                                  Icons.mic_off,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            })
      ]);
    });
  }
}
