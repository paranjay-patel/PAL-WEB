import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';

class WifiPasswordTextInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final String errorTextMessage;
  final bool isInvalid;
  final bool shouldShowPassword;
  final Function(String) onChanged;
  final Function() onEyeTap;

  const WifiPasswordTextInput({
    Key? key,
    required this.textEditingController,
    required this.focusNode,
    required this.errorTextMessage,
    required this.onChanged,
    required this.onEyeTap,
    this.shouldShowPassword = false,
    this.isInvalid = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;
    final style = TextStyle(
      color: theme.titleTextColor,
      fontSize: screenSize.getFontSize(min: 14, max: 20),
      fontWeight: FontWeight.bold,
    );
    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: isInvalid ? ThemeColors.red : ThemeColors.blue50,
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(screenSize.getHeight(min: 10, max: 16)),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: TextStyle(
            fontSize: screenSize.getFontSize(min: 14, max: 16),
            fontWeight: FontWeight.w600,
            color: isInvalid ? ThemeColors.red : ThemeColors.blue50,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: screenSize.getHeight(min: 2, max: 4)),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: TextField(
                  controller: textEditingController,
                  textInputAction: TextInputAction.done,
                  obscureText: shouldShowPassword ? false : true,
                  enableSuggestions: true,
                  autocorrect: false,
                  readOnly: true,
                  showCursor: true,
                  maxLines: 1,
                  focusNode: focusNode,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  cursorColor: ThemeColors.blue50,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.transparent,
                    filled: true,
                    enabledBorder: border,
                    focusedBorder: border,
                    isDense: true,
                    hintText: 'Enter your wifi password',
                    hintStyle: style.copyWith(color: theme.wifiSubTitleTextColor),
                  ),
                  onChanged: (newVal) {
                    onChanged(newVal);
                  },
                  onTap: () {
                    // Open custom keyboard and request focus

                    FocusScope.of(context).requestFocus(focusNode);
                  },
                  style: style,
                ),
              ),
            ),
            SizedBox(width: screenSize.getWidth(min: 8, max: 12)),
            FeedbackSoundWrapper(
              onTap: () {
                onEyeTap();
              },
              child: Container(
                height: screenSize.getHeight(min: 46, max: 56),
                width: screenSize.getWidth(min: 46, max: 56),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenSize.getHeight(min: 10, max: 16)),
                    border: Border.all(
                      color: ThemeColors.blue50,
                      width: 2,
                    )),
                child: (shouldShowPassword ? Assets.eyeHide : Assets.eye).toSvgPicture(
                  color: ThemeColors.blue50,
                  width: screenSize.getWidth(min: 18, max: 24),
                  height: screenSize.getHeight(min: 18, max: 24),
                ),
              ),
            ),
          ],
        ),
        if (isInvalid)
          Padding(
            padding: EdgeInsets.only(
              top: screenSize.getHeight(min: 2, max: 4),
              left: screenSize.getWidth(min: 2, max: 4),
            ),
            child: Text(
              errorTextMessage,
              style: TextStyle(
                fontSize: screenSize.getFontSize(min: 10, max: 12),
                fontWeight: FontWeight.w500,
                color: ThemeColors.red,
              ),
            ),
          ),
      ],
    );
  }
}
