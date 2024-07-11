import 'package:found_space_flutter_web_application/assets.dart';

enum SaunaColorThemeModeType {
  light,
  dark,
}

extension SaunaColorThemeModeTypeExtension on SaunaColorThemeModeType {
  String get title {
    switch (this) {
      case SaunaColorThemeModeType.light:
        return 'Light Theme';
      case SaunaColorThemeModeType.dark:
        return 'Dark Theme';
    }
  }

  String get image {
    switch (this) {
      case SaunaColorThemeModeType.light:
        return Images.lightTheme.assetName;
      case SaunaColorThemeModeType.dark:
        return Images.darkTheme.assetName;
    }
  }

  bool get isNightMode {
    return this == SaunaColorThemeModeType.dark;
  }
}

extension ThemeFromIntegerExntension on int {
  SaunaColorThemeModeType get getSelectedTheme {
    switch (this) {
      case 0:
        return SaunaColorThemeModeType.light;
      case 1:
        return SaunaColorThemeModeType.dark;
    }
    return SaunaColorThemeModeType.light;
  }
}
