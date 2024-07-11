// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sauna_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaunaConfig _$SaunaConfigFromJson(Map<String, dynamic> json) => SaunaConfig(
      themeMode: $enumDecodeNullable(_$SaunaThemeEnumMap, json['theme_mode']),
      saunaSaverSleepModeType: $enumDecodeNullable(
          _$SaunaSaverSleepModeTypeEnumMap,
          json['sauna_saver_sleep_mode_type']),
      saunaSaverSleepDuration: $enumDecodeNullable(
          _$SaunaSaverSleepDurationEnumMap, json['sauna_saver_sleep_duration']),
      saunaSelectedColor: (json['sauna_selected_color'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      customProgram: json['custom_program'] == null
          ? null
          : Program.fromJson(json['custom_program'] as Map<String, dynamic>),
      isAllSoundOn: json['is_all_sound_on'] as bool?,
      isSystemSoundOn: json['is_system_sound_on'] as bool?,
      isSessionsSoundOn: json['is_sessions_sound_on'] as bool?,
      temperatureScale: $enumDecodeNullable(
          _$TemperatureScaleEnumMap, json['temperature_scale']),
      timeConvention:
          $enumDecodeNullable(_$TimeConventionEnumMap, json['time_convention']),
      securityPin: json['security_pin'] as String?,
      securitySettings: json['security_settings'] == null
          ? null
          : SaunaSecuritySettings.fromJson(
              json['security_settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SaunaConfigToJson(SaunaConfig instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('theme_mode', _$SaunaThemeEnumMap[instance.themeMode]);
  writeNotNull('sauna_saver_sleep_mode_type',
      _$SaunaSaverSleepModeTypeEnumMap[instance.saunaSaverSleepModeType]);
  writeNotNull('sauna_saver_sleep_duration',
      _$SaunaSaverSleepDurationEnumMap[instance.saunaSaverSleepDuration]);
  writeNotNull('sauna_selected_color', instance.saunaSelectedColor);
  writeNotNull('custom_program', instance.customProgram?.toJson());
  writeNotNull('is_all_sound_on', instance.isAllSoundOn);
  writeNotNull('is_system_sound_on', instance.isSystemSoundOn);
  writeNotNull('is_sessions_sound_on', instance.isSessionsSoundOn);
  writeNotNull('temperature_scale',
      _$TemperatureScaleEnumMap[instance.temperatureScale]);
  writeNotNull(
      'time_convention', _$TimeConventionEnumMap[instance.timeConvention]);
  writeNotNull('security_pin', instance.securityPin);
  writeNotNull('security_settings', instance.securitySettings?.toJson());
  return val;
}

const _$SaunaThemeEnumMap = {
  SaunaTheme.unknown: 'unknown',
  SaunaTheme.light: 'light',
  SaunaTheme.dark: 'dark',
};

const _$SaunaSaverSleepModeTypeEnumMap = {
  SaunaSaverSleepModeType.unknown: 'unknown',
  SaunaSaverSleepModeType.saverMode: 'saver_mode',
  SaunaSaverSleepModeType.sleepMode: 'sleep_mode',
  SaunaSaverSleepModeType.keepScreenOn: 'keep_screen_on',
};

const _$SaunaSaverSleepDurationEnumMap = {
  SaunaSaverSleepDuration.unknown: 'unknown',
  SaunaSaverSleepDuration.oneMin: 'one_min',
  SaunaSaverSleepDuration.threeMin: 'three_min',
  SaunaSaverSleepDuration.fiveMin: 'five_min',
  SaunaSaverSleepDuration.fifteenMin: 'fifteen_min',
  SaunaSaverSleepDuration.thirtyMin: 'thirty_min',
};

const _$TemperatureScaleEnumMap = {
  TemperatureScale.unknown: 'unknown',
  TemperatureScale.celsius: 'Celsius',
  TemperatureScale.fahrenheit: 'Fahrenheit',
};

const _$TimeConventionEnumMap = {
  TimeConvention.unknown: 'unknown',
  TimeConvention.twelve: '12',
  TimeConvention.twentyFour: '24',
};
