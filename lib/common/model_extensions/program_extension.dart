import 'package:found_space_flutter_rest_api/models/models.dart';

extension ProgramExtension on Program {
  Program apiValue({String? customName}) {
    return Program(
      targetTimer: targetTimer,
      targetTemperature: targetTemperature,
      lights: lights,
      name: customName ?? name,
    );
  }

  Program copyWith({
    String? id,
    String? name,
    double? targetTemperature,
    int? targetTimer,
    int? timerDuration,
    List<Light>? lights,
    List<Heater>? heaters,
    List<String>? descriptions,
    List<String>? tags,
    List<String>? exclusions,
    Program? active,
    Program? set,
  }) {
    return Program(
      id: id ?? this.id,
      name: name ?? this.name,
      targetTemperature: targetTemperature ?? this.targetTemperature,
      targetTimer: targetTimer ?? this.targetTimer,
      timerDuration: timerDuration ?? this.timerDuration,
      lights: lights ?? this.lights,
      heaters: heaters ?? this.heaters,
      descriptions: descriptions ?? this.descriptions,
      tags: tags ?? this.tags,
      exclusions: exclusions ?? this.exclusions,
      active: active ?? this.active,
      set: set ?? this.set,
    );
  }
}
