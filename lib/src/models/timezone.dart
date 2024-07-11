import 'package:json_annotation/json_annotation.dart';

part 'timezone.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TimeZone {
  final String? value;
  final String? abbr;
  final double? offset;
  final bool? isdst;
  final String? text;
  final List<String?>? utc;

  const TimeZone({
    this.value,
    this.abbr,
    this.offset,
    this.isdst,
    this.text,
    this.utc,
  });

  factory TimeZone.fromJson(Map<String, dynamic> json) => _$TimeZoneFromJson(json);

  Map<String, dynamic> toJson() => _$TimeZoneToJson(this);
}
