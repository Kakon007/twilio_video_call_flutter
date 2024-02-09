import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:twilio_video_calls/UI/components/build_participants.dart';
import 'package:twilio_video_calls/UI/components/progress_loader.dart';
import 'package:twilio_video_calls/UI/pages/conference/components/bottom_button_bar.dart';
import 'package:twilio_video_calls/utils/di.dart';
import 'package:twilio_video_calls/states/conference_state.dart';

class ConferencePage extends StatelessWidget {
  ConferencePage({super.key});

  final conferenceState = serviceLocator<ConferenceState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Observer(builder: (_) {
        debugPrint("\x1B[33mSTATE IS ${conferenceState.mode}\x1B[0m");
        return Stack(
          children: <Widget>[
            if (conferenceState.mode == ConferenceMode.conferenceLoaded)
              const BuildParticipants(),
            BottomButtonBar(),
            if (conferenceState.mode == ConferenceMode.conferenceInitial)
              const ProgressLoader(),
          ],
        );
      }),
    );
  }
}
