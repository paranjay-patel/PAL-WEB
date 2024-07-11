import 'package:json_annotation/json_annotation.dart';

part 'qr_code_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class QRCodeData {
  final String saunaId;
  final String deviceToken;
  final String ip;

  const QRCodeData({
    required this.saunaId,
    required this.deviceToken,
    required this.ip,
  });

  factory QRCodeData.fromJson(Map<String, dynamic> json) => _$QRCodeDataFromJson(json);

  Map<String, dynamic> toJson() => _$QRCodeDataToJson(this);
}
