// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_code_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QRCodeData _$QRCodeDataFromJson(Map<String, dynamic> json) => QRCodeData(
      saunaId: json['sauna_id'] as String,
      deviceToken: json['device_token'] as String,
      ip: json['ip'] as String,
    );

Map<String, dynamic> _$QRCodeDataToJson(QRCodeData instance) =>
    <String, dynamic>{
      'sauna_id': instance.saunaId,
      'device_token': instance.deviceToken,
      'ip': instance.ip,
    };
