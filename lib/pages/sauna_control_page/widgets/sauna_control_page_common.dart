import 'package:flutter/material.dart';
import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/sauna_system_extension.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/wifi_state_extension.dart';
import 'package:found_space_flutter_web_application/common/svg_asset_image.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';

enum SaunaMode { dashboard, simple, turnOffScreen }

enum AudioControlMenu { sound, music }

enum RightActionButtons { cloud, network, bluetooth }

enum SaunaBottomButton {
  temperature,
  programTime,
  light,
  audio,
  saverAndSleepMode,
  colorTheme,
  advancedSettings,
  debug,
}

enum SaunaStateButtonType {
  heatSauna,
  stopHeating,
  startSession,
  finishSession,
  pauseSession,
  continueSession,
  cancelSession
}

enum SaunaControlPopupPageButtonArrow { forward, backward }

enum IncrementDecrementButtonType { increment, decrement }

enum SaunaTimeSettingType { system, manual }

enum SaunaLightControlType { rgb, mono, both, none }

enum SaunaLightTabType { rgb, mono }

enum SaunaAdvanceSettingsTabType { general, soundAndTemperature, security }

extension RightActionButtonsExtension on RightActionButtons {
  String icon(
    BuildContext context, {
    required bool isInternetConnected,
    required WifiState wifiState,
    required int signal,
    required BluetoothState bluetoothState,
    required NetworkMode networkMode,
    required EthernetStatus ethernetStatus,
  }) {
    switch (this) {
      case RightActionButtons.network:
        switch (networkMode) {
          case NetworkMode.unknown:
          case NetworkMode.none:
            return Assets.networkDisconnect.assetName;
          case NetworkMode.wifi:
            return wifiState.wifiIcon(context, signal: signal);
          case NetworkMode.ethernet:
            return ethernetStatus == EthernetStatus.up ? Assets.ethernetOn.assetName : Assets.ethernetOff.assetName;
        }
      case RightActionButtons.cloud:
        return isInternetConnected ? Assets.cloud.assetName : Assets.cloudOff.assetName;
      case RightActionButtons.bluetooth:
        switch (bluetoothState) {
          case BluetoothState.enabled:
            return Assets.bluetooth.assetName;
          case BluetoothState.disabled:
            return Assets.bluetoothOff.assetName;
          case BluetoothState.connected:
            return Theme.of(context).colorScheme.bluetoothActive;
        }
    }
  }
}

extension SaunaModeExtension on SaunaMode {
  SvgAssetImage get icon {
    switch (this) {
      case SaunaMode.dashboard:
        return Assets.dashboardMode;
      case SaunaMode.simple:
        return Assets.simpleMode;
      case SaunaMode.turnOffScreen:
        return Assets.turnOffScreen;
    }
  }

  Color tabBarBackgroundColor(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    switch (this) {
      case SaunaMode.dashboard:
        return theme.tabBarBackgroundColor;
      case SaunaMode.simple:
      case SaunaMode.turnOffScreen:
        return ThemeColors.dark70;
    }
  }

  Color buttonBackgroundColor(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    switch (this) {
      case SaunaMode.dashboard:
        return theme.buttonBackgroundColor;
      case SaunaMode.simple:
      case SaunaMode.turnOffScreen:
        return ThemeColors.dark60;
    }
  }

  Color iconColor(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    switch (this) {
      case SaunaMode.dashboard:
        return theme.iconColor;
      case SaunaMode.simple:
      case SaunaMode.turnOffScreen:
        return ThemeColors.orange10;
    }
  }

  List<BoxShadow> innerPageViewShadow(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    switch (this) {
      case SaunaMode.dashboard:
        return theme.innerPageViewShadow;
      case SaunaMode.simple:
      case SaunaMode.turnOffScreen:
        return [
          BoxShadow(
            blurStyle: BlurStyle.inner,
            color: const Color(0xff070707).withOpacity(.4),
            blurRadius: 24,
            offset: const Offset(0, 0),
          ),
          BoxShadow(
            blurStyle: BlurStyle.inner,
            color: ThemeColors.neutral900.withOpacity(0.20),
            blurRadius: 12,
            offset: const Offset(0, 0),
          ),
        ];
    }
  }

  List<BoxShadow> saunaControlPageButtonShadow(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    switch (this) {
      case SaunaMode.dashboard:
        return theme.saunaControlPageButtonShadow;
      case SaunaMode.simple:
      case SaunaMode.turnOffScreen:
        return [
          BoxShadow(
            color: ThemeColors.neutral900.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: ThemeColors.neutral900.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(4, 4),
          ),
          BoxShadow(
            color: ThemeColors.neutral900.withOpacity(0.14),
            blurRadius: 8,
            offset: const Offset(0, 8),
          ),
        ];
    }
  }
}

