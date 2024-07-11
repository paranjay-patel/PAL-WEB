import 'package:flutter/material.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';

class FlutterRoundedButtonAction extends StatelessWidget {
  final VoidCallback? onTapButtonPositive;
  final EdgeInsets? paddingActionBar;

  const FlutterRoundedButtonAction({
    Key? key,
    this.onTapButtonPositive,
    this.paddingActionBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    return FeedbackSoundWrapper(
      onTap: onTapButtonPositive ?? () {},
      child: Container(
        padding: paddingActionBar,
        height: screenSize.getHeight(min: 44, max: 54),
        width: double.infinity,
        decoration: BoxDecoration(
          color: ThemeColors.blue50,
          borderRadius: BorderRadius.circular(screenSize.getHeight(min: 13, max: 16)),
        ),
        alignment: Alignment.center,
        child: Text(
          'Set',
          style: TextStyle(
            fontSize: screenSize.getFontSize(min: 16, max: 20),
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
