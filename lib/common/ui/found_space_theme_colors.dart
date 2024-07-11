import 'package:flutter/material.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';

extension ColorSchemeExtension on ColorScheme {
  bool get isNightMode => brightness == Brightness.dark;
  List<Color> get backgroundGradientColors =>
      isNightMode ? [const Color(0xFF363944), const Color(0xFF090A0B)] : [ThemeColors.orange10, ThemeColors.orange10];

  List<Color> get splashBackgroundGradientColors =>
      isNightMode ? [const Color(0xFF363944), const Color(0xFF090A0B)] : [ThemeColors.orange20, ThemeColors.orange20];

  Color get buttonBackgroundColor => isNightMode ? ThemeColors.dark60 : Colors.white;

  Color get popupBackgroundColor => isNightMode ? ThemeColors.dark70 : Colors.white;

  Color get arrowBackgroundColor => isNightMode ? ThemeColors.dark50 : Colors.white;

  Color get iconColor => isNightMode ? ThemeColors.orange10 : ThemeColors.grey80;

  Color get titleTextColor => isNightMode ? ThemeColors.orange10 : ThemeColors.grey90;

  Color get subTitleTextColor => isNightMode ? ThemeColors.orange10 : ThemeColors.grey70;

  Color get tabBarBackgroundColor => isNightMode ? ThemeColors.dark70 : ThemeColors.grey20;

  Color get lightTabBarBackgroundColor => isNightMode ? ThemeColors.dark60 : ThemeColors.grey20;

  Color get buttonColor => isNightMode ? ThemeColors.dark50 : ThemeColors.grey10;

  Color get saunaHeatingShadow => const Color(0xFFE95B51);

  Color get saunaStandbyShadow => Colors.transparent;

  Color get saunaReadyShadow => const Color(0xFF5AB05A);

  Color get saunaInSessionShadow => const Color(0xFFEFAB46);

  Color get saunaPausedShadow => const Color(0xFF5AAF5A);

  Color get saunaHeatingGlow => const Color(0xFFEF7946);

  Color get brightnessInnerShadowColor =>
      isNightMode ? const Color(0xff070707).withOpacity(.4) : const Color(0xff40434F).withOpacity(.35);

  Color get selectedBorderColor => isNightMode ? ThemeColors.dark30 : ThemeColors.grey50;

  Color get mainPopupBackgroundColor => isNightMode ? const Color(0xff1B1D22).withOpacity(.3) : Colors.transparent;

  Color get mainPopupBaseBackgroundColor =>
      isNightMode ? const Color(0xff1B1D22).withOpacity(.3) : ThemeColors.blurColor.withOpacity(.2);

  Color get buttonBorderColor => isNightMode ? ThemeColors.dark20 : ThemeColors.grey30;

  Color get tickColor => isNightMode ? ThemeColors.orange10 : ThemeColors.grey70;

  Color get axisLineColor => isNightMode ? ThemeColors.dark20 : const Color(0xffC4C4C4).withOpacity(.5);

  Color get activateSwitchBackgroundColor => isNightMode ? const Color(0xff1B1D22) : ThemeColors.orange20;

  Color get deactivateSwitchBackgroundColor => isNightMode ? ThemeColors.dark40 : ThemeColors.grey20;

  Color get activeSwitchBackgroundColor => isNightMode ? ThemeColors.dark70 : Colors.white;

  Color get hintTextColor => isNightMode ? ThemeColors.orange10 : ThemeColors.grey50;

  Color get activeBrightnessColor => isNightMode ? ThemeColors.blue40 : const Color(0xffE0E0E0);

  Color get inactiveBrightnessColor => isNightMode ? ThemeColors.dark50 : const Color(0xffdcdcdc).withOpacity(.12);

  Color get tickMarkColor => isNightMode ? ThemeColors.dark30 : ThemeColors.grey20;

  Color get activeTickMarkColor => isNightMode ? Colors.transparent : ThemeColors.grey20;

  Color get tabBarUnselectedColor => isNightMode ? ThemeColors.dark10 : Colors.black;

  Color get selectedAudioBackgroundColor => isNightMode ? ThemeColors.dark60 : ThemeColors.blue10;

  Color get deselectedAudioBackgroundColor => isNightMode ? ThemeColors.dark60 : ThemeColors.grey10;