extension SaunaBottomButtonExtension on SaunaBottomButton {
  String iconName(BuildContext context, {bool isAudioPlaying = false, bool isLightOn = false}) {
    final theme = Theme.of(context).colorScheme;
    switch (this) {
      case SaunaBottomButton.temperature:
      case SaunaBottomButton.programTime:
        return '';
      case SaunaBottomButton.advancedSettings:
        return theme.advancedSettings;
      case SaunaBottomButton.light:
        return isLightOn ? theme.overheadLight : theme.overheadLightOff;
      case SaunaBottomButton.audio:
        return isAudioPlaying ? theme.soundOn : theme.soundOff;
      case SaunaBottomButton.saverAndSleepMode:
        return theme.simpleSleepMode;
      case SaunaBottomButton.colorTheme:
        return theme.colorMode;
      case SaunaBottomButton.debug:
        return Assets.settings.assetName;
    }
  }

  String titleText({bool isNightMode = false}) {
    switch (this) {
      case SaunaBottomButton.temperature:
        return 'Temperature';
      case SaunaBottomButton.programTime:
        return 'Time';
      case SaunaBottomButton.light:
        return 'Lights';
      case SaunaBottomButton.audio:
        return 'Audio';
      case SaunaBottomButton.saverAndSleepMode:
        return "Focus & Sleep Mode";
      case SaunaBottomButton.colorTheme:
        return "Color Theme: ${isNightMode ? 'Dark' : 'Light'}";
      case SaunaBottomButton.advancedSettings:
        return "Advanced Settings";
      case SaunaBottomButton.debug:
        return "Debug";
    }
  }

  SaunaBottomButton get nextButtonType {
    switch (this) {
      case SaunaBottomButton.temperature:
        return SaunaBottomButton.programTime;
      case SaunaBottomButton.programTime:
        return SaunaBottomButton.light;
      case SaunaBottomButton.light:
        return SaunaBottomButton.audio;
      case SaunaBottomButton.audio:
        return SaunaBottomButton.audio;
      case SaunaBottomButton.saverAndSleepMode:
        return SaunaBottomButton.colorTheme;
      case SaunaBottomButton.colorTheme:
        return SaunaBottomButton.advancedSettings;
      case SaunaBottomButton.advancedSettings:
        return SaunaBottomButton.debug;
      case SaunaBottomButton.debug:
        return SaunaBottomButton.debug;
    }
  }

  SaunaBottomButton get prevButtonType {
    switch (this) {
      case SaunaBottomButton.temperature:
        return SaunaBottomButton.temperature;
      case SaunaBottomButton.programTime:
        return SaunaBottomButton.temperature;
      case SaunaBottomButton.light:
        return SaunaBottomButton.programTime;
      case SaunaBottomButton.audio:
        return SaunaBottomButton.light;
      case SaunaBottomButton.saverAndSleepMode:
        return SaunaBottomButton.saverAndSleepMode;
      case SaunaBottomButton.colorTheme:
        return SaunaBottomButton.saverAndSleepMode;
      case SaunaBottomButton.advancedSettings:
        return SaunaBottomButton.colorTheme;
      case SaunaBottomButton.debug:
        return SaunaBottomButton.advancedSettings;
    }
  }

  bool get isAudioControl {
    return this == SaunaBottomButton.audio;
  }

  bool get shouldShowText {
    return this == SaunaBottomButton.temperature || this == SaunaBottomButton.programTime;
  }

  String lightOnOffValue(bool state) {
    return state ? "on" : "off";
  }
}

extension SaunaStateExtension on SaunaState {
  String get subtitleText {
    switch (this) {
      case SaunaState.standby:
        return 'Sauna is in standby';
      case SaunaState.heating:
        return 'Sauna is heating';
      case SaunaState.ready:
        return 'Sauna is ready';
      case SaunaState.insession:
        return 'Sauna is in session';
      case SaunaState.paused:
        return 'Sauna is paused';
      case SaunaState.fault:
        return "SAUNA FAULT";
      case SaunaState.done:
        return 'Sauna session finished';
      case SaunaState.unknown:
        return '';
    }
  }

  SaunaState get changeState {
    switch (this) {
      case SaunaState.standby:
        return SaunaState.heating;
      case SaunaState.heating:
        return SaunaState.standby;
      case SaunaState.ready:
        return SaunaState.insession;
      case SaunaState.insession:
        return SaunaState.paused;
      case SaunaState.paused:
        return SaunaState.paused;
      case SaunaState.fault:
      case SaunaState.unknown:
        return SaunaState.fault;
      case SaunaState.done:
        return SaunaState.heating;
    }
  }

