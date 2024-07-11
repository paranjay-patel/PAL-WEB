import 'package:flutter/material.dart';

enum DurationFormatUnit { hour, minute, second }

enum ScreenSize { small, medium, large }

class Utils {
  static final Utils instance = Utils();

  static bool isMobileLayout(BuildContext context) {
    // Determine if we should use mobile layout or not. The number 600 here is a common breakpoint for a typical 7-inch tablet.
    // Reference URL: https://iirokrankka.com/2018/01/28/implementing-adaptive-master-detail-layouts/
    return MediaQuery.of(context).size.shortestSide < 600;
  }

  static bool isSmallTabLayout(BuildContext context) {
    // Determine if we should use mobile layout or not. The number 700 here is a common breakpoint for a typical 7-inch tablet.
    // Reference URL: https://iirokrankka.com/2018/01/28/implementing-adaptive-master-detail-layouts/
    return MediaQuery.of(context).size.shortestSide < 700;
  }

  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width <= 1024) {
      return ScreenSize.small;
    } else if (width <= 1280) {
      return ScreenSize.medium;
    } else {
      return ScreenSize.large;
    }
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  String durationFormatForPlayer(double duration) {
    var secondsRemaining = duration;
    var secs = secondsRemaining % 60;
    secondsRemaining /= 60;
    var mins = secondsRemaining % 60;
    secondsRemaining /= 60;
    var hrs = secondsRemaining % 60;
    var result = hrs.toInt() != 0
        ? mins.toInt().toString().padLeft(2, '0') + ':' + secs.round().toString().padLeft(2, '0')
        : mins.toInt().toString() + ':' + secs.round().toString().padLeft(2, '0');
    if (hrs.toInt() != 0) {
      return hrs.toInt().toString() + ':' + result;
    }
    return result;
  }

  static int convertToFahrenheit(int temperature) {
    return ((temperature * 9 / 5) + 32).toInt();
  }

  static int convertToCelsius(int temperature) {
    return (temperature - 32) * 5 ~/ 9;
  }
}

extension ScreenSizeExtension on ScreenSize {
  double getWidth({required double min, required double max}) {
    switch (this) {
      case ScreenSize.small:
        return min;
      case ScreenSize.large:
        return max;
      case ScreenSize.medium:
        return min + (min * .2);
    }
  }

  double getHeight({required double min, required double max}) {
    switch (this) {
      case ScreenSize.small:
        return min;
      case ScreenSize.large:
        return max;
      case ScreenSize.medium:
        return min + (min * .2);
    }
  }

  double getIconSize({required double min, required double max}) {
    switch (this) {
      case ScreenSize.small:
        return min;
      case ScreenSize.large:
        return max;
      case ScreenSize.medium:
        return min + (min * .2);
    }
  }

  double getFontSize({required double min, required double max}) {
    switch (this) {
      case ScreenSize.small:
        return min;
      case ScreenSize.large:
        return max;
      case ScreenSize.medium:
        return min + (min * .2);
    }
  }

  double getAllPadding({required double min, required double max}) {
    switch (this) {
      case ScreenSize.small:
        return min;
      case ScreenSize.large:
        return max;
      case ScreenSize.medium:
        return min + (min * .2);
    }
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
