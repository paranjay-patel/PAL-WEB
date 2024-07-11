import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';

class ThemedActivityIndicator extends StatelessWidget {
  const ThemedActivityIndicator({
    Key? key,
    this.radius = 10,
    this.isLightColorIndicator,
    this.animating = true,
  }) : super(key: key);
  final double radius;
  final bool? isLightColorIndicator;
  final bool animating;

  @override
  Widget build(BuildContext context) => const CupertinoActivityIndicator().getThemedIndicator(
        context,
        radius: radius,
        isDarkMode: isLightColorIndicator,
        animating: animating,
      );
}

extension CupertinoActivityIndicatorSupport on CupertinoActivityIndicator {
  Widget getThemedIndicator(
    BuildContext context, {
    double radius = 10,
    bool? isDarkMode,
    bool animating = true,
  }) {
    var isNightTheme = isDarkMode ?? Theme.of(context).colorScheme.isNightMode;
    final child = progress != 1.0
        ? CupertinoActivityIndicator.partiallyRevealed(
            radius: radius,
            progress: progress,
          )
        : CupertinoActivityIndicator(
            radius: radius,
            animating: animating,
          );
    return CupertinoTheme(
        data: CupertinoTheme.of(context).copyWith(brightness: isNightTheme ? Brightness.dark : Brightness.light),
        child: child);
  }
}
