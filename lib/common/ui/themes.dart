import 'package:flutter/material.dart';
import 'package:found_space_flutter_web_application/src/chameleon_theme/adaptive_chameleon_theme.dart';

import 'theme_font.dart';

class AppThemes {
  static ThemeCollection themeCollection = ThemeCollection(
    themes: {
      1: ThemeData(
        fontFamily: ThemeFont.defaultFontFamily,
        brightness: Brightness.light,
      ),
    },
    fallbackTheme: ThemeData.light(),
  );
  static ThemeCollection darkThemeCollection = ThemeCollection(
    themes: {
      1: ThemeData(
        fontFamily: ThemeFont.defaultFontFamily,
        brightness: Brightness.dark,
      ),
    },
    fallbackTheme: ThemeData.dark(),
  );
}
