import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:found_space_flutter_web_application/models/models.dart';

extension SaunaConfigExtension on SaunaConfig {
  SaunaConfig copyWith({
    SaunaTheme? themeMode,
    SaunaSaverSleepDuration? saunaSaverSleepDuration,
    SaunaSaverSleepModeType? saunaSaverSleepModeType,
    List<String>? selectedColor,
    bool? isAllSoundOn,
    bool? isSystemSoundOn,
    bool? isSessionsSoundOn,
    TemperatureScale? temperatureScale,
    TimeConvention? timeConvention,
    String? securityPin,
    SaunaSecuritySettings? securitySettings,
  }) {
    return SaunaConfig(
      themeMode: themeMode ?? this.themeMode,
      saunaSaverSleepDuration: saunaSaverSleepDuration ?? this.saunaSaverSleepDuration,
      saunaSaverSleepModeType: saunaSaverSleepModeType ?? this.saunaSaverSleepModeType,
      saunaSelectedColor: selectedColor ?? saunaSelectedColor,
      isSystemSoundOn: isSystemSoundOn ?? this.isSystemSoundOn,
      temperatureScale: temperatureScale ?? this.temperatureScale,
      timeConvention: timeConvention ?? this.timeConvention,
      isAllSoundOn: isAllSoundOn ?? this.isAllSoundOn,
      isSessionsSoundOn: isSessionsSoundOn ?? this.isSessionsSoundOn,
      securityPin: securityPin ?? this.securityPin,
      securitySettings: securitySettings ?? this.securitySettings,
    );
  }

  bool get isNightMode => themeMode == SaunaTheme.dark;

  SaunaSaverSleepModeType get saverSleepModeType => saunaSaverSleepModeType ?? SaunaSaverSleepModeType.saverMode;

  SaunaSaverSleepDuration get saverSleepDuration => saunaSaverSleepDuration ?? SaunaSaverSleepDuration.oneMin;

  List<String> get color => saunaSelectedColor ?? [];
}

extension SaunaSecurityExtension on SaunaSecuritySettings {
  SaunaSecuritySettings copyWith({
    final bool? isSettingsOn,
    final bool? isSaunaPairingOn,
    bool? isBluetoothButtonEnabled,
    bool? isWifiButtonEnabled,
  }) {
    return SaunaSecuritySettings(
      isSettingsOn: isSettingsOn ?? this.isSettingsOn,
      isSaunaPairingOn: isSaunaPairingOn ?? this.isSaunaPairingOn,
      isBluetoothButtonEnabled: isBluetoothButtonEnabled ?? this.isBluetoothButtonEnabled,
      isWifiButtonEnabled: isWifiButtonEnabled ?? this.isWifiButtonEnabled,
    );
  }
}
