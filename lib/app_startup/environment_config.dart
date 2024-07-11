import 'package:flutter/foundation.dart';
import 'package:found_space_flutter_web_application/app_startup/app_flavor.dart';

class EnvironmentConfig {
  static const String Flavor = String.fromEnvironment("flavor");
  static AppFlavor get flavor {
    if (Flavor.trim().isEmpty) {
      return AppFlavor.white;
    }
    return AppFlavor.values.firstWhere(
      (element) => Flavor.trim().toLowerCase() == describeEnum(element).toLowerCase(),
      orElse: () => AppFlavor.white,
    );
  }
}
