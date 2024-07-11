// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timezone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeZone _$TimeZoneFromJson(Map<String, dynamic> json) => TimeZone(
      value: json['value'] as String?,
      abbr: json['abbr'] as String?,
      offset: (json['offset'] as num?)?.toDouble(),
      isdst: json['isdst'] as bool?,
      text: json['text'] as String?,
      utc: (json['utc'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    );

Map<String, dynamic> _$TimeZoneToJson(TimeZone instance) => <String, dynamic>{
      'value': instance.value,
      'abbr': instance.abbr,
      'offset': instance.offset,
      'isdst': instance.isdst,
      'text': instance.text,
      'utc': instance.utc,
    };
