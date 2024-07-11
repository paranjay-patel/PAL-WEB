import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';

class SaunaDebugMode extends StatefulWidget {
  const SaunaDebugMode({Key? key}) : super(key: key);

  @override
  _SaunaDebugModeState createState() => _SaunaDebugModeState();
}

class _SaunaDebugModeState extends State<SaunaDebugMode> {
  final textEditingController = TextEditingController();
  final _saunaStore = locator<SaunaStore>();

  @override
  void initState() {
    super.initState();
    textEditingController.text = '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);

    return Observer(
      builder: (context) {
        final json = _saunaStore.saunaIdentity?.toJson() ?? {};
        const encoder = JsonEncoder.withIndent('    ');
        String prettyprint = encoder.convert(json);
        return Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: screenSize.getWidth(min: 48, max: 78)),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                WifiPasswordTextInput(
                  topText: _saunaStore.currentHostAPI,
                  textEditingController: textEditingController,
                  errorTextMessage: 'Incorrect IP address',
                  onChanged: (_) {},
                  onEyeTap: () {},
                ),
                SizedBox(height: screenSize.getHeight(min: 18, max: 28)),
                Row(
                  children: [
                    const Spacer(),
                    _buildResetButton(),
                    SizedBox(width: screenSize.getWidth(min: 12, max: 20)),
                    _buildConfirmButton(),
                  ],
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        prettyprint,
                        style: TextStyle(
                          fontSize: screenSize.getFontSize(min: 10, max: 16),
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.titleTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResetButton() {
    final screenSize = Utils.getScreenSize(context);
    return InkWell(
      onTap: () {
        _saunaStore.resetAPIHost();
        textEditingController.text = '';
      },
      child: Container(
        height: screenSize.getHeight(min: 50, max: 60),
        width: screenSize.getWidth(min: 170, max: 220),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenSize.getHeight(min: 14, max: 20)),
          color: ThemeColors.blue10,
        ),
        alignment: Alignment.center,
        child: Text(
          'Reset to Default',
          style: TextStyle(
            fontSize: screenSize.getFontSize(min: 14, max: 20),
            fontWeight: FontWeight.w600,
            color: ThemeColors.blue50,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    final screenSize = Utils.getScreenSize(context);
    return InkWell(
      onTap: () async {
        _saunaStore.setCurrentAPIHost(textEditingController.text);
      },
      child: Container(
        height: screenSize.getHeight(min: 50, max: 60),
        width: screenSize.getWidth(min: 90, max: 120),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenSize.getHeight(min: 14, max: 20)),
          color: ThemeColors.blue50,
        ),
        child: Text(
          'Confirm',
          style: TextStyle(
            fontSize: screenSize.getFontSize(min: 14, max: 20),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class WifiPasswordTextInput extends StatelessWidget {
  final String topText;
  final TextEditingController textEditingController;
  final String errorTextMessage;
  final bool isInvalid;
  final bool shouldShowPassword;
  final Function(String) onChanged;
  final Function() onEyeTap;

  const WifiPasswordTextInput({
    Key? key,
    required this.topText,
    required this.textEditingController,
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
      color: Colors.black,
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
          topText,
          style: TextStyle(
            fontSize: screenSize.getFontSize(min: 14, max: 16),
            fontWeight: FontWeight.w600,
            color: isInvalid ? ThemeColors.red : ThemeColors.blue50,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: screenSize.getHeight(min: 10, max: 20)),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: textEditingController,
                textInputAction: TextInputAction.done,
                enableSuggestions: true,
                autocorrect: false,
                maxLines: 1,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                cursorColor: ThemeColors.blue50,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.transparent,
                  filled: true,
                  enabledBorder: border,
                  focusedBorder: border,
                  isDense: true,
                  hintText: 'Enter IP address',
                  hintStyle: style.copyWith(color: theme.wifiSubTitleTextColor),
                ),
                onChanged: (newVal) {
                  onChanged(newVal);
                },
                style: style,
              ),
            ),
            SizedBox(width: screenSize.getWidth(min: 8, max: 12)),
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
                fontSize: screenSize.getFontSize(min: 8, max: 12),
                fontWeight: FontWeight.w500,
                color: ThemeColors.red,
              ),
            ),
          ),
      ],
    );
  }
}
