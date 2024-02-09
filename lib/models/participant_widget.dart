import 'package:flutter/material.dart';

class ParticipantWidget {
  final Widget child;
  final String? id;
  final bool audioEnabled;
  final bool videoEnabled;
  final bool isRemote;

  const ParticipantWidget({
    required this.child,
    required this.id,
    required this.audioEnabled,
    required this.videoEnabled,
    required this.isRemote,
  });

  ParticipantWidget copyWith({
    Widget? child,
    bool? audioEnabled,
    bool? videoEnabled,
    bool? isDominant,
    bool? audioEnabledLocally,
  }) {
    return ParticipantWidget(
      id: id,
      audioEnabled: audioEnabled ?? this.audioEnabled,
      videoEnabled: videoEnabled ?? this.videoEnabled,
      isRemote: isRemote,
      child: child ?? this.child,
    );
  }
}
