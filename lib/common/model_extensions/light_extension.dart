import 'package:found_space_flutter_rest_api/models/models.dart';

extension SaunaLightExtension on Light {
  Light copyWith({required bool status, ColorRGB? colorRGB, double? brightness}) {
    return Light(
      id: '',
      name: name,
      type: type,
      state: status,
      color: colorRGB ?? color,
      brightness: brightness ?? this.brightness,
    );
  }

  Light lightToMatch() {
    return Light(id: id, name: name, type: type, color: color, brightness: brightness);
  }

  Light monoCopyWith({required bool status}) {
    return Light(id: '', state: status, type: type, brightness: brightness);
  }
}
