import 'package:found_space_flutter_rest_api/found_space_flutter_rest_api.dart';
import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:found_space_flutter_web_application/app_startup/app_flavor.dart';
import 'package:found_space_flutter_web_application/app_startup/environment_config.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/found_space_constants.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/light_extension.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/program_extension.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/sauna_properties_extension.dart';
import 'package:found_space_flutter_web_application/common/store/audio_player.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/di/app_component_interface.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/store/sauna_program_page.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_menu_button.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_page_common.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/sauna_status_extension.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/sauna_system_extension.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/utils/sauna_audio_control_utils.dart';
import 'package:logger/logger.dart';
import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'dart:async';

import 'package:found_space_flutter_web_application/common/mobx_provider.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:tuple/tuple.dart';

part 'sauna.store.g.dart';

class SaunaStore = _SaunaStoreBase with _$SaunaStore;

abstract class _SaunaStoreBase with Store, Disposable {
  final _restAPIRepository = locator<RestAPIRepository>();
  final _appConfigBase = locator<AppConfigBase>();
  String? _currentPropertiesId;

  final _logger = locator<Logger>();

  @readonly
  SaunaStatus? _saunaStatus;

  @readonly
  SaunaSystem? _saunaSystem;

  List<SaunaBottomButton> homePageMenu = [
    SaunaBottomButton.temperature,
    SaunaBottomButton.programTime,
    SaunaBottomButton.light,
    SaunaBottomButton.audio
  ];

  List<SaunaBottomButton> defaultSettingMenus = [
    SaunaBottomButton.saverAndSleepMode,
    SaunaBottomButton.colorTheme,
    SaunaBottomButton.advancedSettings,
    SaunaBottomButton.debug
  ];

  @computed
  bool get shouldShowDebugMenu => EnvironmentConfig.flavor == AppFlavor.black;

  @computed
  List<SaunaBottomButton> get settingMenus {
    return shouldShowDebugMenu
        ? defaultSettingMenus
        : defaultSettingMenus.where((element) => element != SaunaBottomButton.debug).toList();
  }

  @computed
  String get firmwareVersion => _saunaSystem?.firmwareVersionCode ?? '';

  @computed
  String get timezone => _saunaSystem?.timezone ?? '';

  @computed
  WifiState get wifiState => _saunaSystem?.network?.wifi?.state ?? WifiState.inactive;

  @computed
  bool get isWifiConnected => wifiState == WifiState.active && networkMode == NetworkMode.wifi;

  @computed
  NetworkMode get networkMode => _saunaSystem?.network?.mode ?? NetworkMode.none;

  @computed
  EthernetStatus get ethernetStatus => _saunaSystem?.network?.ethernet?.status ?? EthernetStatus.down;

  @computed
  bool get isActiveEthernet => ethernetStatus == EthernetStatus.up && networkMode == NetworkMode.ethernet;

  @computed
  bool get isCloudConnected => _saunaSystem?.isCloudConnected ?? false;

  @computed
  int get brightness => _saunaSystem?.brightness ?? 10;

  @computed
  int get volume => _saunaSystem?.saunaVolume ?? 0;

  @computed
  int get signal => _saunaSystem?.network?.wifi?.signal ?? 0;

  @computed
  bool get ntpEnabled => _saunaSystem?.ntpEnabled ?? false;

  @computed
  double get targetTemperature => _saunaStatus?.temperature ?? 0;

  @computed
  int get remainingTime => _saunaStatus?.remainingTime ?? 0;

  @computed
  int get currentAverageTemperature => _saunaStatus?.currentAverageTemperature ?? 0;

  @computed
  int get targetTimer => _saunaStatus?.targetProgramTime ?? 0;

  @readonly
  SaunaIdentity? _saunaIdentity;

  @computed
  String? get saunaId => _saunaIdentity?.id;

  @readonly
  SaunaState _saunaState = SaunaState.standby;

  @readonly
  String _currentHostAPI = '';

  @observable
  SaunaMenuType selectedSaunaMenuType = SaunaMenuType.saunaControl;

  @observable
  SaunaMenuType prevSelectedSaunaMenuType = SaunaMenuType.saunaControl;

  @readonly
  SaunaTimeSettingType _saunaTimeSettingType = SaunaTimeSettingType.system;

  @readonly
  Program? _selectedProgram;

  @readonly
  DateTime? _currentDateTime;

  @computed
  Light? get activeRgbLight => _saunaStatus?.currentActiveRGBLight;

