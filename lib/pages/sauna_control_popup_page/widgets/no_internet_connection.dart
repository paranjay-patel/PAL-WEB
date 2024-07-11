import 'package:flutter/material.dart';
import 'package:found_space_flutter_web_application/common/screen_utils.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';

enum NoInternetConnectionPageType { qrCode, common }

class NoInternetConnection extends StatelessWidget {
  final void Function()? onTap;
  final NoInternetConnectionPageType noInternetConnectionPageType;

  const NoInternetConnection({
    Key? key,
    this.noInternetConnectionPageType = NoInternetConnectionPageType.common,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        switch (noInternetConnectionPageType) {
          case NoInternetConnectionPageType.common:
            return _buildCommonContent(context);
          case NoInternetConnectionPageType.qrCode:
            return _buildQrCodeContent(context);
        }
      },
    );
  }

  Widget _buildCommonContent(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final screenSize = Utils.getScreenSize(context);
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.noNetwork.toSvgPicture(
            width: 80,
            height: 80,
            color: theme.titleTextColor,
          ),
          SizedBox(height: screenSize.getHeight(min: 8, max: 12)),
          const NoInternetConnectionTitle(title: "The connection is lost"),
          SizedBox(height: screenSize.getHeight(min: 8, max: 14)),
          const NoInternetConnectionSubtitle(title: 'Check your internet connection or try again.'),
          SizedBox(height: screenSize.getHeight(min: 30, max: 44)),
          NoInternetConnectionRetryButton(
            title: 'Try again',
            onTap: () {
              onTap?.call();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQrCodeContent(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.noNetwork.toSvgPicture(
                width: screenSize.getHeight(min: 80, max: 100),
                height: screenSize.getHeight(min: 80, max: 100),
                color: ThemeColors.grey70,
              ),
              SizedBox(width: screenSize.getHeight(min: 10, max: 16)),
              Assets.qrCodeTwo.toSvgPicture(
                width: screenSize.getHeight(min: 80, max: 100),
                height: screenSize.getHeight(min: 80, max: 100),
                color: ThemeColors.grey70,
              ),
              Assets.qrCodeThree.toSvgPicture(
                width: screenSize.getHeight(min: 80, max: 100),
                height: screenSize.getHeight(min: 80, max: 100),
                color: ThemeColors.grey70,
              ),
            ],
          ),
          SizedBox(height: ScreenUtil.getHeight(context, 10)),
          const NoInternetConnectionTitle(
            title: 'The sauna is not connected to network',
            isLightMode: true,
          ),
          SizedBox(height: screenSize.getHeight(min: 8, max: 14)),
          const NoInternetConnectionSubtitle(
            title: 'Please connect it and try again',
            isLightMode: true,
          ),
          SizedBox(height: screenSize.getHeight(min: 30, max: 44)),
          NoInternetConnectionRetryButton(
            title: "Connect sauna to network",
            onTap: () {
              onTap?.call();
            },
          ),
          SizedBox(height: ScreenUtil.getHeight(context, 80)),
        ],
      ),
    );
  }
}

class NoInternetConnectionTitle extends StatelessWidget {
  final String title;
  final bool isLightMode;
  const NoInternetConnectionTitle({
    Key? key,
    required this.title,
    this.isLightMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final screenSize = Utils.getScreenSize(context);
    return Text(
      title,
      style: TextStyle(
        color: isLightMode ? ThemeColors.grey90 : theme.titleTextColor,
        fontSize: screenSize.getFontSize(min: 18, max: 24),
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.right,
    );
  }
}

class NoInternetConnectionSubtitle extends StatelessWidget {
  final String title;
  final bool isLightMode;
  const NoInternetConnectionSubtitle({
    Key? key,
    required this.title,
    this.isLightMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final screenSize = Utils.getScreenSize(context);
    return Text(
      title,
      style: TextStyle(
        fontSize: screenSize.getFontSize(min: 14, max: 20),
        fontWeight: FontWeight.normal,
        color: isLightMode ? ThemeColors.grey90 : theme.dark10WithGrey90,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class NoInternetConnectionRetryButton extends StatelessWidget {
  final void Function()? onTap;
  final String title;

  const NoInternetConnectionRetryButton({Key? key, required this.onTap, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    return FeedbackSoundWrapper(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        height: screenSize.getHeight(min: 46, max: 56),
        width: screenSize.getWidth(min: 200, max: 414),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenSize.getHeight(min: 14, max: 20)),
          color: ThemeColors.blue50,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: screenSize.getFontSize(min: 14, max: 20),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
