import 'package:flutter/material.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/found_space_router.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/common/store/screen_saver.store.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_security_pin/store/sauna_security_pin_page.store.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:provider/provider.dart';

class SaunaControlQRCodeButton extends StatefulWidget {
  const SaunaControlQRCodeButton({Key? key}) : super(key: key);

  @override
  _SaunaControlQRCodeButtonState createState() => _SaunaControlQRCodeButtonState();
}

class _SaunaControlQRCodeButtonState extends State<SaunaControlQRCodeButton> {
  late ScreenSize _screenSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    _screenSize = Utils.getScreenSize(context);

    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: FeedbackSoundWrapper(
        onTap: () async {
          locator<SaunaStore>().setPopupType(type: PopupType.qrCode);
          context.read<ScreenSaverStore>().cancelScreenSaverTimer();
          if (locator<SaunaLocalStorageStore>().isSaunaPairingEnabled) {
            final status = await Navigator.pushNamed(
              context,
              RouteGenerator.saunaSecurityPinPage,
              arguments: SaunaSecurityPinPageState.verifyPairing,
            ) as bool?;
            if (status == true) {
              await _navigateToQRPage();
            }
          } else {
            await _navigateToQRPage();
          }

          locator<SaunaStore>().setPopupType(type: PopupType.none);
          context.read<ScreenSaverStore>().setupScreenSaverTimer();
        },
        child: Container(
          height: _screenSize.getHeight(min: 60, max: 72),
          width: _screenSize.getHeight(min: 60, max: 72),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 14, max: 20)),
            color: theme.buttonBackgroundColor,
            boxShadow: theme.saunaControlPageButtonShadow,
          ),
          alignment: Alignment.center,
          child: Container(
            height: _screenSize.getHeight(min: 60, max: 72),
            width: _screenSize.getHeight(min: 60, max: 72),
            alignment: Alignment.center,
            child: Assets.connectMobile.toSvgPicture(
              width: _screenSize.getHeight(min: 24, max: 32),
              height: _screenSize.getHeight(min: 24, max: 32),
              color: theme.iconColor,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToQRPage() async {
    final isOpenWifiPopup = await Navigator.pushNamed(
      context,
      RouteGenerator.saunaQRCodePage,
    ) as bool?;

    if (isOpenWifiPopup == true) {
      if (!locator<SaunaLocalStorageStore>().isWifiButtonEnabled) {
        final status = await Navigator.pushNamed(
          context,
          RouteGenerator.saunaSecurityPinPage,
          arguments: SaunaSecurityPinPageState.verifySettings,
        ) as bool?;
        if (status == true) {
          await Navigator.pushNamed(
            context,
            RouteGenerator.saunaNetworkPage,
          );
        }
      } else {
        await Navigator.pushNamed(
          context,
          RouteGenerator.saunaNetworkPage,
        );
      }
    }
  }
}