  @computed
  Light? get setRgbLight => _saunaStatus?.currentSetRGBLight;

  @computed
  Light? get activeMonoLight => _saunaStatus?.currentActiveMonoLight;

  @computed
  List<SaunaSoundsType>? get defaultSelectedAmbiences => _saunaStatus?.setAmbientSounds;

  @computed
  String get wifiName => _saunaSystem?.network?.wifi?.ssid ?? '';

  @readonly
  bool _shouldReloadProperties = false;

  @computed
  bool get isLightOn {
    final lights = _saunaStatus?.activeLights ?? [];
    final onLight = lights.firstWhereOrNull((element) => element.state == true);
    return onLight != null;
  }

  @computed
  SaunaLightControlType get saunaLightControlType {
    bool hasRgbLight = activeRgbLight != null;
    bool hasMonoLight = activeMonoLight != null;

    if (hasRgbLight && hasMonoLight) {
      return SaunaLightControlType.both;
    } else if (hasRgbLight) {
      return SaunaLightControlType.rgb;
    } else if (hasMonoLight) {
      return SaunaLightControlType.mono;
    }
    return SaunaLightControlType.none;
  }

  @computed
  bool get programChangedIndicatorsAreEnabled {
    final activeProgram = _saunaStatus?.program?.active;
    final setProgram = _saunaStatus?.program?.set;
    if (activeProgram == null || setProgram == null) return false;
    if (activeProgram != setProgram) return true;

    return false;
  }

  @readonly
  PopupType _popupType = PopupType.none;

  bool isResettingProgram = false;

  @computed
  List<TemperatureScale> get supportedScales =>
      _saunaProperties?.supportedTemperatureScales ?? [TemperatureScale.celsius, TemperatureScale.fahrenheit];

  @computed
  List<TimeConvention> get supportedConventions =>
      _saunaProperties?.supportedConventions ?? [TimeConvention.twelve, TimeConvention.twentyFour];

  @readonly
  double? _audioVolume;

  @computed
  bool get isTransitoryState {
    final isHeatingState = _saunaState == SaunaState.heating;
    if (!isHeatingState) return false;

    final activeLights = _saunaStatus?.program?.active?.lights ?? [];
    final lights = _saunaStatus?.lights ?? [];

    for (final activeLight in activeLights) {
      final hasMismatch =
          lights.firstWhereOrNull((light) => light.state != activeLight.state && light.id == activeLight.id);
      if (hasMismatch != null) return true;
    }

    return false;
  }

  @readonly
  bool _isLoading = false;

  @readonly
  bool? _isFactoryReset;

  @computed
  String? get modelId => _saunaStatus?.modelId ?? '';

  @readonly
  SaunaProperties? _saunaProperties;

  @computed
  String? get deviceToken {
    final adminToken = _saunaIdentity?.adminToken;
    if (adminToken != null && adminToken.isNotEmpty) {
      return 'Device $adminToken';
    } else {
      return null;
    }
  }

  @computed
  String get panelImage {
    final models = _saunaProperties?.models ?? {};
    if (modelId != null && models.containsKey(modelId)) {
      final saunaModelInfo = models[modelId];
      final imagePanel = saunaModelInfo?.images?.panel;

      if (imagePanel != null && imagePanel.isNotEmpty) return _currentHostAPI + imagePanel;
    }
    return '';
  }

  @computed
  String? get pendingFirmwareVersion => _saunaSystem?.pendingFirmwareVersion;

  @computed
  List<String> get pendingUpdateReleaseNotes => _saunaSystem?.pendingUpdateReleaseNotes ?? [];

  @computed
  SaunaUpdateState? get saunaUpdateState => _saunaSystem?.saunaUpdateState;

  @readonly
  bool _isSaunaUpdateLoading = false;

  @readonly
  List<int> _ambienceMediaPlayerPos = [];

  @computed
  List<MediaPlayer> get mediaPlayers => _saunaSystem?.mediaPlayer ?? [];

  @computed
  bool get showFirmwareUpdateInfo => _isUpdateAfterSessionTapped;

  @computed
  bool get showFirmwareUpdateDialog =>
      _isRemindMeLaterForUpdateTapped &&
      _saunaSystem?.isForceUpdate == false &&
      _saunaState != SaunaState.standby &&
      selectedSaunaMenuType == SaunaMenuType.saunaControl &&
      (saunaUpdateState == SaunaUpdateState.standby || saunaUpdateState == SaunaUpdateState.failed);

