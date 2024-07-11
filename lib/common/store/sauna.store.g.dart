// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sauna.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SaunaStore on _SaunaStoreBase, Store {
  Computed<bool>? _$shouldShowDebugMenuComputed;

  @override
  bool get shouldShowDebugMenu => (_$shouldShowDebugMenuComputed ??=
          Computed<bool>(() => super.shouldShowDebugMenu,
              name: '_SaunaStoreBase.shouldShowDebugMenu'))
      .value;
  Computed<List<SaunaBottomButton>>? _$settingMenusComputed;

  @override
  List<SaunaBottomButton> get settingMenus => (_$settingMenusComputed ??=
          Computed<List<SaunaBottomButton>>(() => super.settingMenus,
              name: '_SaunaStoreBase.settingMenus'))
      .value;
  Computed<String>? _$firmwareVersionComputed;

  @override
  String get firmwareVersion => (_$firmwareVersionComputed ??= Computed<String>(
          () => super.firmwareVersion,
          name: '_SaunaStoreBase.firmwareVersion'))
      .value;
  Computed<String>? _$timezoneComputed;

  @override
  String get timezone =>
      (_$timezoneComputed ??= Computed<String>(() => super.timezone,
              name: '_SaunaStoreBase.timezone'))
          .value;
  Computed<WifiState>? _$wifiStateComputed;

  @override
  WifiState get wifiState =>
      (_$wifiStateComputed ??= Computed<WifiState>(() => super.wifiState,
              name: '_SaunaStoreBase.wifiState'))
          .value;
  Computed<bool>? _$isWifiConnectedComputed;

  @override
  bool get isWifiConnected =>
      (_$isWifiConnectedComputed ??= Computed<bool>(() => super.isWifiConnected,
              name: '_SaunaStoreBase.isWifiConnected'))
          .value;
  Computed<NetworkMode>? _$networkModeComputed;

  @override
  NetworkMode get networkMode =>
      (_$networkModeComputed ??= Computed<NetworkMode>(() => super.networkMode,
              name: '_SaunaStoreBase.networkMode'))
          .value;
  Computed<EthernetStatus>? _$ethernetStatusComputed;

  @override
  EthernetStatus get ethernetStatus => (_$ethernetStatusComputed ??=
          Computed<EthernetStatus>(() => super.ethernetStatus,
              name: '_SaunaStoreBase.ethernetStatus'))
      .value;
  Computed<bool>? _$isActiveEthernetComputed;

  @override
  bool get isActiveEthernet => (_$isActiveEthernetComputed ??= Computed<bool>(
          () => super.isActiveEthernet,
          name: '_SaunaStoreBase.isActiveEthernet'))
      .value;
  Computed<bool>? _$isCloudConnectedComputed;

  @override
  bool get isCloudConnected => (_$isCloudConnectedComputed ??= Computed<bool>(
          () => super.isCloudConnected,
          name: '_SaunaStoreBase.isCloudConnected'))
      .value;
  Computed<int>? _$brightnessComputed;

  @override
  int get brightness =>
      (_$brightnessComputed ??= Computed<int>(() => super.brightness,
              name: '_SaunaStoreBase.brightness'))
          .value;
  Computed<int>? _$volumeComputed;

  @override
  int get volume => (_$volumeComputed ??=
          Computed<int>(() => super.volume, name: '_SaunaStoreBase.volume'))
      .value;
  Computed<int>? _$signalComputed;

  @override
  int get signal => (_$signalComputed ??=
          Computed<int>(() => super.signal, name: '_SaunaStoreBase.signal'))
      .value;
  Computed<bool>? _$ntpEnabledComputed;

  @override
  bool get ntpEnabled =>
      (_$ntpEnabledComputed ??= Computed<bool>(() => super.ntpEnabled,
              name: '_SaunaStoreBase.ntpEnabled'))
          .value;
  Computed<double>? _$targetTemperatureComputed;

  @override
  double get targetTemperature => (_$targetTemperatureComputed ??=
          Computed<double>(() => super.targetTemperature,
              name: '_SaunaStoreBase.targetTemperature'))
      .value;
  Computed<int>? _$remainingTimeComputed;

  @override
  int get remainingTime =>
      (_$remainingTimeComputed ??= Computed<int>(() => super.remainingTime,
              name: '_SaunaStoreBase.remainingTime'))
          .value;
  Computed<int>? _$currentAverageTemperatureComputed;

  @override
  int get currentAverageTemperature => (_$currentAverageTemperatureComputed ??=
          Computed<int>(() => super.currentAverageTemperature,
              name: '_SaunaStoreBase.currentAverageTemperature'))
      .value;
  Computed<int>? _$targetTimerComputed;

  @override
  int get targetTimer =>
      (_$targetTimerComputed ??= Computed<int>(() => super.targetTimer,
              name: '_SaunaStoreBase.targetTimer'))
          .value;
  Computed<String?>? _$saunaIdComputed;

  @override
  String? get saunaId =>
      (_$saunaIdComputed ??= Computed<String?>(() => super.saunaId,
              name: '_SaunaStoreBase.saunaId'))
          .value;
  Computed<Light?>? _$activeRgbLightComputed;

  @override
  Light? get activeRgbLight =>
      (_$activeRgbLightComputed ??= Computed<Light?>(() => super.activeRgbLight,
              name: '_SaunaStoreBase.activeRgbLight'))
          .value;
  Computed<Light?>? _$setRgbLightComputed;

  @override
  Light? get setRgbLight =>
      (_$setRgbLightComputed ??= Computed<Light?>(() => super.setRgbLight,
              name: '_SaunaStoreBase.setRgbLight'))
          .value;
  Computed<Light?>? _$activeMonoLightComputed;

  @override
  Light? get activeMonoLight => (_$activeMonoLightComputed ??= Computed<Light?>(
          () => super.activeMonoLight,
          name: '_SaunaStoreBase.activeMonoLight'))
      .value;
  Computed<List<SaunaSoundsType>?>? _$defaultSelectedAmbiencesComputed;

  @override
  List<SaunaSoundsType>? get defaultSelectedAmbiences =>
      (_$defaultSelectedAmbiencesComputed ??= Computed<List<SaunaSoundsType>?>(
              () => super.defaultSelectedAmbiences,
              name: '_SaunaStoreBase.defaultSelectedAmbiences'))
          .value;
  Computed<String>? _$wifiNameComputed;

  @override
  String get wifiName =>
      (_$wifiNameComputed ??= Computed<String>(() => super.wifiName,
              name: '_SaunaStoreBase.wifiName'))
          .value;
  Computed<bool>? _$isLightOnComputed;

  @override
  bool get isLightOn =>
      (_$isLightOnComputed ??= Computed<bool>(() => super.isLightOn,
              name: '_SaunaStoreBase.isLightOn'))
          .value;
  Computed<SaunaLightControlType>? _$saunaLightControlTypeComputed;

  @override
  SaunaLightControlType get saunaLightControlType =>
      (_$saunaLightControlTypeComputed ??= Computed<SaunaLightControlType>(
              () => super.saunaLightControlType,
              name: '_SaunaStoreBase.saunaLightControlType'))
          .value;
  Computed<bool>? _$programChangedIndicatorsAreEnabledComputed;

  @override
  bool get programChangedIndicatorsAreEnabled =>
      (_$programChangedIndicatorsAreEnabledComputed ??= Computed<bool>(
              () => super.programChangedIndicatorsAreEnabled,
              name: '_SaunaStoreBase.programChangedIndicatorsAreEnabled'))
          .value;
  Computed<List<TemperatureScale>>? _$supportedScalesComputed;

  @override
  List<TemperatureScale> get supportedScales => (_$supportedScalesComputed ??=
          Computed<List<TemperatureScale>>(() => super.supportedScales,
              name: '_SaunaStoreBase.supportedScales'))
      .value;
  Computed<List<TimeConvention>>? _$supportedConventionsComputed;

  @override
  List<TimeConvention> get supportedConventions =>
      (_$supportedConventionsComputed ??= Computed<List<TimeConvention>>(
              () => super.supportedConventions,
              name: '_SaunaStoreBase.supportedConventions'))
          .value;
  Computed<bool>? _$isTransitoryStateComputed;

  @override
  bool get isTransitoryState => (_$isTransitoryStateComputed ??= Computed<bool>(
          () => super.isTransitoryState,
          name: '_SaunaStoreBase.isTransitoryState'))
      .value;
  Computed<String?>? _$modelIdComputed;

  @override
  String? get modelId =>
      (_$modelIdComputed ??= Computed<String?>(() => super.modelId,
              name: '_SaunaStoreBase.modelId'))
          .value;
  Computed<String?>? _$deviceTokenComputed;

  @override
  String? get deviceToken =>
      (_$deviceTokenComputed ??= Computed<String?>(() => super.deviceToken,
              name: '_SaunaStoreBase.deviceToken'))
          .value;
  Computed<String>? _$panelImageComputed;

  @override
  String get panelImage =>
      (_$panelImageComputed ??= Computed<String>(() => super.panelImage,
              name: '_SaunaStoreBase.panelImage'))
          .value;
  Computed<String?>? _$pendingFirmwareVersionComputed;

  @override
  String? get pendingFirmwareVersion => (_$pendingFirmwareVersionComputed ??=
          Computed<String?>(() => super.pendingFirmwareVersion,
              name: '_SaunaStoreBase.pendingFirmwareVersion'))
      .value;
  Computed<List<String>>? _$pendingUpdateReleaseNotesComputed;

  @override
  List<String> get pendingUpdateReleaseNotes =>
      (_$pendingUpdateReleaseNotesComputed ??= Computed<List<String>>(
              () => super.pendingUpdateReleaseNotes,
              name: '_SaunaStoreBase.pendingUpdateReleaseNotes'))
          .value;
  Computed<SaunaUpdateState?>? _$saunaUpdateStateComputed;

  @override
  SaunaUpdateState? get saunaUpdateState => (_$saunaUpdateStateComputed ??=
          Computed<SaunaUpdateState?>(() => super.saunaUpdateState,
              name: '_SaunaStoreBase.saunaUpdateState'))
      .value;
  Computed<List<MediaPlayer>>? _$mediaPlayersComputed;

  @override
  List<MediaPlayer> get mediaPlayers => (_$mediaPlayersComputed ??=
          Computed<List<MediaPlayer>>(() => super.mediaPlayers,
              name: '_SaunaStoreBase.mediaPlayers'))
      .value;
  Computed<bool>? _$showFirmwareUpdateInfoComputed;

  @override
  bool get showFirmwareUpdateInfo => (_$showFirmwareUpdateInfoComputed ??=
          Computed<bool>(() => super.showFirmwareUpdateInfo,
              name: '_SaunaStoreBase.showFirmwareUpdateInfo'))
      .value;
  Computed<bool>? _$showFirmwareUpdateDialogComputed;

  @override
  bool get showFirmwareUpdateDialog => (_$showFirmwareUpdateDialogComputed ??=
          Computed<bool>(() => super.showFirmwareUpdateDialog,
              name: '_SaunaStoreBase.showFirmwareUpdateDialog'))
      .value;
  Computed<bool>? _$showForceUpdateDialogComputed;

  @override
  bool get showForceUpdateDialog => (_$showForceUpdateDialogComputed ??=
          Computed<bool>(() => super.showForceUpdateDialog,
              name: '_SaunaStoreBase.showForceUpdateDialog'))
      .value;
  Computed<String?>? _$saunaEntityNameComputed;

  @override
  String? get saunaEntityName => (_$saunaEntityNameComputed ??=
          Computed<String?>(() => super.saunaEntityName,
              name: '_SaunaStoreBase.saunaEntityName'))
      .value;

  late final _$_saunaStatusAtom =
      Atom(name: '_SaunaStoreBase._saunaStatus', context: context);

  SaunaStatus? get saunaStatus {
    _$_saunaStatusAtom.reportRead();
    return super._saunaStatus;
  }

  @override
  SaunaStatus? get _saunaStatus => saunaStatus;

  @override
  set _saunaStatus(SaunaStatus? value) {
    _$_saunaStatusAtom.reportWrite(value, super._saunaStatus, () {
      super._saunaStatus = value;
    });
  }

  late final _$_saunaSystemAtom =
      Atom(name: '_SaunaStoreBase._saunaSystem', context: context);

  SaunaSystem? get saunaSystem {
    _$_saunaSystemAtom.reportRead();
    return super._saunaSystem;
  }

  @override
  SaunaSystem? get _saunaSystem => saunaSystem;

  @override
  set _saunaSystem(SaunaSystem? value) {
    _$_saunaSystemAtom.reportWrite(value, super._saunaSystem, () {
      super._saunaSystem = value;
    });
  }

  late final _$_saunaIdentityAtom =
      Atom(name: '_SaunaStoreBase._saunaIdentity', context: context);

  SaunaIdentity? get saunaIdentity {
    _$_saunaIdentityAtom.reportRead();
    return super._saunaIdentity;
  }

  @override
  SaunaIdentity? get _saunaIdentity => saunaIdentity;

  @override
  set _saunaIdentity(SaunaIdentity? value) {
    _$_saunaIdentityAtom.reportWrite(value, super._saunaIdentity, () {
      super._saunaIdentity = value;
    });
  }

  late final _$_saunaStateAtom =
      Atom(name: '_SaunaStoreBase._saunaState', context: context);

  SaunaState get saunaState {
    _$_saunaStateAtom.reportRead();
    return super._saunaState;
  }

  @override
  SaunaState get _saunaState => saunaState;

  @override
  set _saunaState(SaunaState value) {
    _$_saunaStateAtom.reportWrite(value, super._saunaState, () {
      super._saunaState = value;
    });
  }

  late final _$_currentHostAPIAtom =
      Atom(name: '_SaunaStoreBase._currentHostAPI', context: context);

  String get currentHostAPI {
    _$_currentHostAPIAtom.reportRead();
    return super._currentHostAPI;
  }

  @override
  String get _currentHostAPI => currentHostAPI;

  @override
  set _currentHostAPI(String value) {
    _$_currentHostAPIAtom.reportWrite(value, super._currentHostAPI, () {
      super._currentHostAPI = value;
    });
  }

  late final _$selectedSaunaMenuTypeAtom =
      Atom(name: '_SaunaStoreBase.selectedSaunaMenuType', context: context);

  @override
  SaunaMenuType get selectedSaunaMenuType {
    _$selectedSaunaMenuTypeAtom.reportRead();
    return super.selectedSaunaMenuType;
  }

  @override
  set selectedSaunaMenuType(SaunaMenuType value) {
    _$selectedSaunaMenuTypeAtom.reportWrite(value, super.selectedSaunaMenuType,
        () {
      super.selectedSaunaMenuType = value;
    });
  }

  late final _$prevSelectedSaunaMenuTypeAtom =
      Atom(name: '_SaunaStoreBase.prevSelectedSaunaMenuType', context: context);

  @override
  SaunaMenuType get prevSelectedSaunaMenuType {
    _$prevSelectedSaunaMenuTypeAtom.reportRead();
    return super.prevSelectedSaunaMenuType;
  }

  @override
  set prevSelectedSaunaMenuType(SaunaMenuType value) {
    _$prevSelectedSaunaMenuTypeAtom
        .reportWrite(value, super.prevSelectedSaunaMenuType, () {
      super.prevSelectedSaunaMenuType = value;
    });
  }

  late final _$_saunaTimeSettingTypeAtom =
      Atom(name: '_SaunaStoreBase._saunaTimeSettingType', context: context);

  SaunaTimeSettingType get saunaTimeSettingType {
    _$_saunaTimeSettingTypeAtom.reportRead();
    return super._saunaTimeSettingType;
  }

  @override
  SaunaTimeSettingType get _saunaTimeSettingType => saunaTimeSettingType;

  @override
  set _saunaTimeSettingType(SaunaTimeSettingType value) {
    _$_saunaTimeSettingTypeAtom.reportWrite(value, super._saunaTimeSettingType,
        () {
      super._saunaTimeSettingType = value;
    });
  }

  late final _$_selectedProgramAtom =
      Atom(name: '_SaunaStoreBase._selectedProgram', context: context);

  Program? get selectedProgram {
    _$_selectedProgramAtom.reportRead();
    return super._selectedProgram;
  }

  @override
  Program? get _selectedProgram => selectedProgram;

  @override
  set _selectedProgram(Program? value) {
    _$_selectedProgramAtom.reportWrite(value, super._selectedProgram, () {
      super._selectedProgram = value;
    });
  }

  late final _$_currentDateTimeAtom =
      Atom(name: '_SaunaStoreBase._currentDateTime', context: context);

  DateTime? get currentDateTime {
    _$_currentDateTimeAtom.reportRead();
    return super._currentDateTime;
  }

  @override
  DateTime? get _currentDateTime => currentDateTime;

  @override
  set _currentDateTime(DateTime? value) {
    _$_currentDateTimeAtom.reportWrite(value, super._currentDateTime, () {
      super._currentDateTime = value;
    });
  }

  late final _$_shouldReloadPropertiesAtom =
      Atom(name: '_SaunaStoreBase._shouldReloadProperties', context: context);

  bool get shouldReloadProperties {
    _$_shouldReloadPropertiesAtom.reportRead();
    return super._shouldReloadProperties;
  }

  @override
  bool get _shouldReloadProperties => shouldReloadProperties;

  @override
  set _shouldReloadProperties(bool value) {
    _$_shouldReloadPropertiesAtom
        .reportWrite(value, super._shouldReloadProperties, () {
      super._shouldReloadProperties = value;
    });
  }

  late final _$_popupTypeAtom =
      Atom(name: '_SaunaStoreBase._popupType', context: context);

  PopupType get popupType {
    _$_popupTypeAtom.reportRead();
    return super._popupType;
  }

  @override
  PopupType get _popupType => popupType;

  @override
  set _popupType(PopupType value) {
    _$_popupTypeAtom.reportWrite(value, super._popupType, () {
      super._popupType = value;
    });
  }

  late final _$_audioVolumeAtom =
      Atom(name: '_SaunaStoreBase._audioVolume', context: context);

  double? get audioVolume {
    _$_audioVolumeAtom.reportRead();
    return super._audioVolume;
  }

  @override
  double? get _audioVolume => audioVolume;

  @override
  set _audioVolume(double? value) {
    _$_audioVolumeAtom.reportWrite(value, super._audioVolume, () {
      super._audioVolume = value;
    });
  }

  late final _$_isLoadingAtom =
      Atom(name: '_SaunaStoreBase._isLoading', context: context);

  bool get isLoading {
    _$_isLoadingAtom.reportRead();
    return super._isLoading;
  }

  @override
  bool get _isLoading => isLoading;

  @override
  set _isLoading(bool value) {
    _$_isLoadingAtom.reportWrite(value, super._isLoading, () {
      super._isLoading = value;
    });
  }

  late final _$_isFactoryResetAtom =
      Atom(name: '_SaunaStoreBase._isFactoryReset', context: context);

  bool? get isFactoryReset {
    _$_isFactoryResetAtom.reportRead();
    return super._isFactoryReset;
  }

  @override
  bool? get _isFactoryReset => isFactoryReset;

  @override
  set _isFactoryReset(bool? value) {
    _$_isFactoryResetAtom.reportWrite(value, super._isFactoryReset, () {
      super._isFactoryReset = value;
    });
  }

  late final _$_saunaPropertiesAtom =
      Atom(name: '_SaunaStoreBase._saunaProperties', context: context);

  SaunaProperties? get saunaProperties {
    _$_saunaPropertiesAtom.reportRead();
    return super._saunaProperties;
  }

  @override
  SaunaProperties? get _saunaProperties => saunaProperties;

  @override
  set _saunaProperties(SaunaProperties? value) {
    _$_saunaPropertiesAtom.reportWrite(value, super._saunaProperties, () {
      super._saunaProperties = value;
    });
  }

  late final _$_isSaunaUpdateLoadingAtom =
      Atom(name: '_SaunaStoreBase._isSaunaUpdateLoading', context: context);

  bool get isSaunaUpdateLoading {
    _$_isSaunaUpdateLoadingAtom.reportRead();
    return super._isSaunaUpdateLoading;
  }

  @override
  bool get _isSaunaUpdateLoading => isSaunaUpdateLoading;

  @override
  set _isSaunaUpdateLoading(bool value) {
    _$_isSaunaUpdateLoadingAtom.reportWrite(value, super._isSaunaUpdateLoading,
        () {
      super._isSaunaUpdateLoading = value;
    });
  }

  late final _$_ambienceMediaPlayerPosAtom =
      Atom(name: '_SaunaStoreBase._ambienceMediaPlayerPos', context: context);

  List<int> get ambienceMediaPlayerPos {
    _$_ambienceMediaPlayerPosAtom.reportRead();
    return super._ambienceMediaPlayerPos;
  }

  @override
  List<int> get _ambienceMediaPlayerPos => ambienceMediaPlayerPos;

  @override
  set _ambienceMediaPlayerPos(List<int> value) {
    _$_ambienceMediaPlayerPosAtom
        .reportWrite(value, super._ambienceMediaPlayerPos, () {
      super._ambienceMediaPlayerPos = value;
    });
  }

  late final _$_isRemindMeLaterForUpdateTappedAtom = Atom(
      name: '_SaunaStoreBase._isRemindMeLaterForUpdateTapped',
      context: context);

  bool get isRemindMeLaterForUpdateTapped {
    _$_isRemindMeLaterForUpdateTappedAtom.reportRead();
    return super._isRemindMeLaterForUpdateTapped;
  }

  @override
  bool get _isRemindMeLaterForUpdateTapped => isRemindMeLaterForUpdateTapped;

  @override
  set _isRemindMeLaterForUpdateTapped(bool value) {
    _$_isRemindMeLaterForUpdateTappedAtom
        .reportWrite(value, super._isRemindMeLaterForUpdateTapped, () {
      super._isRemindMeLaterForUpdateTapped = value;
    });
  }

  late final _$_isUpdateAfterSessionTappedAtom = Atom(
      name: '_SaunaStoreBase._isUpdateAfterSessionTapped', context: context);

  bool get isUpdateAfterSessionTapped {
    _$_isUpdateAfterSessionTappedAtom.reportRead();
    return super._isUpdateAfterSessionTapped;
  }

  @override
  bool get _isUpdateAfterSessionTapped => isUpdateAfterSessionTapped;

  @override
  set _isUpdateAfterSessionTapped(bool value) {
    _$_isUpdateAfterSessionTappedAtom
        .reportWrite(value, super._isUpdateAfterSessionTapped, () {
      super._isUpdateAfterSessionTapped = value;
    });
  }

  late final _$_fetchSaunaIdentityAsyncAction =
      AsyncAction('_SaunaStoreBase._fetchSaunaIdentity', context: context);

  @override
  Future<void> _fetchSaunaIdentity() {
    return _$_fetchSaunaIdentityAsyncAction
        .run(() => super._fetchSaunaIdentity());
  }

  late final _$_fetchSaunaStatusAsyncAction =
      AsyncAction('_SaunaStoreBase._fetchSaunaStatus', context: context);

  @override
  Future<void> _fetchSaunaStatus() {
    return _$_fetchSaunaStatusAsyncAction.run(() => super._fetchSaunaStatus());
  }

  late final _$_fetchSaunaSystemAsyncAction =
      AsyncAction('_SaunaStoreBase._fetchSaunaSystem', context: context);

  @override
  Future<void> _fetchSaunaSystem() {
    return _$_fetchSaunaSystemAsyncAction.run(() => super._fetchSaunaSystem());
  }

  late final _$updateTargetTimeAsyncAction =
      AsyncAction('_SaunaStoreBase.updateTargetTime', context: context);

  @override
  Future<void> updateTargetTime(
      {required int targetTime, bool convertToSecond = true}) {
    return _$updateTargetTimeAsyncAction.run(() => super.updateTargetTime(
        targetTime: targetTime, convertToSecond: convertToSecond));
  }

  late final _$updateTargetTemperatureAsyncAction =
      AsyncAction('_SaunaStoreBase.updateTargetTemperature', context: context);

  @override
  Future<void> updateTargetTemperature({required double targetTemperature}) {
    return _$updateTargetTemperatureAsyncAction.run(() =>
        super.updateTargetTemperature(targetTemperature: targetTemperature));
  }

  late final _$updateSaunaLightAsyncAction =
      AsyncAction('_SaunaStoreBase.updateSaunaLight', context: context);

  @override
  Future<void> updateSaunaLight(
      {required ColorRGB colorRGB,
      required bool state,
      required double brightness}) {
    return _$updateSaunaLightAsyncAction.run(() => super.updateSaunaLight(
        colorRGB: colorRGB, state: state, brightness: brightness));
  }

  late final _$updateSaunaMonoStateAsyncAction =
      AsyncAction('_SaunaStoreBase.updateSaunaMonoState', context: context);

  @override
  Future<void> updateSaunaMonoState({required bool state}) {
    return _$updateSaunaMonoStateAsyncAction
        .run(() => super.updateSaunaMonoState(state: state));
  }

  late final _$setSaunaStateAsyncAction =
      AsyncAction('_SaunaStoreBase.setSaunaState', context: context);

  @override
  Future<void> setSaunaState(SaunaState state) {
    return _$setSaunaStateAsyncAction.run(() => super.setSaunaState(state));
  }

  late final _$setSaunaSystemVolumeAsyncAction =
      AsyncAction('_SaunaStoreBase.setSaunaSystemVolume', context: context);

  @override
  Future<void> setSaunaSystemVolume(int volume) {
    return _$setSaunaSystemVolumeAsyncAction
        .run(() => super.setSaunaSystemVolume(volume));
  }

  late final _$setTimeSaunaSystemAsyncAction =
      AsyncAction('_SaunaStoreBase.setTimeSaunaSystem', context: context);

  @override
  Future<void> setTimeSaunaSystem(
      {bool? isNtpEnabled, String? localTime, String? timezone}) {
    return _$setTimeSaunaSystemAsyncAction.run(() => super.setTimeSaunaSystem(
        isNtpEnabled: isNtpEnabled, localTime: localTime, timezone: timezone));
  }

  late final _$setSaunaSystemBrightnessAsyncAction =
      AsyncAction('_SaunaStoreBase.setSaunaSystemBrightness', context: context);

  @override
  Future<void> setSaunaSystemBrightness(int brightness) {
    return _$setSaunaSystemBrightnessAsyncAction
        .run(() => super.setSaunaSystemBrightness(brightness));
  }

  late final _$setSelectedProgramAsyncAction =
      AsyncAction('_SaunaStoreBase.setSelectedProgram', context: context);

  @override
  Future<void> setSelectedProgram(Program selectedProgram,
      {String? customName}) {
    return _$setSelectedProgramAsyncAction.run(() =>
        super.setSelectedProgram(selectedProgram, customName: customName));
  }

  late final _$saveModifiedProgramAsyncAction =
      AsyncAction('_SaunaStoreBase.saveModifiedProgram', context: context);

  @override
  Future<void> saveModifiedProgram() {
    return _$saveModifiedProgramAsyncAction
        .run(() => super.saveModifiedProgram());
  }

  late final _$setSelectedMenuTypeAsyncAction =
      AsyncAction('_SaunaStoreBase.setSelectedMenuType', context: context);

  @override
  Future<void> setSelectedMenuType(SaunaMenuType type) {
    return _$setSelectedMenuTypeAsyncAction
        .run(() => super.setSelectedMenuType(type));
  }

  late final _$resetModifiedProgramAsyncAction =
      AsyncAction('_SaunaStoreBase.resetModifiedProgram', context: context);

  @override
  Future<void> resetModifiedProgram() {
    return _$resetModifiedProgramAsyncAction
        .run(() => super.resetModifiedProgram());
  }

  late final _$factoryResetAsyncAction =
      AsyncAction('_SaunaStoreBase.factoryReset', context: context);

  @override
  Future<void> factoryReset() {
    return _$factoryResetAsyncAction.run(() => super.factoryReset());
  }

  late final _$saunaRestartAsyncAction =
      AsyncAction('_SaunaStoreBase.saunaRestart', context: context);

  @override
  Future<void> saunaRestart() {
    return _$saunaRestartAsyncAction.run(() => super.saunaRestart());
  }

  late final _$saunaUpdateAsyncAction =
      AsyncAction('_SaunaStoreBase.saunaUpdate', context: context);

  @override
  Future<void> saunaUpdate() {
    return _$saunaUpdateAsyncAction.run(() => super.saunaUpdate());
  }

  late final _$_checkIfProfileIsUpdatedAsyncAction =
      AsyncAction('_SaunaStoreBase._checkIfProfileIsUpdated', context: context);

  @override
  Future<void> _checkIfProfileIsUpdated() {
    return _$_checkIfProfileIsUpdatedAsyncAction
        .run(() => super._checkIfProfileIsUpdated());
  }

  late final _$_SaunaStoreBaseActionController =
      ActionController(name: '_SaunaStoreBase', context: context);

  @override
  void updateSaunaStatus(SaunaStatus? status) {
    final _$actionInfo = _$_SaunaStoreBaseActionController.startAction(
        name: '_SaunaStoreBase.updateSaunaStatus');
    try {
      return super.updateSaunaStatus(status);
    } finally {
      _$_SaunaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsFactoryReset(bool? value) {
    final _$actionInfo = _$_SaunaStoreBaseActionController.startAction(
        name: '_SaunaStoreBase.setIsFactoryReset');
    try {
      return super.setIsFactoryReset(value);
    } finally {
      _$_SaunaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPopupType({required PopupType type}) {
    final _$actionInfo = _$_SaunaStoreBaseActionController.startAction(
        name: '_SaunaStoreBase.setPopupType');
    try {
      return super.setPopupType(type: type);
    } finally {
      _$_SaunaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSaunaTimeSettingType({required SaunaTimeSettingType type}) {
    final _$actionInfo = _$_SaunaStoreBaseActionController.startAction(
        name: '_SaunaStoreBase.setSaunaTimeSettingType');
    try {
      return super.setSaunaTimeSettingType(type: type);
    } finally {
      _$_SaunaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAudioVolume({required double volume}) {
    final _$actionInfo = _$_SaunaStoreBaseActionController.startAction(
        name: '_SaunaStoreBase.setAudioVolume');
    try {
      return super.setAudioVolume(volume: volume);
    } finally {
      _$_SaunaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRemindMeLaterForUpdateTapped(bool isTapped) {
    final _$actionInfo = _$_SaunaStoreBaseActionController.startAction(
        name: '_SaunaStoreBase.setRemindMeLaterForUpdateTapped');
    try {
      return super.setRemindMeLaterForUpdateTapped(isTapped);
    } finally {
      _$_SaunaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUpdateAfterSessionTapped(bool isTapped) {
    final _$actionInfo = _$_SaunaStoreBaseActionController.startAction(
        name: '_SaunaStoreBase.setUpdateAfterSessionTapped');
    try {
      return super.setUpdateAfterSessionTapped(isTapped);
    } finally {
      _$_SaunaStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedSaunaMenuType: ${selectedSaunaMenuType},
prevSelectedSaunaMenuType: ${prevSelectedSaunaMenuType},
shouldShowDebugMenu: ${shouldShowDebugMenu},
settingMenus: ${settingMenus},
firmwareVersion: ${firmwareVersion},
timezone: ${timezone},
wifiState: ${wifiState},
isWifiConnected: ${isWifiConnected},
networkMode: ${networkMode},
ethernetStatus: ${ethernetStatus},
isActiveEthernet: ${isActiveEthernet},
isCloudConnected: ${isCloudConnected},
brightness: ${brightness},
volume: ${volume},
signal: ${signal},
ntpEnabled: ${ntpEnabled},
targetTemperature: ${targetTemperature},
remainingTime: ${remainingTime},
currentAverageTemperature: ${currentAverageTemperature},
targetTimer: ${targetTimer},
saunaId: ${saunaId},
activeRgbLight: ${activeRgbLight},
setRgbLight: ${setRgbLight},
activeMonoLight: ${activeMonoLight},
defaultSelectedAmbiences: ${defaultSelectedAmbiences},
wifiName: ${wifiName},
isLightOn: ${isLightOn},
saunaLightControlType: ${saunaLightControlType},
programChangedIndicatorsAreEnabled: ${programChangedIndicatorsAreEnabled},
supportedScales: ${supportedScales},
supportedConventions: ${supportedConventions},
isTransitoryState: ${isTransitoryState},
modelId: ${modelId},
deviceToken: ${deviceToken},
panelImage: ${panelImage},
pendingFirmwareVersion: ${pendingFirmwareVersion},
pendingUpdateReleaseNotes: ${pendingUpdateReleaseNotes},
saunaUpdateState: ${saunaUpdateState},
mediaPlayers: ${mediaPlayers},
showFirmwareUpdateInfo: ${showFirmwareUpdateInfo},
showFirmwareUpdateDialog: ${showFirmwareUpdateDialog},
showForceUpdateDialog: ${showForceUpdateDialog},
saunaEntityName: ${saunaEntityName}
    ''';
  }
}
