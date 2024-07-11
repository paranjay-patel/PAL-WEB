// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sauna_security_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaunaSecuritySettings _$SaunaSecuritySettingsFromJson(
        Map<String, dynamic> json) =>
    SaunaSecuritySettings(
      isSettingsOn: json['is_settings_on'] as bool?,
      isSaunaPairingOn: json['is_sauna_pairing_on'] as bool?,
      isWifiButtonEnabled: json['is_wifi_button_enabled'] as bool?,
      isBluetoothButtonEnabled: json['is_bluetooth_button_enabled'] as bool?,
    );

Map<String, dynamic> _$SaunaSecuritySettingsToJson(
    SaunaSecuritySettings instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('is_settings_on', instance.isSettingsOn);
  writeNotNull('is_sauna_pairing_on', instance.isSaunaPairingOn);
  writeNotNull('is_wifi_button_enabled', instance.isWifiButtonEnabled);
  writeNotNull(
      'is_bluetooth_button_enabled', instance.isBluetoothButtonEnabled);
  return val;
}
