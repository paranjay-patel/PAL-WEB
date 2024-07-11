import 'package:flutter/material.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/svg_asset_image.dart';
import 'package:found_space_flutter_web_application/common/themed_activity_indicator.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';

enum ButtonType {
  play,
  pause,
  backward,
  forward,
  previous,
  next,
  musicNext,
  musicPrevious,
  musicRewind,
  musicForward,
}

class SaunaAudioActionButton extends StatelessWidget {
  final ButtonType type;
  final bool isLoading;
  final Function() onTap;
  final bool isDisabled;

  const SaunaAudioActionButton({
    Key? key,
    required this.type,
    this.isLoading = false,
    required this.onTap,
    this.isDisabled = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _screenSize = Utils.getScreenSize(context);
    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Container(
        height: _screenSize.getHeight(min: 46, max: 56),
        width: _screenSize.getHeight(min: 46, max: 56),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 14, max: 20)),
          border: type.showBorderOnly
              ? Border.all(color: ThemeColors.blue50.withOpacity(isDisabled ? 0.5 : 1), width: 2)
              : null,
          color: type.showBorderOnly ? null : ThemeColors.blue50,
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const ThemedActivityIndicator(radius: 8, isLightColorIndicator: true)
            : type.iconName.toSvgPicture(
                color: type.iconColor,
                height: _screenSize.getHeight(min: 20, max: 28),
                width: _screenSize.getHeight(min: 20, max: 28),
              ),
      ),
    );
  }
}

extension on ButtonType {
  SvgAssetImage get iconName {
    switch (this) {
      case ButtonType.play:
        return Assets.play;
      case ButtonType.pause:
        return Assets.pause;
      case ButtonType.backward:
        return Assets.backward;
      case ButtonType.forward:
        return Assets.forward;
      case ButtonType.previous:
        return Assets.previous;
      case ButtonType.next:
        return Assets.next;
      case ButtonType.musicRewind:
        return Assets.musicRewind;
      case ButtonType.musicForward:
        return Assets.musicForward;
      case ButtonType.musicNext:
        return Assets.arrowRight;
      case ButtonType.musicPrevious:
        return Assets.arrowLeft;
    }
  }

  Color get iconColor {
    switch (this) {
      case ButtonType.play:
      case ButtonType.pause:
        return Colors.white;
      case ButtonType.backward:
      case ButtonType.forward:
      case ButtonType.previous:
      case ButtonType.next:
      case ButtonType.musicRewind:
      case ButtonType.musicForward:
      case ButtonType.musicNext:
      case ButtonType.musicPrevious:
        return ThemeColors.blue50;
    }
  }

  bool get showBorderOnly => this != ButtonType.play && this != ButtonType.pause;
}
