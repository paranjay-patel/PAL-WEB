import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/common/themed_activity_indicator.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/store/sauna_control_popup_page.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/store/sauna_wifi.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_network_page/widgets/wifi_password_text_input.dart';

class SaunaJoinWifi extends StatefulWidget {
  final SaunaWifiStore store;
  final FocusNode focusNode;
  final SaunaControlPopupPageStore saunaControlPopupPageStore;
  final TextEditingController textEditingController;

  const SaunaJoinWifi({
    Key? key,
    required this.store,
    required this.focusNode,
    required this.saunaControlPopupPageStore,
    required this.textEditingController,
  }) : super(key: key);

  @override
  SaunaJoinWifiState createState() => SaunaJoinWifiState();
}

class SaunaJoinWifiState extends State<SaunaJoinWifi> {
  @override
  void initState() {
    super.initState();
    widget.textEditingController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: screenSize.getWidth(min: 48, max: 78)),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Observer(
            builder: (_) {
              final isIncorrectPassword = widget.store.isIncorrectPassword ?? false;
              return WifiPasswordTextInput(
                textEditingController: widget.textEditingController,
                focusNode: widget.focusNode,
                errorTextMessage: 'Password is incorrect',
                isInvalid: isIncorrectPassword,
                shouldShowPassword: widget.store.showPassword,
                onEyeTap: () {
                  widget.store.shouldShowPassword();
                },
                onChanged: (_) {},
              );
            },
          ),
          SizedBox(height: screenSize.getHeight(min: 18, max: 28)),
          Row(
            children: [
              const Spacer(),
              _buildBackButton(),
              SizedBox(width: screenSize.getWidth(min: 12, max: 20)),
              _buildJoinButton(),
            ],
          ),
          _buildLoadingView(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    final screenSize = Utils.getScreenSize(context);
    return FeedbackSoundWrapper(
      onTap: () {
        if (widget.store.connectingWifi) return;
        widget.store.setIsIncorrectPassword(false);
        widget.store.setConnectWifiPopup(false);
      },
      child: Container(
        height: screenSize.getHeight(min: 50, max: 60),
        width: screenSize.getWidth(min: 90, max: 120),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenSize.getHeight(min: 14, max: 20)),
          color: ThemeColors.blue10,
        ),
        alignment: Alignment.center,
        child: Text(
          'Back',
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

  Widget _buildJoinButton() {
    final screenSize = Utils.getScreenSize(context);
    return FeedbackSoundWrapper(
      onTap: () async {
        if (widget.store.connectingWifi) return;
        final password = widget.textEditingController.text;
        await widget.store.connectWifi(password: password);
        final isIncorrectPassword = widget.store.isIncorrectPassword ?? false;
        if (isIncorrectPassword) return;
      },
      child: Container(
        height: screenSize.getHeight(min: 50, max: 60),
        width: screenSize.getWidth(min: 90, max: 120),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenSize.getHeight(min: 14, max: 20)),
          color: widget.store.connectingWifi ? ThemeColors.blue50.withOpacity(.5) : ThemeColors.blue50,
        ),
        child: Text(
          'Join',
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

  Widget _buildLoadingView() {
    final screenSize = Utils.getScreenSize(context);
    return Observer(
      builder: (_) {
        final connectingWifi = widget.store.connectingWifi;
        if (!connectingWifi) return const SizedBox();
        return Column(
          children: [
            SizedBox(height: screenSize.getHeight(min: 50, max: 70)),
            const ThemedActivityIndicator(),
            SizedBox(height: screenSize.getHeight(min: 4, max: 8)),
            Text(
              'WiFi is connecting',
              style: TextStyle(
                fontSize: screenSize.getFontSize(min: 12, max: 16),
                fontWeight: FontWeight.w600,
                color: ThemeColors.grey70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