  Color get unselectedAudioIcon => isNightMode ? ThemeColors.dark10 : ThemeColors.grey80;

  Color get dark10WithGrey90 => isNightMode ? ThemeColors.dark10 : ThemeColors.grey90;

  Color get volumeBarBackgroundColor => isNightMode ? ThemeColors.dark50 : ThemeColors.grey10;

  Color get wifiSubTitleTextColor => isNightMode ? ThemeColors.dark20 : ThemeColors.grey60;

  Color get wifiHeaderTitleTextColor => isNightMode ? ThemeColors.dark10 : ThemeColors.grey80;

  Color get menuPopupBackgroundColor => isNightMode ? ThemeColors.dark50 : Colors.white;

  Color get splashTitleText => isNightMode ? ThemeColors.orange30 : ThemeColors.orange70;

  Color get splashBackgroundColor => isNightMode ? ThemeColors.dark60 : ThemeColors.orange20;

  Color get borderColor => isNightMode ? ThemeColors.dark50 : ThemeColors.grey20;

  Color get podcastTileBackgroundColor => isNightMode ? ThemeColors.dark50 : Colors.transparent;

  Color get selectedPodcastTileColor => isNightMode ? ThemeColors.dark50 : ThemeColors.blue10;

  Color get selectedPodcastTileBorderColor => isNightMode ? ThemeColors.blue50 : ThemeColors.blue20;

  Color get programModifiedSectionBorderColor => isNightMode ? ThemeColors.dark10 : ThemeColors.orange30;

  Color get programModifiedTextColor => isNightMode ? ThemeColors.dark10 : const Color(0xff757575);

  Color get programModifiedButtonTextColor => isNightMode ? ThemeColors.blue50 : ThemeColors.orange60;

  Color get bluetoothConnectedBackgroundColor => ThemeColors.green.withOpacity(isNightMode ? .5 : .2);

  Color get bluetoothDisconnectedBackgroundColor => ThemeColors.redWarning.withOpacity(isNightMode ? .7 : .2);

  Color get bluetoothConnectedIconColor => isNightMode ? ThemeColors.neutral000 : ThemeColors.green;

  Color get bluetoothDisconnectedIconColor => isNightMode ? ThemeColors.neutral000 : ThemeColors.redWarning;

  Color get dateAndTimeDeselectedColor => isNightMode ? ThemeColors.dark20 : ThemeColors.grey50;

  Color get timePickerBackgroundColor => isNightMode ? ThemeColors.dark50 : ThemeColors.grey20;

  Color get lightSelectedColor => isNightMode ? ThemeColors.dark90 : Colors.white;

  Color get lightTabBackgroundColor => isNightMode ? ThemeColors.dark70 : Colors.white;

  Color get dividerColor => isNightMode ? ThemeColors.dark40 : ThemeColors.grey20;

  Color get bluetoothSubTitleTextColor => isNightMode ? ThemeColors.dark10 : ThemeColors.grey60;

  Color get timezoneBorderColor => isNightMode ? ThemeColors.dark20 : ThemeColors.grey30;

  Color get saunaButtonBackgroundColor => isNightMode ? Colors.transparent : Colors.white;

  Color get noColorBackgroundColor => isNightMode ? ThemeColors.dark10 : ThemeColors.orange10;

  Color get noColorBorderColor => isNightMode ? ThemeColors.dark30 : ThemeColors.orange20;

  Color get scanButtonTextColor => isNightMode ? Colors.white : ThemeColors.blue50;

  Color get pinButtonDisabledColor => isNightMode ? ThemeColors.dark20 : ThemeColors.grey40;

  Color get forgotButtonColor => isNightMode ? Colors.white : ThemeColors.primaryBlueColor;

  List<BoxShadow> get saunaControlPageButtonShadow => isNightMode
      ? [
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
        ]
      : [
          BoxShadow(
            color: ThemeColors.neutral900.withOpacity(0.04),
            blurRadius: 1,
            offset: const Offset(0, 0),
          ),
          BoxShadow(
            color: ThemeColors.neutral900.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xffE6E6E6).withOpacity(.07),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ];

