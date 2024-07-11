import 'package:found_space_flutter_rest_api/found_space_flutter_rest_api.dart';
import 'package:found_space_flutter_web_application/common/store/audio_player.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_bluetooth_store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/common/store/screen_saver.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/store/sauna_program_page.store.dart';
import 'package:found_space_flutter_web_application/services/services.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final locator = GetIt.instance;

void configure() {
  locator.registerFactory<Logger>(() => Logger());
  locator.registerLazySingleton<AudioPlayerStore>(() => AudioPlayerStore());
  locator.registerLazySingleton<ScreenSaverStore>(() => ScreenSaverStore());
  locator.registerLazySingleton<SaunaProgramPageStore>(() => SaunaProgramPageStore());
  locator.registerLazySingleton<SaunaStore>(() => SaunaStore());
  locator.registerLazySingleton<SaunaLocalStorageStore>(() => SaunaLocalStorageStore());
  locator.registerLazySingleton<SaunaBluetoothStore>(() => SaunaBluetoothStore());
  locator.registerSingleton<SaunaClientBase>(SaunaClientBase());
  locator.registerSingleton<RestAPIRepository>(RestAPIRepositoryImpl(locator<SaunaClientBase>()));
  locator.registerSingleton<SaunaConfigRepository>(SaunaConfigRepositoryImpl(locator<SaunaClientBase>()));
  locator.registerSingleton<AppConfigBase>(AppConfigBase());
}
