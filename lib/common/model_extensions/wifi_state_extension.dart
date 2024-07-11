import 'package:flutter/material.dart';
import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';

extension WifiStateExtension on WifiState {
  String get wifiStateTitle {
    switch (this) {
      case WifiState.active:
        return 'Wifi: connected';
      case WifiState.activating:
        return 'Wifi: activating';
      case WifiState.deactivated:
      case WifiState.inactive:
      case WifiState.neverActivated:
      case WifiState.unknown:
        return 'Wifi: disconnected';
    }
  }

  String wifiIcon(BuildContext context, {required int signal}) {
    switch (this) {
      case WifiState.active:
        if (signal >= 75) {
          return Theme.of(context).colorScheme.wifiStrengthFull;
        } else if (signal >= 50) {
          return Theme.of(context).colorScheme.wifiStrengthMedium;
        } else if (signal >= 25) {
          return Theme.of(context).colorScheme.wifiStrengthLow;
        } else {
          return Theme.of(context).colorScheme.wifiNoStrength;
        }
      case WifiState.activating:
        return Theme.of(context).colorScheme.activatingWifiIcon;
      case WifiState.deactivated:
      case WifiState.inactive:
      case WifiState.neverActivated:
      case WifiState.unknown:
        return Assets.wifiOff.assetName;
    }
  }

  bool get isWifiConnected {
    return this == WifiState.active;
  }

  String get wifiConnectionStatusText {
    switch (this) {
      case WifiState.active:
        return 'Connected';
      case WifiState.activating:
        return 'WiFi is connecting';
      case WifiState.deactivated:
      case WifiState.inactive:
      case WifiState.neverActivated:
      case WifiState.unknown:
        return 'Connection failed';
    }
  }

  String lottieAssets(BuildContext context) {
    switch (this) {
      case WifiState.active:
        return Assets.connectionSuccess;
      case WifiState.activating:
        return Theme.of(context).colorScheme.connectingWifi;
      case WifiState.deactivated:
      case WifiState.inactive:
      case WifiState.neverActivated:
      case WifiState.unknown:
        return Theme.of(context).colorScheme.connectingWifiFailed;
    }
  }

  double lottieImageSize(BuildContext context) {
    switch (this) {
      case WifiState.active:
        return Utils.getScreenSize(context).getHeight(min: 40, max: 60);
      case WifiState.activating:
        return Utils.getScreenSize(context).getHeight(min: 80, max: 100);
      case WifiState.deactivated:
      case WifiState.inactive:
      case WifiState.neverActivated:
      case WifiState.unknown:
        return Utils.getScreenSize(context).getHeight(min: 40, max: 60);
    }
  }
}
