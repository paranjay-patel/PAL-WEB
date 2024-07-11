import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/svg_asset_image.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';

enum ToastType {
  warning,
  error,
  announcement,
  message,
}

extension ToastTypeExtension on ToastType {
  Color get backgroundColor {
    switch (this) {
      case ToastType.warning:
        return ThemeColors.warningColor;
      case ToastType.error:
        return ThemeColors.errorColor;
      case ToastType.announcement:
        return ThemeColors.primaryBlueColor;
      case ToastType.message:
        return ThemeColors.green;
    }
  }

  SvgAssetImage get asset {
    switch (this) {
      case ToastType.warning:
        return Assets.warning;
      case ToastType.error:
        return Assets.info;
      case ToastType.announcement:
        return Assets.announcement;
      case ToastType.message:
        return Assets.bluetoothConnected;
    }
  }
}

class SaunaToast extends StatefulWidget {
  final ToastType type;
  final String message;
  final VoidCallback onClose;

  const SaunaToast({
    Key? key,
    required this.type,
    required this.message,
    required this.onClose,
  }) : super(key: key);

  @override
  State<SaunaToast> createState() => _SaunaToastState();
}

class _SaunaToastState extends State<SaunaToast> {
  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.getWidth(min: 12, max: 16),
        vertical: screenSize.getHeight(min: 16, max: 20),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenSize.getWidth(min: 10, max: 16)),
        color: widget.type.backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.type.asset.toSvgPicture(
            width: screenSize.getHeight(min: 26, max: 32),
            height: screenSize.getHeight(min: 26, max: 32),
            color: Colors.white,
          ),
          SizedBox(width: screenSize.getWidth(min: 6, max: 8)),
          Text(
            widget.message,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: screenSize.getFontSize(min: 16, max: 20),
            ),
          ),
          SizedBox(width: screenSize.getWidth(min: 16, max: 20)),
          InkWell(
            onTap: widget.onClose,
            child: Assets.close.toSvgPicture(
              width: screenSize.getHeight(min: 26, max: 32),
              height: screenSize.getHeight(min: 26, max: 32),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

extension FToastExtension on FToast {
  void showSaunaToast({
    required ToastType type,
    required String message,
  }) {
    showToast(
      child: SaunaToast(
        type: type,
        message: message,
        onClose: () {
          removeCustomToast();
        },
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 5),
    );
  }
}