  @computed
  bool get showForceUpdateDialog =>
      _saunaSystem?.isForceUpdate == true &&
      selectedSaunaMenuType == SaunaMenuType.saunaControl &&
      (saunaUpdateState == SaunaUpdateState.standby || saunaUpdateState == SaunaUpdateState.failed);

  @readonly
  bool _isRemindMeLaterForUpdateTapped = true;

  @readonly
  bool _isUpdateAfterSessionTapped = false;

  @computed
  String? get saunaEntityName => _saunaProperties?.entity?.name;

  final _compositeReaction = CompositeReactionDisposer();

  _SaunaStoreBase() {
    _setupRestAPIFlavor();
    _fetchSaunaIdentity();
  }

  void _setupRestAPIFlavor() {
    final isReleaseBuild = AppComponentBase.isReleaseBuild;
    Logger().i(isReleaseBuild);
    switch (isReleaseBuild) {
      case true:
        _appConfigBase.currentRestAPIEnvironment = RestAPIEnvironment.production;
        break;
      case false:
        _appConfigBase.currentRestAPIEnvironment = RestAPIEnvironment.mockData;
        break;
    }
    _currentHostAPI = _appConfigBase.hostURL;
  }

  void _setToken() {
    final deviceToken = _saunaIdentity?.adminToken;
    assert(deviceToken != null, 'token cannot be null');
    if (deviceToken == null) return;
    _appConfigBase.setTokens(deviceToken: deviceToken);
  }

  @action
  Future<void> _fetchSaunaIdentity() async {
    try {
      _saunaIdentity = null;
      _saunaIdentity = await _restAPIRepository.fetchSaunaIdentity();
      _setToken();
      await _fetchSaunaSystem();
      await _fetchSystemProperties();
      await locator<AudioPlayerStore>().setupAudioPlayers();
      await _fetchSaunaStatus();
      await locator<SaunaLocalStorageStore>().fetchLocalConfigs();
      await locator<SaunaProgramPageStore>().fetchSuggestedPrograms();
    } catch (error, stackTrace) {
      _saunaIdentity = null;
      locator<AudioPlayerStore>().setBootUpFinished();
      // We will call identity API again until we get the response.
      _fetchSaunaIdentity();
      _logger.e('Error loading _fetchSaunaIdentity', error, stackTrace);
    }
  }

