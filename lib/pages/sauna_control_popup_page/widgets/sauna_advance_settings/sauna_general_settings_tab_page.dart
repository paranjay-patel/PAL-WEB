import 'package:flutter/material.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/store/sauna_control_popup_page.store.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';

class SaunaGeneralSettingsTabPage extends StatefulWidget {
  final SaunaControlPopupPageStore store;
  final Function() onRestartTap;
  final Function() onResetTap;

  const SaunaGeneralSettingsTabPage({
    Key? key,
    required this.store,
    required this.onRestartTap,
    required this.onResetTap,
  }) : super(key: key);

  @override
  State<SaunaGeneralSettingsTabPage> createState() => _SaunaGeneralSettingsTabPageState();
}

class _SaunaGeneralSettingsTabPageState extends State<SaunaGeneralSettingsTabPage> {
  final _saunaStore = locator<SaunaStore>();

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;
    final saunaSystem = _saunaStore.saunaSystem;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: screenSize.getHeight(min: 26, max: 32)),
        Text(
          saunaSystem?.modelName ?? '',
          style: TextStyle(
            fontSize: screenSize.getFontSize(min: 18, max: 24),
            fontWeight: FontWeight.w600,
            color: theme.titleTextColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenSize.getHeight(min: 8, max: 10)),
        Text(
          'Firmware version ${_saunaStore.firmwareVersion}',
          style: TextStyle(
            fontSize: screenSize.getFontSize(min: 16, max: 20),
            fontWeight: FontWeight.w500,
            color: theme.tickColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenSize.getHeight(min: 20, max: 26)),
        const Spacer(),
        _RestartButton(onTap: widget.onRestartTap),
        SizedBox(height: screenSize.getHeight(min: 16, max: 24)),
        _ResetButton(onTap: widget.onResetTap),
      ],
    );
  }
}

class _RestartButton extends StatelessWidget {
  final VoidCallback onTap;
  const _RestartButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);

    return FeedbackSoundWrapper(
      onTap: onTap,
      child: Container(
        height: screenSize.getHeight(min: 44, max: 54),
        width: screenSize.getWidth(min: 260, max: 330),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenSize.getHeight(min: 16, max: 20)),
          color: ThemeColors.primaryBlueColor,
        ),
        alignment: Alignment.center,
        child: Text(
          'Restart Sauna',
          style: TextStyle(
            color: ThemeColors.neutral000,
            fontWeight: FontWeight.w600,
            fontSize: screenSize.getFontSize(min: 14, max: 20),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ResetButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ResetButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);

    return FeedbackSoundWrapper(
      onTap: onTap,
      child: Container(
        height: screenSize.getHeight(min: 44, max: 54),
        width: screenSize.getWidth(min: 260, max: 330),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenSize.getHeight(min: 16, max: 20)),
          border: Border.all(color: ThemeColors.errorColor, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          'Reset to Factory Settings',
          style: TextStyle(
            color: ThemeColors.errorColor,
            fontWeight: FontWeight.w600,
            fontSize: screenSize.getFontSize(min: 14, max: 20),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
