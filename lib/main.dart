import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:found_space_flutter_web_application/app_startup/environment_config.dart';
import 'package:found_space_flutter_web_application/common/found_space_router.dart';
import 'package:found_space_flutter_web_application/common/mobx_provider.dart';
import 'package:found_space_flutter_web_application/common/store/audio_player.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_bluetooth_store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/common/store/screen_saver.store.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_font.dart';
import 'package:found_space_flutter_web_application/common/ui/themes.dart';
import 'package:found_space_flutter_web_application/di/app_component_interface.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/store/sauna_program_page.store.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'services/service_locator.dart';
import 'src/chameleon_theme/adaptive_chameleon_theme.dart';

final rootNavigationKey = GlobalKey<NavigatorState>();

final fToast = FToast();

late final String _initialRoute;

final providers = [
  MobxProvider<AudioPlayerStore>(
    create: (_) => locator<AudioPlayerStore>(),
  ),
  MobxProvider<ScreenSaverStore>(
    create: (_) => locator<ScreenSaverStore>(),
  ),
  MobxProvider<SaunaProgramPageStore>(
    create: (_) => locator<SaunaProgramPageStore>(),
  ),
  MobxProvider<SaunaStore>(
    create: (_) => locator<SaunaStore>(),
  ),
  MobxProvider<SaunaLocalStorageStore>(
    create: (_) => locator<SaunaLocalStorageStore>(),
  ),
  MobxProvider<SaunaBluetoothStore>(
    create: (_) => locator<SaunaBluetoothStore>(),
  ),
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  configure();
  _initialRoute = await RouteGenerator.initialRoute();
  AppComponentBase.setupAppComponentBase(EnvironmentConfig.flavor);
  runApp(const FoundSpaceApp());
}

class FoundSpaceApp extends StatelessWidget {
  const FoundSpaceApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveChameleonThemeWidget(
      themeCollection: AppThemes.themeCollection,
      darkThemeCollection: AppThemes.darkThemeCollection,
      defaultThemeId: 1,
      builder: (context, theme, darkTheme, themeMode) {
        return MultiProvider(
          providers: providers,
          child: MaterialApp(
            navigatorKey: rootNavigationKey,
            builder: (context, child) => Overlay(
              initialEntries: [
                if (child != null) ...[
                  OverlayEntry(
                    builder: (context) => child,
                  ),
                ],
              ],
            ),
            title: 'Found Space',
            onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
            initialRoute: _initialRoute,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: ThemeFont.defaultFontFamily,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              fontFamily: ThemeFont.defaultFontFamily,
              brightness: Brightness.dark,
            ),
            themeMode: themeMode,
          ),
        );
      },
    );
  }
}
