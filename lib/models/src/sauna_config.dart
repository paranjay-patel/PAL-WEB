import 'package:found_space_flutter_web_application/models/models.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:equatable/equatable.dart';

part 'sauna_config.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class SaunaConfig extends Equatable {
  final SaunaTheme? themeMode;
  final SaunaSaverSleepModeType? saunaSaverSleepModeType;
  final SaunaSaverSleepDuration? saunaSaverSleepDuration;
  final List<String>? saunaSelectedColor;
  final Program? customProgram;
  final bool? isAllSoundOn;
  final bool? isSystemSoundOn;
  final bool? isSessionsSoundOn;
  final TemperatureScale? temperatureScale;
  final TimeConvention? timeConvention;
  final String? securityPin;
  final SaunaSecuritySettings? securitySettings;

  const SaunaConfig({
    this.themeMode,
    this.saunaSaverSleepModeType,
    this.saunaSaverSleepDuration,
    this.saunaSelectedColor,
    this.customProgram,
    this.isAllSoundOn,
    this.isSystemSoundOn,
    this.isSessionsSoundOn,
    this.temperatureScale,
    this.timeConvention,
    this.securityPin,
    this.securitySettings,
  });

  @override
  List<Object?> get props => [
        themeMode,
        saunaSaverSleepModeType,
        saunaSaverSleepDuration,
        saunaSelectedColor,
        customProgram,
        isAllSoundOn,
        isSystemSoundOn,
        isSessionsSoundOn,
        temperatureScale,
        timeConvention,
        securityPin,
        securitySettings,
      ];

  factory SaunaConfig.fromJson(Map<String, dynamic> json) {
    return _$SaunaConfigFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SaunaConfigToJson(this);
}
