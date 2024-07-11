import 'package:flutter/material.dart';
import 'package:found_space_flutter_web_application/common/store/audio_player.store.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';

class FeedbackSoundWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool shouldPlay;

  const FeedbackSoundWrapper({
    required this.onTap,
    required this.child,
    this.shouldPlay = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (shouldPlay) locator<AudioPlayerStore>().playButtonFeedbackSound();
        onTap.call();
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: child,
    );
  }
}