  @action
  Future<void> _fetchSaunaStatus() async {
    try {
      final credentials = fetchCredentials;
      if (credentials == null) return;

      final result = await _restAPIRepository.fetchSaunaStatus(
        saunaId: credentials.item2,
      );
      if (result != _saunaStatus) {
        updateSaunaStatus(result);
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading fetchPodcasts', error, stackTrace);
    }
    await Future.delayed(const Duration(seconds: 3));
    _fetchSaunaStatus();
  }

  @action
  Future<void> _fetchSaunaSystem() async {
    try {
      final credentials = fetchCredentials;
      if (credentials == null) return;

      final result = await _restAPIRepository.fetchSaunaSystem(saunaId: credentials.item2);
      if (_saunaSystem != result) {
        _saunaSystem = result;

        /// TODO: Remove this line and refine it later
        _audioVolume ??= _saunaSystem?.volume?.toDouble() ?? 50.0;

        _setCurrentDateAndTime();

        if (!_areArraysEqual(_ambienceMediaPlayerPos, _ambienceMediaPlayerPosition)) {
          _ambienceMediaPlayerPos = _ambienceMediaPlayerPosition;
        }

        _checkIfProfileIsUpdated();
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading _fetchSaunaSystem', error, stackTrace);
    }

    await Future.delayed(const Duration(seconds: 3));
    _fetchSaunaSystem();
  }

  Future<void> _fetchSystemProperties() async {
    try {
      final credentials = fetchCredentials;
      if (credentials == null) return;

      final result = await _restAPIRepository.fetchSystemProperties(saunaId: credentials.item2);
      if (result != null) {
        _saunaProperties = result;
        _currentPropertiesId = _saunaProperties?.id;
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading fetchSystemProperties', error, stackTrace);
    }
  }

  @action
  Future<void> updateTargetTime({required int targetTime, bool convertToSecond = true}) async {
    try {
      final credentials = fetchCredentials;
      if (credentials == null) return;

      final result = await _restAPIRepository.setSaunaTimer(
          targetTimer: convertToSecond ? targetTime * 60 : targetTime, saunaId: credentials.item2);
      if (result != null) {
        _saunaStatus = result;
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading updateTargetTime', error, stackTrace);
    }
  }

  @action
  Future<void> updateTargetTemperature({required double targetTemperature}) async {
    try {
      final credentials = fetchCredentials;
      if (credentials == null) return;

      final result = await _restAPIRepository.setSaunaTemperature(
          targetTemperature: targetTemperature, saunaId: credentials.item2);
      if (result != null) {
        updateSaunaStatus(result);
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading updateTargetTemperature', error, stackTrace);
    }
  }

  @action
  Future<void> updateSaunaLight({required ColorRGB colorRGB, required bool state, required double brightness}) async {
    try {
      final credentials = fetchCredentials;
      if (credentials == null) return;

      final activeLights = _saunaStatus?.activeLights ?? [];
      final rgbLight = activeLights.firstWhereOrNull((element) => element.type == LightType.rgb);
      if (rgbLight != null) {
        final result = await _restAPIRepository.setSaunaLight(
          light: rgbLight.copyWith(colorRGB: colorRGB, status: state, brightness: brightness),
          saunaId: credentials.item2,
        );
        if (result != null) {
          updateSaunaStatus(result);
        }
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading updateSaunaLight', error, stackTrace);
    }
  }

  @action
  Future<void> updateSaunaMonoState({required bool state}) async {
    try {
      final credentials = fetchCredentials;
      if (credentials == null) return;

      final activeLights = _saunaStatus?.activeLights ?? [];
      final monoLight = activeLights.firstWhereOrNull((element) => element.type == LightType.mono);
      if (monoLight != null) {
        final result = await _restAPIRepository.setSaunaLight(
          light: monoLight.monoCopyWith(status: state),
          saunaId: credentials.item2,
        );
        if (result != null) {
          updateSaunaStatus(result);
        }
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading updateSaunaLight', error, stackTrace);
    }
  }

  @action
  Future<void> setSaunaState(SaunaState state) async {
    try {
      final credentials = fetchCredentials;
      if (credentials == null) return;

      await _restAPIRepository.setSaunaState(
        state: state,
        saunaId: credentials.item2,
      );
    } catch (error, stackTrace) {
      _logger.e('Error loading setSaunaState', error, stackTrace);
    }
  }

  @action
  Future<void> setSaunaSystemVolume(int volume) async {
    try {
      final credentials = fetchCredentials;
      if (credentials == null) return;

      final result = await _restAPIRepository.setSaunaSystem(
        saunaSystem: SaunaSystem(volume: volume),
        saunaId: credentials.item2,
      );
      if (result == null) return;
      _saunaSystem = result;
    } catch (error, stackTrace) {
      _logger.e('Error loading setSaunaSystemVolume', error, stackTrace);
    }
  }

  @action
  Future<void> setTimeSaunaSystem({bool? isNtpEnabled, String? localTime, String? timezone}) async {
    try {
      final credentials = fetchCredentials;
      if (credentials == null) return;

      final ntpEnabled = isNtpEnabled ?? _saunaSystem?.ntpEnabled;
      final selectedLocalTime = localTime ?? _saunaSystem?.localTime;
      final selectedTimeZone = timezone ?? _saunaSystem?.timezone;
      SaunaSystem saunaSystem;

      if (isNtpEnabled ?? false) {
        saunaSystem = SaunaSystem(
          ntpEnabled: ntpEnabled,
          timezone: selectedTimeZone,
        );
      } else {
        saunaSystem = SaunaSystem(
          ntpEnabled: isNtpEnabled,
          localTime: selectedLocalTime,
          timezone: selectedTimeZone,
        );
      }

      final result = await _restAPIRepository.setSaunaSystem(
        saunaSystem: saunaSystem,
        saunaId: credentials.item2,
      );
      if (result == null) return;
      _saunaSystem = result;
      _setCurrentDateAndTime();
    } catch (error, stackTrace) {
      _logger.e('Error loading setSaunaSystemNTP', error, stackTrace);
    }
  }

  @action
  Future<void> setSaunaSystemBrightness(int brightness) async {
    try {
      final credentials = fetchCredentials;
      if (credentials == null) return;

      final result = await _restAPIRepository.setSaunaSystem(
        saunaSystem: SaunaSystem(screenBrightness: brightness),
        saunaId: credentials.item2,
      );
      if (result != null) {
        _saunaSystem = result;
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading setSaunaSystemBrightness', error, stackTrace);
    }
  }

  @action
  void updateSaunaStatus(SaunaStatus? status) {
    if (status == null) return;
    _saunaStatus = status;
    if (_saunaState != (_saunaStatus?.state ?? SaunaState.fault)) {
      _saunaState = _saunaStatus?.state ?? SaunaState.fault;
      locator<AudioPlayerStore>().playSessionStateSound(state: _saunaState);

      // If sauna is done, we will show the reminder dialog
      if (_saunaState == SaunaState.done && !_isUpdateAfterSessionTapped) {
        _isRemindMeLaterForUpdateTapped = true;
      }

      if (_saunaState == SaunaState.done &&
          (_isUpdateAfterSessionTapped || showFirmwareUpdateDialog || showForceUpdateDialog)) {
        _startSaunaAutoUpdate();
      }
    }

    final program = _saunaStatus?.program?.set;
    if (program == null) return;
    if (_selectedProgram != program) {
      _selectedProgram = program;
    }
  }

  @action
  Future<void> setSelectedProgram(Program selectedProgram, {String? customName}) async {
    try {
      final credentials = fetchCredentials;
      if (credentials == null) return;

      final result = await _restAPIRepository.setSaunaProgram(
        program: selectedProgram.apiValue(customName: customName),
        saunaId: credentials.item2,
      );
      if (result != null) {
        updateSaunaStatus(result);
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading setSelectedProgram', error, stackTrace);
    }
  }

  @action
  Future<void> saveModifiedProgram() async {
    try {
      isResettingProgram = true;
      final saunaStatus = _saunaStatus;
      assert(saunaStatus != null, 'saunaStatus can\'t be null');
      if (saunaStatus == null) return;

      final activeProgram = _saunaStatus?.program?.active;
      assert(activeProgram != null, 'activeProgram can\'t be null');
      if (activeProgram == null) return;

      setSelectedProgram(activeProgram, customName: FoundSpaceConstants.customProgram);
      locator<SaunaLocalStorageStore>().setCustomProgram(activeProgram: activeProgram);
    } catch (error, stackTrace) {
      _logger.e('Error loading saveModifiedProgram', error, stackTrace);
    }

    isResettingProgram = false;
  }

  @action
  Future<void> setSelectedMenuType(SaunaMenuType type) async {
    prevSelectedSaunaMenuType = selectedSaunaMenuType;
    selectedSaunaMenuType = type;
  }

  void setCurrentAPIHost(String hostAPI) {
    var currentHostAPI = hostAPI;
    if (currentHostAPI.endsWith('/')) {
      final hostURL = currentHostAPI.substring(0, _currentHostAPI.length - 1);
      currentHostAPI = hostURL;
    }
    _appConfigBase.currentRestAPIEnvironment = RestAPIEnvironment.customHost;
    _appConfigBase.setCustomHost(host: currentHostAPI);
    _clear();
    _currentHostAPI = '';
    _currentHostAPI = currentHostAPI;
    _fetchSaunaIdentity();
  }

  void resetAPIHost() {
    _appConfigBase.setCustomHost();
    _setupRestAPIFlavor();
    _fetchSaunaIdentity();
  }

  @action
  Future<void> resetModifiedProgram() async {
    try {
      final credentials = fetchCredentials;
      if (credentials == null) return;

      isResettingProgram = true;
      final result = await _restAPIRepository.resetSaunaProgram(
        saunaId: credentials.item2,
      );
      if (result != null) {
        updateSaunaStatus(result);
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading resetModifiedProgram', error, stackTrace);
    }

    isResettingProgram = false;
  }

  @action
  Future<void> factoryReset() async {
    try {
      final credentials = fetchCredentials;
      if (credentials == null) return;

      _isLoading = true;

      final result = await _restAPIRepository.setSaunaFactoryReset(
        saunaId: credentials.item2,
      );
      _isLoading = false;
      _isFactoryReset = result;
    } catch (error, stackTrace) {
      _isFactoryReset = false;
      _isLoading = false;
      _logger.e('Error loading factoryReset', error, stackTrace);
    }
  }

  @action
  Future<void> saunaRestart() async {
    try {
      final credentials = fetchCredentials;
      if (credentials == null) return;

      if (_saunaState != SaunaState.standby) await setSaunaState(SaunaState.standby);
      _isLoading = true;

      await _restAPIRepository.setSaunaRestart(saunaId: credentials.item2);
      _isLoading = false;
    } catch (error, stackTrace) {
      _isLoading = false;
      _logger.e('Error loading saunaRestart', error, stackTrace);
    }
  }

  void _startSaunaAutoUpdate() {
    if (saunaUpdateState == SaunaUpdateState.downloading ||
        saunaUpdateState == SaunaUpdateState.refresh ||
        saunaUpdateState == SaunaUpdateState.writing ||
        saunaUpdateState == SaunaUpdateState.success) {
      return;
    }

    if (showForceUpdateDialog) {
      saunaUpdate();
      return;
    }
    if (!_isUpdateAfterSessionTapped) {
      return;
    }
    saunaUpdate();
  }

  @action
  Future<void> saunaUpdate() async {
    try {
      final credentials = fetchCredentials;
      if (credentials == null) return;

      _isSaunaUpdateLoading = true;
      _isUpdateAfterSessionTapped = false;

      await _restAPIRepository.setSaunaUpdate(
        saunaId: credentials.item2,
      );

      _isSaunaUpdateLoading = false;
    } catch (error, stackTrace) {
      _isSaunaUpdateLoading = false;
      _isUpdateAfterSessionTapped = false;
      _isRemindMeLaterForUpdateTapped = true;
      _logger.e('Error loading saunaUpdate', error, stackTrace);
    }
  }

  @action
  void setIsFactoryReset(bool? value) {
    _isFactoryReset = value;
  }

  void _clear() {
    _saunaIdentity = null;
    _saunaStatus = null;
    _saunaSystem = null;
  }

  @action
  void setPopupType({required PopupType type}) {
    _popupType = type;
  }

  @action
  void setSaunaTimeSettingType({required SaunaTimeSettingType type}) {
    _saunaTimeSettingType = type;
  }

  Future<void> _setCurrentDateAndTime() async {
    final dateTime = _saunaSystem?.localTime;
    final timezone = _saunaSystem?.timezone;

    if (dateTime == null || timezone == null || timezone.isEmpty) return;

    if (_currentDateTime == null) {
      _currentDateTime = DateTime.parse(dateTime);
    } else {
      // Check if the difference is 1 minute or more
      if (DateTime.parse(dateTime).difference(_currentDateTime!).abs() >= const Duration(minutes: 1)) {
        _currentDateTime = DateTime.parse(dateTime);
      }
    }
  }

  @action
  void setAudioVolume({required double volume}) {
    _audioVolume = volume;
  }

  @action
  void setRemindMeLaterForUpdateTapped(bool isTapped) => _isRemindMeLaterForUpdateTapped = isTapped;

  @action
  void setUpdateAfterSessionTapped(bool isTapped) => _isUpdateAfterSessionTapped = isTapped;

  List<int> get _ambienceMediaPlayerPosition {
    final ambienceMediaPlayers = mediaPlayers.take(3).toList();
    return ambienceMediaPlayers.map((e) => e.playlistPos ?? -1).where((pos) => pos >= 0).toList();
  }

  bool _areArraysEqual(List<dynamic> array1, List<dynamic> array2) {
    if (array1.length != array2.length) {
      return false; // Arrays have different lengths, so they can't be the same.
    }

    for (int i = 0; i < array1.length; i++) {
      if (array1[i] != array2[i]) {
        return false; // Elements at the same position are not equal, so the arrays are not the same.
      }
    }

    return true; // All elements are equal, so the arrays are the same.
  }

  @action
  Future<void> _checkIfProfileIsUpdated() async {
    final profileId = _saunaSystem?.profileId;
    if (profileId == null) return;

    final currentPropertiesId = _currentPropertiesId;
    if (currentPropertiesId == null) return;

    _shouldReloadProperties = profileId != _currentPropertiesId;
    if (_shouldReloadProperties && (_saunaState == SaunaState.standby || _saunaState == SaunaState.done)) {
      await _fetchSystemProperties();
      await locator<SaunaProgramPageStore>().fetchSuggestedPrograms();
      await locator<AudioPlayerStore>().reloadMediaPlayers();
    }
  }

  Tuple2<String, String>? get fetchCredentials {
    final token = _saunaIdentity?.adminToken;
    final saunaId = _saunaIdentity?.id;

    assert(saunaId != null, 'saunaId cannot be null');
    assert(token != null, 'token cannot be null');

    if (saunaId == null || token == null) {
      return null;
    }

    return Tuple2(token, saunaId);
  }

  @override
  void dispose() {
    _compositeReaction.dispose();
    super.dispose();
  }
}

enum PopupType {
  brightness,
  qrCode,
  bluetooth,
  dateAndTime,
  menu,
  volume,
  update,
  network,
  none,
}
