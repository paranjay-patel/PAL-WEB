const _appSettings = 'app_settings';
const _customProgram = 'custom_program';

enum SaunaConfigType {
  unknown,
  appSettings,
  customProgram,
}

SaunaConfigType fromConfigTypeString(String? configType) {
  if (configType == null || configType.isEmpty) {
    return SaunaConfigType.unknown;
  } else {
    return SaunaConfigType.values.firstWhere(
      (type) => type.apiKey == configType,
      orElse: () => SaunaConfigType.unknown,
    );
  }
}

extension SaunaConfigTypeExtension on SaunaConfigType {
  String get apiKey {
    switch (this) {
      case SaunaConfigType.appSettings:
        return _appSettings;
      case SaunaConfigType.customProgram:
        return _customProgram;
      case SaunaConfigType.unknown:
        return '';
    }
  }
}
