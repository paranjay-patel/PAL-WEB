// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sauna_local_storage.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SaunaLocalStorageStore on _SaunaLocalStorageStoreBase, Store {
  Computed<bool>? _$isNightModeComputed;

  @override
  bool get isNightMode =>
      (_$isNightModeComputed ??= Computed<bool>(() => super.isNightMode,
              name: '_SaunaLocalStorageStoreBase.isNightMode'))
          .value;
  Computed<SaunaSaverSleepModeType>? _$saunaSaverSleepModeTypeComputed;

  @override
  SaunaSaverSleepModeType get saunaSaverSleepModeType =>
      (_$saunaSaverSleepModeTypeComputed ??= Computed<SaunaSaverSleepModeType>(
              () => super.saunaSaverSleepModeType,
              name: '_SaunaLocalStorageStoreBase.saunaSaverSleepModeType'))
          .value;
  Computed<SaunaSaverSleepDuration>? _$saunaSaverSleepDurationComputed;

  @override
  SaunaSaverSleepDuration get saunaSaverSleepDuration =>
      (_$saunaSaverSleepDurationComputed ??= Computed<SaunaSaverSleepDuration>(
              () => super.saunaSaverSleepDuration,
              name: '_SaunaLocalStorageStoreBase.saunaSaverSleepDuration'))
          .value;
  Computed<bool>? _$isSecuritySettingsEnabledComputed;

  @override
  bool get isSecuritySettingsEnabled => (_$isSecuritySettingsEnabledComputed ??=
          Computed<bool>(() => super.isSecuritySettingsEnabled,
              name: '_SaunaLocalStorageStoreBase.isSecuritySettingsEnabled'))
      .value;
  Computed<bool>? _$isSaunaPairingEnabledComputed;

  @override
  bool get isSaunaPairingEnabled => (_$isSaunaPairingEnabledComputed ??=
          Computed<bool>(() => super.isSaunaPairingEnabled,
              name: '_SaunaLocalStorageStoreBase.isSaunaPairingEnabled'))
      .value;
  Computed<bool>? _$isWifiButtonEnabledComputed;

  @override
  bool get isWifiButtonEnabled => (_$isWifiButtonEnabledComputed ??=
          Computed<bool>(() => super.isWifiButtonEnabled,
              name: '_SaunaLocalStorageStoreBase.isWifiButtonEnabled'))
      .value;
  Computed<bool>? _$isBluetoothButtonEnabledComputed;

  @override
  bool get isBluetoothButtonEnabled => (_$isBluetoothButtonEnabledComputed ??=
          Computed<bool>(() => super.isBluetoothButtonEnabled,
              name: '_SaunaLocalStorageStoreBase.isBluetoothButtonEnabled'))
      .value;
  Computed<bool>? _$isSystemSoundOnComputed;

  @override
  bool get isSystemSoundOn =>
      (_$isSystemSoundOnComputed ??= Computed<bool>(() => super.isSystemSoundOn,
              name: '_SaunaLocalStorageStoreBase.isSystemSoundOn'))
          .value;
  Computed<bool>? _$isAllSoundOnComputed;

  @override
  bool get isAllSoundOn =>
      (_$isAllSoundOnComputed ??= Computed<bool>(() => super.isAllSoundOn,
              name: '_SaunaLocalStorageStoreBase.isAllSoundOn'))
          .value;
  Computed<bool>? _$isSessionsSoundOnComputed;

  @override
  bool get isSessionsSoundOn => (_$isSessionsSoundOnComputed ??= Computed<bool>(
          () => super.isSessionsSoundOn,
          name: '_SaunaLocalStorageStoreBase.isSessionsSoundOn'))
      .value;
  Computed<TemperatureScale>? _$temperatureScaleComputed;

  @override
  TemperatureScale get temperatureScale => (_$temperatureScaleComputed ??=
          Computed<TemperatureScale>(() => super.temperatureScale,
              name: '_SaunaLocalStorageStoreBase.temperatureScale'))
      .value;
  Computed<TimeConvention>? _$defaultConventionComputed;

  @override
  TimeConvention get defaultConvention => (_$defaultConventionComputed ??=
          Computed<TimeConvention>(() => super.defaultConvention,
              name: '_SaunaLocalStorageStoreBase.defaultConvention'))
      .value;
  Computed<String?>? _$currentSecurityPinComputed;

  @override
  String? get currentSecurityPin => (_$currentSecurityPinComputed ??=
          Computed<String?>(() => super.currentSecurityPin,
              name: '_SaunaLocalStorageStoreBase.currentSecurityPin'))
      .value;

  late final _$_saunaConfigTypesAtom = Atom(
      name: '_SaunaLocalStorageStoreBase._saunaConfigTypes', context: context);

  List<SaunaConfigType> get saunaConfigTypes {
    _$_saunaConfigTypesAtom.reportRead();
    return super._saunaConfigTypes;
  }

  @override
  List<SaunaConfigType> get _saunaConfigTypes => saunaConfigTypes;

  @override
  set _saunaConfigTypes(List<SaunaConfigType> value) {
    _$_saunaConfigTypesAtom.reportWrite(value, super._saunaConfigTypes, () {
      super._saunaConfigTypes = value;
    });
  }

  late final _$_saunaConfigAtom =
      Atom(name: '_SaunaLocalStorageStoreBase._saunaConfig', context: context);

  SaunaConfig? get saunaConfig {
    _$_saunaConfigAtom.reportRead();
    return super._saunaConfig;
  }

  @override
  SaunaConfig? get _saunaConfig => saunaConfig;

  @override
  set _saunaConfig(SaunaConfig? value) {
    _$_saunaConfigAtom.reportWrite(value, super._saunaConfig, () {
      super._saunaConfig = value;
    });
  }

  late final _$_colorsAtom =
      Atom(name: '_SaunaLocalStorageStoreBase._colors', context: context);

  List<Color> get colors {
    _$_colorsAtom.reportRead();
    return super._colors;
  }

  @override
  List<Color> get _colors => colors;

  @override
  set _colors(List<Color> value) {
    _$_colorsAtom.reportWrite(value, super._colors, () {
      super._colors = value;
    });
  }

  late final _$fetchLocalConfigsAsyncAction = AsyncAction(
      '_SaunaLocalStorageStoreBase.fetchLocalConfigs',
      context: context);

  @override
  Future<void> fetchLocalConfigs() {
    return _$fetchLocalConfigsAsyncAction.run(() => super.fetchLocalConfigs());
  }

  late final _$_fetchAppSettingsAsyncAction = AsyncAction(
      '_SaunaLocalStorageStoreBase._fetchAppSettings',
      context: context);

  @override
  Future<void> _fetchAppSettings() {
    return _$_fetchAppSettingsAsyncAction.run(() => super._fetchAppSettings());
  }

  late final _$fetchCustomProgramAsyncAction = AsyncAction(
      '_SaunaLocalStorageStoreBase.fetchCustomProgram',
      context: context);

  @override
  Future<Program?> fetchCustomProgram() {
    return _$fetchCustomProgramAsyncAction
        .run(() => super.fetchCustomProgram());
  }

  late final _$setAppThemeSettingsAsyncAction = AsyncAction(
      '_SaunaLocalStorageStoreBase.setAppThemeSettings',
      context: context);

  @override
  Future<void> setAppThemeSettings({required bool isNightMode}) {
    return _$setAppThemeSettingsAsyncAction
        .run(() => super.setAppThemeSettings(isNightMode: isNightMode));
  }

  late final _$setSoundOnEnableDisabledAsyncAction = AsyncAction(
      '_SaunaLocalStorageStoreBase.setSoundOnEnableDisabled',
      context: context);

  @override
  Future<void> setSoundOnEnableDisabled(
      {bool? isAllSound, bool? isSystemSound, bool? isSessionsSound}) {
    return _$setSoundOnEnableDisabledAsyncAction.run(() => super
        .setSoundOnEnableDisabled(
            isAllSound: isAllSound,
            isSystemSound: isSystemSound,
            isSessionsSound: isSessionsSound));
  }

  late final _$setTemperatureScaleSettingsAsyncAction = AsyncAction(
      '_SaunaLocalStorageStoreBase.setTemperatureScaleSettings',
      context: context);

  @override
  Future<void> setTemperatureScaleSettings(
      {required TemperatureScale temperatureScale}) {
    return _$setTemperatureScaleSettingsAsyncAction.run(() =>
        super.setTemperatureScaleSettings(temperatureScale: temperatureScale));
  }

  late final _$setSaunaSecurityPinAsyncAction = AsyncAction(
      '_SaunaLocalStorageStoreBase.setSaunaSecurityPin',
      context: context);

  @override
  Future<void> setSaunaSecurityPin({required String pin}) {
    return _$setSaunaSecurityPinAsyncAction
        .run(() => super.setSaunaSecurityPin(pin: pin));
  }

  late final _$setSecuritySettingAsyncAction = AsyncAction(
      '_SaunaLocalStorageStoreBase.setSecuritySetting',
      context: context);

  @override
  Future<void> setSecuritySetting(
      {required SystemSettingsType type, required bool status}) {
    return _$setSecuritySettingAsyncAction
        .run(() => super.setSecuritySetting(type: type, status: status));
  }

  late final _$setTimeConventionsSettingsAsyncAction = AsyncAction(
      '_SaunaLocalStorageStoreBase.setTimeConventionsSettings',
      context: context);

  @override
  Future<void> setTimeConventionsSettings(
      {required TimeConvention timeConvention}) {
    return _$setTimeConventionsSettingsAsyncAction.run(
        () => super.setTimeConventionsSettings(timeConvention: timeConvention));
  }

  late final _$setAppSaunaSaverSettingsAsyncAction = AsyncAction(
      '_SaunaLocalStorageStoreBase.setAppSaunaSaverSettings',
      context: context);

  @override
  Future<void> setAppSaunaSaverSettings(
      {required SaunaSaverSleepModeType saunaSaverSleepModeType,
      required SaunaSaverSleepDuration saunaSaverSleepDuration}) {
    return _$setAppSaunaSaverSettingsAsyncAction.run(() => super
        .setAppSaunaSaverSettings(
            saunaSaverSleepModeType: saunaSaverSleepModeType,
            saunaSaverSleepDuration: saunaSaverSleepDuration));
  }

  late final _$setAppSaunaSelectedColorAsyncAction = AsyncAction(
      '_SaunaLocalStorageStoreBase.setAppSaunaSelectedColor',
      context: context);

  @override
  Future<void> setAppSaunaSelectedColor({required List<String> selectedColor}) {
    return _$setAppSaunaSelectedColorAsyncAction.run(
        () => super.setAppSaunaSelectedColor(selectedColor: selectedColor));
  }

  late final _$setCustomProgramAsyncAction = AsyncAction(
      '_SaunaLocalStorageStoreBase.setCustomProgram',
      context: context);

  @override
  Future<void> setCustomProgram({required Program activeProgram}) {
    return _$setCustomProgramAsyncAction
        .run(() => super.setCustomProgram(activeProgram: activeProgram));
  }

  late final _$saveColorAsyncAction =
      AsyncAction('_SaunaLocalStorageStoreBase.saveColor', context: context);

  @override
  Future<void> saveColor(Color color) {
    return _$saveColorAsyncAction.run(() => super.saveColor(color));
  }

  @override
  String toString() {
    return '''
isNightMode: ${isNightMode},
saunaSaverSleepModeType: ${saunaSaverSleepModeType},
saunaSaverSleepDuration: ${saunaSaverSleepDuration},
isSecuritySettingsEnabled: ${isSecuritySettingsEnabled},
isSaunaPairingEnabled: ${isSaunaPairingEnabled},
isWifiButtonEnabled: ${isWifiButtonEnabled},
isBluetoothButtonEnabled: ${isBluetoothButtonEnabled},
isSystemSoundOn: ${isSystemSoundOn},
isAllSoundOn: ${isAllSoundOn},
isSessionsSoundOn: ${isSessionsSoundOn},
temperatureScale: ${temperatureScale},
defaultConvention: ${defaultConvention},
currentSecurityPin: ${currentSecurityPin}
    ''';
  }
}
