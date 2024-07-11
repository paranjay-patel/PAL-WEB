import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';

class UISettings {
  final BuildContext context;
  late double _spacing;
  double? _cardItemHeight;
  double? _cardItemWidth;

  final EdgeInsets _horizontalCompactInsets = const EdgeInsets.fromLTRB(23, 0, 23, 40);
  final EdgeInsets _horizontalRegularInsets = const EdgeInsets.fromLTRB(40, 0, 40, 25);

  final double _maxPortraitWidth = 750.0;
  final double _maxLandscapeWidth = 900.0;
  final double _smallDeviceWidth = 360.0;

  UISettings._(
    this.context,
  ) {
    _spacing = Utils.isMobileLayout(context) ? 0 : 20;
    _cardItemWidth =
        Utils.isMobileLayout(context) ? screenWidth * 0.888 : (screenWidth - homePagePadding.horizontal - _spacing) / 2;
    _cardItemHeight = _cardItemWidth;
  }

  factory UISettings.of(BuildContext context) {
    return UISettings._(context);
  }

  EdgeInsets get contentPadding {
    final isMobileLayout = Utils.isMobileLayout(context);
    final totalWidth = MediaQuery.of(context).size.width;
    final limitedWidth = isPortraitsMode ? _maxPortraitWidth : _maxLandscapeWidth;

    var padding = isMobileLayout ? _horizontalCompactInsets : _horizontalRegularInsets;

    if (totalWidth > limitedWidth) {
      final addition = (totalWidth - limitedWidth) / 2.0;
      padding = padding.copyWith(
        left: padding.left + addition,
        right: padding.right + addition,
      );
    }

    return padding;
  }

  double get splashScreenIconWidth {
    final isMobileLayout = Utils.isMobileLayout(context);
    final totalWidth = MediaQuery.of(context).size.width;
    final limitedWidth = isPortraitsMode ? _maxPortraitWidth : _maxLandscapeWidth;
    return isMobileLayout ? totalWidth - 100 : limitedWidth - 250;
  }

  EdgeInsets get contentPaddingForPortrait {
    final isMobileLayout = Utils.isMobileLayout(context);
    final totalWidth = MediaQuery.of(context).size.width;
    final limitedWidth = _maxPortraitWidth;

    var padding = isMobileLayout ? _horizontalCompactInsets : _horizontalRegularInsets;

    if (totalWidth > limitedWidth) {
      final addition = (totalWidth - limitedWidth) / 2.0;
      padding = padding.copyWith(
        left: padding.left + addition,
        right: padding.right + addition,
      );
    }

    return padding;
  }

  EdgeInsets get homePagePadding {
    return contentPadding.copyWith(
      top: 0,
      bottom: 0,
    );
  }

  EdgeInsets get homePagePaddingPortrait {
    return contentPaddingForPortrait.copyWith(
      top: 0,
      bottom: 0,
    );
  }

  EdgeInsets get popupMarginPortrait {
    final isMobileLayout = Utils.isMobileLayout(context);

    if (isMobileLayout) {
      return EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10);
    }

    return contentPaddingForPortrait.copyWith(
      top: Utils.isMobileLayout(context) ? 0 : 40,
      bottom: Utils.isMobileLayout(context) ? 0 : 40,
    );
  }

  EdgeInsets marginWithMaxWidth({required double maxWidth, double? minMargin}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final margin = (screenWidth - maxWidth) / 2.0;
    final defaultMargin = contentPadding;

    return EdgeInsets.only(
      left: max(minMargin ?? defaultMargin.left, margin),
      right: max(minMargin ?? defaultMargin.right, margin),
    );
  }

  bool get isPortraitsMode {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  bool get isSmallDevice {
    return (screenWidth <= _smallDeviceWidth);
  }

  double get screenWidth => MediaQuery.of(context).size.width;

  double get shortestSide => MediaQuery.of(context).size.shortestSide;

  double? get cardItemHeight => _cardItemHeight;

  double? get cardItemWidth => _cardItemWidth;

  double get indicatorHeight => 1;

  bool get isSmallerDevice {
    final width = MediaQuery.of(context).size.width;
    return width < _smallDeviceWidth;
  }
}