  Color get color {
    switch (this) {
      case SaunaState.standby:
      case SaunaState.ready:
      case SaunaState.paused:
      case SaunaState.done:
        return ThemeColors.blue50;
      case SaunaState.insession:
      case SaunaState.heating:
        return ThemeColors.orange60;
      case SaunaState.fault:
      case SaunaState.unknown:
        return Colors.transparent;
    }
  }

  List<SaunaStateButtonType> get getStateTypes {
    switch (this) {
      case SaunaState.standby:
      case SaunaState.done:
        return [SaunaStateButtonType.heatSauna];
      case SaunaState.heating:
        return [SaunaStateButtonType.stopHeating, SaunaStateButtonType.startSession];
      case SaunaState.ready:
        return [SaunaStateButtonType.startSession, SaunaStateButtonType.cancelSession];
      case SaunaState.paused:
        return [SaunaStateButtonType.continueSession];
      case SaunaState.insession:
        return [SaunaStateButtonType.finishSession, SaunaStateButtonType.pauseSession];
      case SaunaState.fault:
      case SaunaState.unknown:
        return [];
    }
  }

  SaunaDeviceShadow getShadowColor(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    switch (this) {
      case SaunaState.standby:
        return SaunaDeviceShadow(theme.saunaStandbyShadow, hasShadow: false);
      case SaunaState.heating:
        return SaunaDeviceShadow(theme.saunaHeatingShadow, canGlow: true);
      case SaunaState.ready:
      case SaunaState.done:
        return SaunaDeviceShadow(theme.saunaReadyShadow);
      case SaunaState.paused:
        return SaunaDeviceShadow(theme.saunaPausedShadow);
      case SaunaState.insession:
        return SaunaDeviceShadow(theme.saunaInSessionShadow, canGlow: true);
      case SaunaState.fault:
      case SaunaState.unknown:
        return SaunaDeviceShadow(theme.saunaPausedShadow, hasShadow: false);
    }
  }
}

extension SaunaStateButtonTypeExtension on SaunaStateButtonType {
  String get title {
    switch (this) {
      case SaunaStateButtonType.heatSauna:
        return 'Start Heating';
      case SaunaStateButtonType.stopHeating:
        return 'Stop Heating';
      case SaunaStateButtonType.startSession:
        return 'Start Session';
      case SaunaStateButtonType.finishSession:
        return 'Finish Session';
      case SaunaStateButtonType.pauseSession:
        return 'Pause Session';
      case SaunaStateButtonType.continueSession:
        return 'Resume Session';
      case SaunaStateButtonType.cancelSession:
        return 'Cancel Session';
    }
  }
}

extension SaunaControlPopupPageButtonArrowExtension on SaunaControlPopupPageButtonArrow {
  SvgAssetImage get icon {
    switch (this) {
      case SaunaControlPopupPageButtonArrow.backward:
        return Assets.arrowLeft;
      case SaunaControlPopupPageButtonArrow.forward:
        return Assets.arrowRight;
    }
  }
}

extension AudioControlMenuExtension on AudioControlMenu {
  String get tabTitle {
    switch (this) {
      case AudioControlMenu.sound:
        return "Sounds";
      case AudioControlMenu.music:
        return "Music";
    }
  }
}

extension IncrementDecrementButtonTypeExtension on IncrementDecrementButtonType {
  bool get isIncrementType {
    return this == IncrementDecrementButtonType.increment;
  }
}

class SaunaDeviceShadow {
  final Color color;
  final bool hasShadow;
  final bool canGlow;
  SaunaDeviceShadow(this.color, {this.hasShadow = true, this.canGlow = false});
}

extension SaunaLightControlTypeExtension on SaunaLightControlType {
  String get title {
    switch (this) {
      case SaunaLightControlType.rgb:
        return 'Colour Therapy';
      case SaunaLightControlType.mono:
        return 'Mono';
      case SaunaLightControlType.both:
        return 'Lights';
      case SaunaLightControlType.none:
        return '';
    }
  }

  bool get isRgb {
    return this == SaunaLightControlType.rgb || this == SaunaLightControlType.both;
  }

  bool get isSegmentController {
    return this == SaunaLightControlType.both;
  }
}

extension SaunaLightTabTypeExtension on SaunaLightTabType {
  String get title {
    switch (this) {
      case SaunaLightTabType.rgb:
        return 'Colour Therapy';
      case SaunaLightTabType.mono:
        return 'Mono';
    }
  }
}

extension SaunaAdvanceSettingsTypeExtension on SaunaAdvanceSettingsTabType {
  String get title {
    switch (this) {
      case SaunaAdvanceSettingsTabType.general:
        return 'General';
      case SaunaAdvanceSettingsTabType.soundAndTemperature:
        return 'Sounds & Temperature';
      case SaunaAdvanceSettingsTabType.security:
        return 'Security';
    }
  }
}
