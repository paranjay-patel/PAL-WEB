import 'package:found_space_flutter_web_application/services/services.dart';
import 'package:mobx/mobx.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/program_extension.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/sauna_properties_extension.dart';
import 'package:found_space_flutter_web_application/common/store/screen_saver.store.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/models/models.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/store/sauna_program_page.store.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/sauna_config_extension.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/widgets/sauna_advance_settings/sauna_system_settings_section.dart';
import 'sauna.store.dart';
import 'package:logger/logger.dart';

import 'package:found_space_flutter_web_application/common/mobx_provider.dart';

part 'sauna_local_storage.store.g.dart';

class SaunaLocalStorageStore = _SaunaLocalStorageStoreBase with _$SaunaLocalStorageStore;

abstract class _SaunaLocalStorageStoreBase with Store, Disposable {
  final _saunaConfigRepository = locator<SaunaConfigRepository>();
  final _logger = locator<Logger>();
  final _saunaStore = locator<SaunaStore>();

  @readonly
  List<SaunaConfigType> _saunaConfigTypes = [];

  @readonly
  SaunaConfig? _saunaConfig;

  @computed
  bool get isNightMode => _saunaConfig?.isNightMode ?? false;

  @computed
  SaunaSaverSleepModeType get saunaSaverSleepModeType =>
      _saunaConfig?.saverSleepModeType ?? SaunaSaverSleepModeType.saverMode;

  @computed
  SaunaSaverSleepDuration get saunaSaverSleepDuration =>
      _saunaConfig?.saverSleepDuration ?? SaunaSaverSleepDuration.oneMin;

  List<String> get saunaSelectedColor => _saunaConfig?.color ?? [];

  @computed
  bool get isSecuritySettingsEnabled => _saunaConfig?.securitySettings?.isSettingsOn ?? false;

  @computed
  bool get isSaunaPairingEnabled => _saunaConfig?.securitySettings?.isSaunaPairingOn ?? false;

  @computed
  bool get isWifiButtonEnabled => _saunaConfig?.securitySettings?.isWifiButtonEnabled ?? true;

  @computed
  bool get isBluetoothButtonEnabled => _saunaConfig?.securitySettings?.isBluetoothButtonEnabled ?? true;

  @computed
  bool get isSystemSoundOn => _saunaConfig?.isSystemSoundOn ?? true;

  @computed
  bool get isAllSoundOn => _saunaConfig?.isAllSoundOn ?? true;

  @computed
  bool get isSessionsSoundOn => _saunaConfig?.isSessionsSoundOn ?? true;

  @computed
  TemperatureScale get temperatureScale =>
      _saunaConfig?.temperatureScale ??
      (_saunaStore.saunaProperties?.defaultTemperatureScale ?? TemperatureScale.celsius);

  @computed
  TimeConvention get defaultConvention =>
      _saunaConfig?.timeConvention ?? (_saunaStore.saunaProperties?.defaultTimeConvention ?? TimeConvention.twelve);

  @computed
  String? get currentSecurityPin => _saunaConfig?.securityPin;

  @readonly
  List<Color> _colors = _defaultColors;

