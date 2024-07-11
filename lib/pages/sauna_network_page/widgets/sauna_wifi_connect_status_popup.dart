import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_rest_api/models/src/wifi.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/wifi_state_extension.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/store/sauna_wifi.store.dart';
import 'package:lottie/lottie.dart';
import 'package:mobx/mobx.dart';

class SaunaWifiConnectStatusPopup extends StatefulWidget {
  final SaunaWifiStore store;

  const SaunaWifiConnectStatusPopup({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  SaunaWifiConnectStatusPopupState createState() => SaunaWifiConnectStatusPopupState();
}

class SaunaWifiConnectStatusPopupState extends State<SaunaWifiConnectStatusPopup> {
  final _reaction = CompositeReactionDisposer();

  @override
  void initState() {
    super.initState();

    reaction<WifiState>((_) => widget.store.wifiState, (wifiState) {
      switch (wifiState) {
        case WifiState.active:
        case WifiState.deactivated:
        case WifiState.inactive:
        case WifiState.neverActivated:
          Future.delayed(const Duration(seconds: 6), () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
          break;
        case WifiState.unknown:
        case WifiState.activating:
          break;
      }
    }).disposeWith(_reaction);
  }

  @override
  void dispose() {
    _reaction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: screenSize.getWidth(min: 48, max: 78)),
      alignment: Alignment.center,
      child: Observer(builder: (context) {
        final lottieAssets = widget.store.wifiState.lottieAssets(context);

        final isDeactivated = widget.store.wifiState == WifiState.deactivated ||
            widget.store.wifiState == WifiState.inactive ||
            widget.store.wifiState == WifiState.neverActivated ||
            widget.store.wifiState == WifiState.unknown;

        if (isDeactivated) {
          return Lottie.asset(
            lottieAssets,
            animate: true,
            repeat: true,
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.qrCodeOne.toSvgPicture(
              width: screenSize.getHeight(min: 80, max: 100),
              height: screenSize.getHeight(min: 80, max: 100),
              color: Theme.of(context).colorScheme.wifiIconColor,
            ),
            SizedBox(width: screenSize.getHeight(min: 10, max: 16)),
            Container(
              width: screenSize.getHeight(min: 80, max: 100),
              height: screenSize.getHeight(min: 80, max: 100),
              alignment: Alignment.center,
              child: Lottie.asset(
                lottieAssets,
                animate: true,
                repeat: true,
                width: widget.store.wifiState.lottieImageSize(context),
                height: widget.store.wifiState.lottieImageSize(context),
              ),
            ),
            SizedBox(width: screenSize.getHeight(min: 10, max: 16)),
            Assets.wifiConnection.toSvgPicture(
              width: screenSize.getHeight(min: 80, max: 100),
              height: screenSize.getHeight(min: 80, max: 100),
              color: Theme.of(context).colorScheme.wifiIconColor,
            ),
          ],
        );
      }),
    );
  }
}
