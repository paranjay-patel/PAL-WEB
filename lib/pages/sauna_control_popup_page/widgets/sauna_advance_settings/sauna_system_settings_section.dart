import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';

enum SystemSettingsType {
  all,
  system,
  sessions,
  useFahrenheit,
  use24HourClock,
  settings,
  saunaPairing,
  enableWifiButton,
  enableBluetoothButton;

  String get title {
    switch (this) {
      case SystemSettingsType.all:
        return 'Sounds';
      case SystemSettingsType.system:
        return 'System Sounds';
      case SystemSettingsType.sessions:
        return 'Session Sounds';
      case SystemSettingsType.useFahrenheit:
        return 'Use Fahrenheit';
      case SystemSettingsType.use24HourClock:
        return 'Use 24 Hour Clock';
      case SystemSettingsType.settings:
        return 'Settings';
      case SystemSettingsType.saunaPairing:
        return 'Sauna pairing';
      case SystemSettingsType.enableWifiButton:
        return 'Enable Network button';
      case SystemSettingsType.enableBluetoothButton:
        return 'Enable Bluetooth button';
    }
  }

  bool get showLeadingSpace =>
      this == SystemSettingsType.system ||
      this == SystemSettingsType.sessions ||
      this == SystemSettingsType.settings ||
      this == SystemSettingsType.saunaPairing ||
      this == SystemSettingsType.enableWifiButton ||
      this == SystemSettingsType.enableBluetoothButton;
}

class SaunaSystemSettingsSection extends StatelessWidget {
  final SystemSettingsType type;
  final bool isOn;
  final bool isDisabled;
  final Function(bool)? onChanged;

  const SaunaSystemSettingsSection({
    this.type = SystemSettingsType.all,
    this.isOn = false,
    this.isDisabled = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;

    return Row(
      children: [
        if (type.showLeadingSpace) SizedBox(width: screenSize.getFontSize(min: 10, max: 12)),
        Text(
          type.title,
          style: TextStyle(
            color: isDisabled ? theme.tickColor : theme.titleTextColor,
            fontWeight: FontWeight.w500,
            fontSize: screenSize.getFontSize(min: 16, max: 20),
          ),
          textAlign: TextAlign.left,
        ),
        const Spacer(),
        Text(
          isOn ? 'ON' : 'OFF',
          style: TextStyle(
            color: isDisabled ? theme.tickColor : ThemeColors.primaryBlueColor,
            fontWeight: FontWeight.w600,
            fontSize: screenSize.getFontSize(min: 16, max: 20),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(width: screenSize.getFontSize(min: 6, max: 8)),
        CupertinoSwitch(
          value: isOn,
          activeColor: ThemeColors.blue50,
          onChanged: (value) {
            if (isDisabled) return;
            onChanged?.call(value);
          },
        ),
        SizedBox(width: screenSize.getFontSize(min: 10, max: 12)),
      ],
    );
  }
}