  @action
  Future<void> fetchLocalConfigs() async {
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      final configTypes = await _saunaConfigRepository.fetchConfigs(
        token: credentials.item1,
        saunaId: credentials.item2,
      );
      if (configTypes != null && configTypes.isNotEmpty) {
        _saunaConfigTypes = configTypes;
      }
      await _fetchAppSettings();
    } catch (error, stackTrace) {
      _logger.e('Error loading _fetchLocalConfigs', error, stackTrace);
    }
  }

  @action
  Future<void> _fetchAppSettings() async {
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      final result = await _saunaConfigRepository.fetchConfig(
        token: credentials.item1,
        saunaId: credentials.item2,
        configType: SaunaConfigType.appSettings,
      );

      if (result != null) {
        _saunaConfig = result;
        _preparedSelectedColors();
        locator<ScreenSaverStore>().fetchSaunaSaverMode();
      }
    } catch (error, stackTrace) {
      locator<ScreenSaverStore>().fetchSaunaSaverMode();
      _logger.e('Error loading _fetchAppSettings', error, stackTrace);
    }
  }

  @action
  Future<Program?> fetchCustomProgram() async {
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return null;

      final result = await _saunaConfigRepository.fetchConfig(
        token: credentials.item1,
        saunaId: credentials.item2,
        configType: SaunaConfigType.customProgram,
      );
      return result?.customProgram;
    } catch (error, stackTrace) {
      _logger.e('Error loading fetchCustomProgram', error, stackTrace);
      return null;
    }
  }

  @action
  Future<void> setAppThemeSettings({required bool isNightMode}) async {
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      var config = _saunaConfig;
      config ??= SaunaConfig(themeMode: isNightMode ? SaunaTheme.dark : SaunaTheme.light);

      if (_saunaConfigTypes.contains(SaunaConfigType.appSettings)) {
        final result = await _saunaConfigRepository.putSaunaConfig(
          token: credentials.item1,
          saunaId: credentials.item2,
          configType: SaunaConfigType.appSettings,
          saunaConfig: config.copyWith(themeMode: isNightMode ? SaunaTheme.dark : SaunaTheme.light),
        );
        if (result != null) {
          _saunaConfig = result;
        }
      } else {
        final result = await _saunaConfigRepository.setSaunaConfig(
          token: credentials.item1,
          saunaId: credentials.item2,
          configType: SaunaConfigType.appSettings,
          saunaConfig: config.copyWith(themeMode: isNightMode ? SaunaTheme.dark : SaunaTheme.light),
        );
        if (result != null) {
          _saunaConfigTypes.add(SaunaConfigType.appSettings);
          _saunaConfig = result;
        }
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading setAppThemeSettings', error, stackTrace);
    }
  }

  @action
  Future<void> setSoundOnEnableDisabled({bool? isAllSound, bool? isSystemSound, bool? isSessionsSound}) async {
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      var config = _saunaConfig;
      config ??= SaunaConfig(
        isAllSoundOn: isAllSound ?? isAllSoundOn,
        isSystemSoundOn: isSystemSound ?? isSystemSoundOn,
        isSessionsSoundOn: isSessionsSound ?? isSessionsSoundOn,
      );

      if (_saunaConfigTypes.contains(SaunaConfigType.appSettings)) {
        final result = await _saunaConfigRepository.putSaunaConfig(
          token: credentials.item1,
          saunaId: credentials.item2,
          configType: SaunaConfigType.appSettings,
          saunaConfig: config.copyWith(
            isAllSoundOn: isAllSound ?? isAllSoundOn,
            isSystemSoundOn: isSystemSound ?? isSystemSoundOn,
            isSessionsSoundOn: isSessionsSound ?? isSessionsSoundOn,
          ),
        );
        if (result != null) {
          _saunaConfig = result;
        }
      } else {
        final result = await _saunaConfigRepository.setSaunaConfig(
          token: credentials.item1,
          saunaId: credentials.item2,
          configType: SaunaConfigType.appSettings,
          saunaConfig: config.copyWith(
            isAllSoundOn: isAllSound ?? isAllSoundOn,
            isSystemSoundOn: isSystemSound ?? isSystemSoundOn,
            isSessionsSoundOn: isSessionsSound ?? isSessionsSoundOn,
          ),
        );
        if (result != null) {
          _saunaConfigTypes.add(SaunaConfigType.appSettings);
          _saunaConfig = result;
        }
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading setSoundOnEnableDisabled', error, stackTrace);
    }
  }

  @action
  Future<void> setTemperatureScaleSettings({required TemperatureScale temperatureScale}) async {
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      var config = _saunaConfig;
      config ??= SaunaConfig(temperatureScale: temperatureScale);

      if (_saunaConfigTypes.contains(SaunaConfigType.appSettings)) {
        final result = await _saunaConfigRepository.putSaunaConfig(
          token: credentials.item1,
          saunaId: credentials.item2,
          configType: SaunaConfigType.appSettings,
          saunaConfig: config.copyWith(temperatureScale: temperatureScale),
        );
        if (result != null) {
          _saunaConfig = result;
        }
      } else {
        final result = await _saunaConfigRepository.setSaunaConfig(
          token: credentials.item1,
          saunaId: credentials.item2,
          configType: SaunaConfigType.appSettings,
          saunaConfig: config.copyWith(temperatureScale: temperatureScale),
        );
        if (result != null) {
          _saunaConfigTypes.add(SaunaConfigType.appSettings);
          _saunaConfig = result;
        }
      }
      await locator<SaunaProgramPageStore>().fetchSuggestedPrograms();
    } catch (error, stackTrace) {
      _logger.e('Error loading setTemperatureScaleSettings', error, stackTrace);
    }
  }

  @action
  Future<void> setSaunaSecurityPin({required String pin}) async {
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      var config = _saunaConfig;
      config ??= SaunaConfig(securityPin: pin);

      if (_saunaConfigTypes.contains(SaunaConfigType.appSettings)) {
        final result = await _saunaConfigRepository.putSaunaConfig(
          token: credentials.item1,
          saunaId: credentials.item2,
          configType: SaunaConfigType.appSettings,
          saunaConfig: config.copyWith(securityPin: pin),
        );
        if (result != null) {
          _saunaConfig = result;
        }
      } else {
        final result = await _saunaConfigRepository.setSaunaConfig(
          token: credentials.item1,
          saunaId: credentials.item2,
          configType: SaunaConfigType.appSettings,
          saunaConfig: config.copyWith(securityPin: pin),
        );
        if (result != null) {
          _saunaConfigTypes.add(SaunaConfigType.appSettings);
          _saunaConfig = result;
        }
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading setSecurityPin', error, stackTrace);
    }
  }

  @action
  Future<void> setSecuritySetting({required SystemSettingsType type, required bool status}) async {
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      SaunaSecuritySettings? emptySettings;
      if (type == SystemSettingsType.settings) {
        emptySettings = SaunaSecuritySettings(isSettingsOn: status);
      } else if (type == SystemSettingsType.saunaPairing) {
        emptySettings = SaunaSecuritySettings(isSaunaPairingOn: status);
      } else if (type == SystemSettingsType.enableWifiButton) {
        emptySettings = SaunaSecuritySettings(isWifiButtonEnabled: status);
      } else if (type == SystemSettingsType.enableBluetoothButton) {
        emptySettings = SaunaSecuritySettings(isBluetoothButtonEnabled: status);
      }

      var config = _saunaConfig ?? SaunaConfig(securitySettings: emptySettings);

      final securitySettings = config.securitySettings ?? emptySettings;

      if (type == SystemSettingsType.settings) {
        config = config.copyWith(securitySettings: securitySettings?.copyWith(isSettingsOn: status));
      } else if (type == SystemSettingsType.saunaPairing) {
        config = config.copyWith(securitySettings: securitySettings?.copyWith(isSaunaPairingOn: status));
      } else if (type == SystemSettingsType.enableWifiButton) {
        config = config.copyWith(securitySettings: securitySettings?.copyWith(isWifiButtonEnabled: status));
      } else if (type == SystemSettingsType.enableBluetoothButton) {
        config = config.copyWith(securitySettings: securitySettings?.copyWith(isBluetoothButtonEnabled: status));
      }

      if (_saunaConfigTypes.contains(SaunaConfigType.appSettings)) {
        final result = await _saunaConfigRepository.putSaunaConfig(
          token: credentials.item1,
          saunaId: credentials.item2,
          configType: SaunaConfigType.appSettings,
          saunaConfig: config,
        );
        if (result != null) {
          _saunaConfig = result;
        }
      } else {
        final result = await _saunaConfigRepository.setSaunaConfig(
          token: credentials.item1,
          saunaId: credentials.item2,
          configType: SaunaConfigType.appSettings,
          saunaConfig: config,
        );
        if (result != null) {
          _saunaConfigTypes.add(SaunaConfigType.appSettings);
          _saunaConfig = result;
        }
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading setSecuritySetting', error, stackTrace);
    }
  }

  @action
  Future<void> setTimeConventionsSettings({required TimeConvention timeConvention}) async {
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      var config = _saunaConfig;
      config ??= SaunaConfig(timeConvention: timeConvention);

      if (_saunaConfigTypes.contains(SaunaConfigType.appSettings)) {
        final result = await _saunaConfigRepository.putSaunaConfig(
          token: credentials.item1,
          saunaId: credentials.item2,
          configType: SaunaConfigType.appSettings,
          saunaConfig: config.copyWith(timeConvention: timeConvention),
        );
        if (result != null) {
          _saunaConfig = result;
        }
      } else {
        final result = await _saunaConfigRepository.setSaunaConfig(
          token: credentials.item1,
          saunaId: credentials.item2,
          configType: SaunaConfigType.appSettings,
          saunaConfig: config.copyWith(timeConvention: timeConvention),
        );
        if (result != null) {
          _saunaConfigTypes.add(SaunaConfigType.appSettings);
          _saunaConfig = result;
        }
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading setTimeConventionsSettings', error, stackTrace);
    }
  }

  @action
  Future<void> setAppSaunaSaverSettings({
    required SaunaSaverSleepModeType saunaSaverSleepModeType,
    required SaunaSaverSleepDuration saunaSaverSleepDuration,
  }) async {
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      var config = _saunaConfig;
      config ??= SaunaConfig(themeMode: isNightMode ? SaunaTheme.dark : SaunaTheme.light);

      if (_saunaConfigTypes.contains(SaunaConfigType.appSettings)) {
        final result = await _saunaConfigRepository.putSaunaConfig(
          token: credentials.item1,
          saunaId: credentials.item2,
          configType: SaunaConfigType.appSettings,
          saunaConfig: config.copyWith(
            saunaSaverSleepModeType: saunaSaverSleepModeType,
            saunaSaverSleepDuration: saunaSaverSleepDuration,
          ),
        );
        if (result != null) {
          _saunaConfig = result;
        }
      } else {
        final result = await _saunaConfigRepository.setSaunaConfig(
          token: credentials.item1,
          saunaId: credentials.item2,
          configType: SaunaConfigType.appSettings,
          saunaConfig: config.copyWith(
            saunaSaverSleepModeType: saunaSaverSleepModeType,
            saunaSaverSleepDuration: saunaSaverSleepDuration,
          ),
        );
        if (result != null) {
          _saunaConfigTypes.add(SaunaConfigType.appSettings);
          _saunaConfig = result;
        }
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading setAppSaunaSaverSettings', error, stackTrace);
    }
  }

  @action
  Future<void> setAppSaunaSelectedColor({
    required List<String> selectedColor,
  }) async {
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;
      var config = _saunaConfig;

      config ??= SaunaConfig(saunaSelectedColor: selectedColor);

      if (_saunaConfigTypes.contains(SaunaConfigType.appSettings)) {
        final result = await _saunaConfigRepository.putSaunaConfig(
          token: credentials.item1,
          saunaId: credentials.item2,
          configType: SaunaConfigType.appSettings,
          saunaConfig: config.copyWith(selectedColor: selectedColor),
        );
        if (result != null) {
          _saunaConfig = result;
        }
      } else {
        final result = await _saunaConfigRepository.setSaunaConfig(
          token: credentials.item1,
          saunaId: credentials.item2,
          configType: SaunaConfigType.appSettings,
          saunaConfig: config.copyWith(selectedColor: selectedColor),
        );
        if (result != null) {
          _saunaConfigTypes.add(SaunaConfigType.appSettings);
          _saunaConfig = result;
        }
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading setAppSaunaSaverSettings', error, stackTrace);
    }
  }

  @action
  Future<void> setCustomProgram({required Program activeProgram}) async {
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;
      final program = activeProgram.copyWith(name: 'Custom');

      if (_saunaConfigTypes.contains(SaunaConfigType.customProgram)) {
        await _saunaConfigRepository.putSaunaConfig(
            token: credentials.item1,
            saunaId: credentials.item2,
            configType: SaunaConfigType.customProgram,
            saunaConfig: SaunaConfig(customProgram: program));
      } else {
        final result = await _saunaConfigRepository.setSaunaConfig(
            token: credentials.item1,
            saunaId: credentials.item2,
            configType: SaunaConfigType.customProgram,
            saunaConfig: SaunaConfig(customProgram: program));
        if (result != null) {
          _saunaConfigTypes.add(SaunaConfigType.customProgram);
        }
      }
      await locator<SaunaProgramPageStore>().fetchSuggestedPrograms();
    } catch (error, stackTrace) {
      _logger.e('Error loading setCustomProgram', error, stackTrace);
    }
  }

  void _preparedSelectedColors() {
    if (saunaSelectedColor.isEmpty) return;
    var colors = _defaultColors.toList();
    final hexColor = saunaSelectedColor.map((e) => HexColor.fromHex(e)).toList();

    colors.addAll(hexColor);
    _colors = [];
    _colors = colors;
  }

  @action
  Future<void> saveColor(Color color) async {
    if (_colors.contains(color)) return;
    try {
      final existingColors = saunaSelectedColor;
      existingColors.add(color.toHex());
      if (existingColors.length > 2) {
        existingColors.removeAt(0);
      }
      await setAppSaunaSelectedColor(selectedColor: existingColors);
      _preparedSelectedColors();
    } catch (error) {
      _logger.e(error);
    }
  }
}

const _defaultColors = [
  Color(0XFFFFFFFF),
  Color(0XFFFF89FF),
  Color(0XFFFF0000),
  Color(0XFFFF9100),
  Color(0XFFFFFF00),
  Color(0XFF00FF00),
  Color(0XFF00B000),
  Color(0XFF00BEFF),
  Color(0XFF0000FF),
  Color(0XFFBB7BFF),
];
