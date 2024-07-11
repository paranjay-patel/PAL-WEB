import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScreenUtil {
  static final ScreenUtil instance = ScreenUtil();
  static const figmaWidth = 1329.0;
  static const figmaHeight = 830.0;

  static ScreenUtil getInstance() {
    return instance;
  }

  double getAspectHeight(double percentage, BuildContext context) {
    return MediaQuery.of(context).size.width / percentage;
  }

  /// It will use to get the height of widget.
  /// height of widget will be different base on device size.
  static double getHeight(BuildContext context, double height, {double? widthInDesign}) {
    final screenWidth = MediaQuery.of(context).size.height;
    return screenWidth * height / (widthInDesign ?? figmaHeight);
  }

  /// It will use to get the width of widget.
  /// width of widget will be different base on device size.
  static double getWidth(BuildContext context, double width, {double? widthInDesign}) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * width / (widthInDesign ?? figmaWidth);
  }
}
