import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:found_space_flutter_web_application/common/found_space_router.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/sauna_system_extension.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_bluetooth_store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/common/store/screen_saver.store.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';

import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_menu_button.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_qr_code_button.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_page_common.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SaunaControlPageTopBar extends StatelessWidget {
  final SaunaStore saunaStore;
  final SaunaLocalStorageStore saunaLocalStorageStore;
  final SaunaBluetoothStore saunaBluetoothStore;

  const SaunaControlPageTopBar({
    Key? key,
    required this.saunaStore,
    required this.saunaLocalStorageStore,
    required this.saunaBluetoothStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        screenSize.getHeight(min: 20, max: 24),
        screenSize.getHeight(min: 20, max: 24),
        screenSize.getHeight(min: 20, max: 24),
        0,
      ),
      child: SizedBox(
        height: screenSize.getHeight(min: 60, max: 72),
        width: double.infinity,
        child: Row(
          children: [
            const Spacer(),
            _SaunaControlRightActions(
              saunaStore: saunaStore,
              saunaLocalStorageStore: saunaLocalStorageStore,
              saunaBluetoothStore: saunaBluetoothStore,
            ),
          ],
        ),
      ),
    );
  }
}

class _SaunaControlRightActions extends StatelessWidget {
  final SaunaStore saunaStore;
  final SaunaLocalStorageStore saunaLocalStorageStore;
  final SaunaBluetoothStore saunaBluetoothStore;

  const _SaunaControlRightActions({
    Key? key,
    required this.saunaStore,
    required this.saunaLocalStorageStore,
    required this.saunaBluetoothStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final children = RightActionButtons.values.map((button) {
      return _buildRightActionButton(context, button);
    }).toList();

    return Row(
      children: [
        ...children,
        const SaunaControlQRCodeButton(),
        SizedBox(
          width: screenSize.getHeight(min: 60, max: 72) + 12,
        ),
      ],
    );
  }

  Widget _buildRightActionButton(BuildContext context, RightActionButtons rightActionButton) {
    final theme = Theme.of(context).colorScheme;
    final screenSize = Utils.getScreenSize(context);

    return Observer(
      builder: (_) {
        final bluetoothState = saunaBluetoothStore.bluetoothState;

        final wifiActive = rightActionButton == RightActionButtons.network &&
            saunaStore.networkMode == NetworkMode.wifi &&
            saunaStore.wifiState == WifiState.active;
        final bluetoothActive = rightActionButton == RightActionButtons.bluetooth &&
            saunaBluetoothStore.bluetoothState == BluetoothState.connected;

        final size = screenSize.getHeight(min: 35, max: 50);
        var isConnected = false;
        var isEnabled = true;

        final signal = saunaStore.signal;

        switch (rightActionButton) {
          case RightActionButtons.network:
            isEnabled = (saunaLocalStorageStore.isWifiButtonEnabled &&
                    rightActionButton == RightActionButtons.network &&
                    saunaStore.selectedSaunaMenuType != SaunaMenuType.settings) ||
                saunaStore.selectedSaunaMenuType == SaunaMenuType.settings;
            break;
          case RightActionButtons.cloud:
            isEnabled = false;
            isConnected = saunaStore.isCloudConnected;
            break;
          case RightActionButtons.bluetooth:
            isEnabled = (saunaLocalStorageStore.isBluetoothButtonEnabled &&
                    rightActionButton == RightActionButtons.bluetooth &&
                    saunaStore.selectedSaunaMenuType != SaunaMenuType.settings) ||
                saunaStore.selectedSaunaMenuType == SaunaMenuType.settings;
            break;
        }
        return Padding(
          padding: const EdgeInsets.only(left: 12),
          child: FeedbackSoundWrapper(
            shouldPlay: isEnabled,
            onTap: () async {
              if (!isEnabled) return;

              switch (rightActionButton) {
                case RightActionButtons.network:
                  locator<SaunaStore>().setPopupType(type: PopupType.network);
                  context.read<ScreenSaverStore>().cancelScreenSaverTimer();

                  await Navigator.pushNamed(
                    context,
                    RouteGenerator.saunaNetworkPage,
                  );

                  locator<SaunaStore>().setPopupType(type: PopupType.none);
                  context.read<ScreenSaverStore>().setupScreenSaverTimer();
                  break;
                case RightActionButtons.cloud:
                  break;
                case RightActionButtons.bluetooth:
                  locator<SaunaStore>().setPopupType(type: PopupType.bluetooth);
                  context.read<ScreenSaverStore>().cancelScreenSaverTimer();

                  await Navigator.pushNamed(
                    context,
                    RouteGenerator.saunaBluetoothSettingsPage,
                  );

                  locator<SaunaStore>().setPopupType(type: PopupType.none);
                  context.read<ScreenSaverStore>().setupScreenSaverTimer();
                  break;
              }
            },
            child: Container(
              height: screenSize.getHeight(min: 60, max: 72),
              width: screenSize.getHeight(min: 60, max: 72),
              decoration: isEnabled
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(screenSize.getHeight(min: 14, max: 20)),
                      color: theme.buttonBackgroundColor,
                      boxShadow: theme.saunaControlPageButtonShadow,
                    )
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: size,
                width: size,
                curve: Curves.easeIn,
                alignment: Alignment.center,
                child: rightActionButton == RightActionButtons.network && saunaStore.wifiState == WifiState.activating
                    ? Lottie.asset(
                        Theme.of(context).colorScheme.activatingWifiIcon,
                        animate: true,
                        repeat: true,
                        width: screenSize.getHeight(min: 24, max: 32),
                        height: screenSize.getHeight(min: 24, max: 32),
                      )
                    : Container(
                        width: screenSize.getHeight(min: 24, max: 32),
                        height: screenSize.getHeight(min: 24, max: 32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: SvgPicture.asset(
                          rightActionButton.icon(
                            context,
                            isInternetConnected: isConnected,
                            wifiState: saunaStore.wifiState,
                            signal: signal,
                            bluetoothState: bluetoothState,
                            ethernetStatus: saunaStore.ethernetStatus,
                            networkMode: saunaStore.networkMode,
                          ),
                          width: screenSize.getHeight(min: 24, max: 32),
                          height: screenSize.getHeight(min: 24, max: 32),
                          color: wifiActive || bluetoothActive ? null : theme.iconColor,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
