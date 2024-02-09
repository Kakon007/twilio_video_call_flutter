import 'package:flutter/material.dart';
import 'package:twilio_video_calls/UI/pages/room/join_room_page.dart';
import 'package:twilio_video_calls/utils/di.dart';

void main() {
  initGetIt();
  runApp(const TwilioProgrammableVideoExample());
}

class TwilioProgrammableVideoExample extends StatelessWidget {
  const TwilioProgrammableVideoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: JoinRoomPage(),
    );
  }
}
