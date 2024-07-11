import 'package:flutter/material.dart';
import 'package:found_space_flutter_rest_api/models/models.dart';

extension ColorExtension on Color {
  ColorRGB get toColorRGB {
    return ColorRGB(r: red, g: green, b: blue);
  }
}
