import 'package:flutter/material.dart';
import 'package:found_space_flutter_web_application/pages/sauna_bluetooth_page/sauna_bluetooth_page.dart';
import 'package:found_space_flutter_web_application/pages/sauna_bluetooth_settings_page/sauna_bluetooth_settings_page.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_page_common.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/sauna_control_popup_page.dart';
import 'package:found_space_flutter_web_application/pages/sauna_date_and_time_page/sauna_date_and_time_page.dart';
import 'package:found_space_flutter_web_application/pages/sauna_firmware_update_page/sauna_firmware_update_page.dart';
import 'package:found_space_flutter_web_application/pages/sauna_home/home_page.dart';
import 'package:found_space_flutter_web_application/pages/sauna_home/store/sauna_home_page.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_network_page/sauna_network_page.dart';
import 'package:found_space_flutter_web_application/pages/sauna_qr_code/page/sauna_qr_code_page.dart';
import 'package:found_space_flutter_web_application/pages/sauna_security_pin/sauna_security_pin_page.dart';
import 'package:found_space_flutter_web_application/pages/sauna_security_pin/store/sauna_security_pin_page.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_update_page/sauna_update_page.dart';
import 'package:found_space_flutter_web_application/pages/splash_screen.dart';
import 'package:page_transition/page_transition.dart';

class RouteGenerator {
  RouteGenerator._();

  static const String homePage = '/';
  static const String splash = 'splash';
  static const String saunaHomePage = 'dash_board';
  static const String saunaControlPopupPage = 'sauna_control_popup_page';
  static const String saunaQRCodePage = 'sauna_control_qr_page';
  static const String saunaBluetoothPage = 'sauna_bluetooth_page';
  static const String saunaDateAndTimePage = 'sauna_date_and_time_page';
  static const String saunaBluetoothSettingsPage = 'sauna_bluetooth_settings_page';
  static const String saunaUpdatePage = 'sauna_update_page';
  static const String saunaFirmwareUpdatePage = 'sauna_firmware_update_page';
  static const String saunaSecurityPinPage = 'sauna_security_pin_page';
  static const String saunaNetworkPage = 'sauna_network_page';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case saunaHomePage:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case saunaControlPopupPage:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const SaunaControlPopupPage(),
          duration: const Duration(milliseconds: 10),
          reverseDuration: const Duration(milliseconds: 10),
          settings: settings,
        );
      case saunaQRCodePage:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const SaunaControlQRPage(),
          duration: const Duration(milliseconds: 10),
          reverseDuration: const Duration(milliseconds: 10),
          settings: settings,
        );
      case saunaBluetoothPage:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const SaunaBluetoothPage(),
          duration: const Duration(milliseconds: 10),
          reverseDuration: const Duration(milliseconds: 10),
          settings: settings,
        );
      case saunaDateAndTimePage:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const SaunaDateAndTimePage(),
          duration: const Duration(milliseconds: 10),
          reverseDuration: const Duration(milliseconds: 10),
          settings: settings,
        );
      case saunaBluetoothSettingsPage:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const SaunaBluetoothSettingsPage(),
          duration: const Duration(milliseconds: 10),
          reverseDuration: const Duration(milliseconds: 10),
          settings: settings,
        );
      case saunaUpdatePage:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const SaunaUpdatePage(),
          duration: const Duration(milliseconds: 10),
          reverseDuration: const Duration(milliseconds: 10),
          settings: settings,
        );
      case saunaFirmwareUpdatePage:
        return PageTransition(
          type: PageTransitionType.fade,
          child: SaunaFirmwareUpdatePage(type: settings.arguments as SaunaFirmwareUpdatePageType),
          duration: const Duration(milliseconds: 10),
          reverseDuration: const Duration(milliseconds: 10),
          settings: settings,
        );
      case saunaSecurityPinPage:
        return PageTransition(
          type: PageTransitionType.fade,
          child: SaunaSecurityPinPage(
            pageState: settings.arguments as SaunaSecurityPinPageState,
          ),
          duration: const Duration(milliseconds: 10),
          reverseDuration: const Duration(milliseconds: 10),
          settings: settings,
        );
      case saunaNetworkPage:
        return PageTransition(
          type: PageTransitionType.fade,
          child: const SaunaNetworkPage(),
          duration: const Duration(milliseconds: 10),
          reverseDuration: const Duration(milliseconds: 10),
          settings: settings,
        );
      default:
        throw const RouteException('Route not found');
    }
  }

  static Future<String> initialRoute() async => splash;
}

class RouteException implements Exception {
  const RouteException(this.message);

  final String message;
}

class SaunaControlPopupPageArguments {
  final SaunaBottomButton saunaBottomButton;
  final SaunaHomePageStore saunaHomePageStore;

  const SaunaControlPopupPageArguments({
    required this.saunaBottomButton,
    required this.saunaHomePageStore,
  });
}
