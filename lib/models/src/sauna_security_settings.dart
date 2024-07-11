import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'sauna_security_settings.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, includeIfNull: false)
class SaunaSecuritySettings extends Equatable {
  final bool? isSettingsOn;
  final bool? isSaunaPairingOn;
  final bool? isWifiButtonEnabled;
  final bool? isBluetoothButtonEnabled;

  const SaunaSecuritySettings({
    this.isSettingsOn,
    this.isSaunaPairingOn,
    this.isWifiButtonEnabled,
    this.isBluetoothButtonEnabled,
  });

  @override
  List<Object?> get props => [
        isSettingsOn,
        isSaunaPairingOn,
        isWifiButtonEnabled,
        isBluetoothButtonEnabled,
      ];

  factory SaunaSecuritySettings.fromJson(Map<String, dynamic> json) {
    return _$SaunaSecuritySettingsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SaunaSecuritySettingsToJson(this);
}