  List<BoxShadow> get innerPageViewShadow => isNightMode
      ? [
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
        ]
      : [
          BoxShadow(
            blurStyle: BlurStyle.inner,
            color: const Color(0xff969696).withOpacity(.08),
            blurRadius: 12,
            offset: const Offset(0, 0),
          ),
          BoxShadow(
            blurStyle: BlurStyle.inner,
            color: const Color(0xffB6B6B6).withOpacity(.12),
            blurRadius: 6,
            offset: const Offset(0, 0),
          ),
        ];

  List<BoxShadow> get saunaControlButtonShadow => isNightMode
      ? [
          BoxShadow(
            color: ThemeColors.neutral900.withOpacity(0.04),
            blurRadius: 1,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: ThemeColors.neutral900.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: ThemeColors.neutral900.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ]
      : [
          BoxShadow(
            color: ThemeColors.neutral900.withOpacity(0.04),
            blurRadius: 1,
            offset: const Offset(0, 0),
          ),
          BoxShadow(
            color: ThemeColors.neutral900.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0XFFE6E6E6).withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ];

  List<BoxShadow> get bottomButtonSelectionBoxShadow => [
        BoxShadow(
          color: const Color(0xff5E5E5E).withOpacity(.1),
          blurRadius: 24,
          spreadRadius: -24,
          offset: const Offset(-1, -1),
        ),
        BoxShadow(
          color: const Color(0xff9A9A9A).withOpacity(0.0),
          blurRadius: 4,
          spreadRadius: -4,
          offset: const Offset(-1, -1),
        ),
        BoxShadow(
          color: const Color(0xff7B7B7B).withOpacity(.12),
          blurRadius: 12,
          spreadRadius: -12,
          offset: const Offset(-1, -1),
        ),
      ];

  List<BoxShadow> get switchButtonShadow => [
        BoxShadow(
          color: const Color(0xff000000).withOpacity(.04),
          blurRadius: 1,
          offset: const Offset(0, 0),
        ),
        BoxShadow(
          color: const Color(0xff000000).withOpacity(.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: const Color(0xffE6E6E6).withOpacity(.07),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];

  List<BoxShadow> get saunaSlashIconShadow => isNightMode
      ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(4, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 4,
            offset: const Offset(0, 8),
          ),
        ]
      : [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 1,
            offset: const Offset(0, 0),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xffE6E6E6).withOpacity(.07),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ];

  String get haloLight => isNightMode ? Assets.haloLightNight.assetName : Assets.haloLightLight.assetName;

  String get overheadLight =>
      isNightMode ? Assets.overheadLightNight.assetName : Assets.svgOverheadLightLight.assetName;

  String get overheadLightOff => isNightMode ? Assets.overheadLightOffDark.assetName : Assets.overheadLight.assetName;

  String get soundOn => isNightMode ? Assets.soundDarkModeOn.assetName : Assets.soundLightModeOn.assetName;

  String get soundOff => isNightMode ? Assets.soundDarkModeOff.assetName : Assets.soundLightModeOff.assetName;

  String get saunaWifi => isNightMode ? Assets.saunaWifiNight.assetName : Assets.saunaWifiLight.assetName;

  String get activatingWifiIcon => isNightMode ? Assets.wifiDark : Assets.wifiLight;

  String get colorMode => isNightMode ? Assets.colorModeNight.assetName : Assets.colorModeLight.assetName;

  String get simpleSleepMode =>
      isNightMode ? Assets.simpleSleepModeNight.assetName : Assets.simpleSleepModeLight.assetName;

  String get wifiNoStrength => isNightMode ? Assets.wifiNoStrengthDark.assetName : Assets.wifiNoStrengthLight.assetName;

  String get wifiStrengthFull =>
      isNightMode ? Assets.wifiStrengthFullDark.assetName : Assets.wifiStrengthFullLight.assetName;

  String get wifiStrengthMedium =>
      isNightMode ? Assets.wifiStrengthMediumDark.assetName : Assets.wifiStrengthMediumLight.assetName;

  String get wifiStrengthLow =>
      isNightMode ? Assets.wifiStrengthLowDark.assetName : Assets.wifiStrengthLowLight.assetName;

  String get bluetoothActive =>
      isNightMode ? Assets.bluetoothActiveDark.assetName : Assets.bluetoothActiveLight.assetName;

  String get saunaLightGIF => isNightMode ? Assets.overheadLightDark : Assets.jsonOverheadLightLight;

  String get advancedSettings =>
      isNightMode ? Assets.advancedSettingsDark.assetName : Assets.advancedSettingsLight.assetName;
}
