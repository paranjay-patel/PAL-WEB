import 'dart:async';

import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:found_space_flutter_web_application/common/found_space_constants.dart';
import 'package:found_space_flutter_web_application/common/found_space_router.dart';
import 'package:found_space_flutter_web_application/common/mobx_provider.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_menu_button.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_page_common.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/utils/sauna_color_theme_utils.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:mobx/mobx.dart';

part 'sauna_control_popup_page.store.g.dart';

enum SaunaFirmwarePopupType {
  none,
  reset,
  restart,
}

class SaunaControlPopupPageStore = _SaunaControlPopupPageStoreBase with _$SaunaControlPopupPageStore;

abstract class _SaunaControlPopupPageStoreBase with Store, Disposable {
  final _saunaStore = locator<SaunaStore>();
  final _saunaLocalStorageStore = locator<SaunaLocalStorageStore>();

  _SaunaControlPopupPageStoreBase() {
    _saunaColorThemeModeType =
        _saunaLocalStorageStore.isNightMode ? SaunaColorThemeModeType.dark : SaunaColorThemeModeType.light;
    startTimer();
  }

  @readonly
  double? _targetTemperature;

  @readonly
  SaunaColorThemeModeType _saunaColorThemeModeType = SaunaColorThemeModeType.light;

  @readonly
  double? _targetDuration;

  @readonly
  bool _shouldShowBackArrow = true;

  @readonly
  bool _shouldShowForwardArrow = true;

  @readonly
  double _lightOpacity = 0.0;

  @readonly
  bool _monoLightStatus = false;

  @readonly
  bool _isUpdateAvailable = false;

  @readonly
  bool _isResetLoading = false;

  @readonly
  SaunaFirmwarePopupType _saunaFirmwarePopupType = SaunaFirmwarePopupType.none;

  @computed
  int get maxTemperature {
    final temperatureScale = _saunaLocalStorageStore.temperatureScale;
    const maxValueInCelsius = 70;
    return temperatureScale == TemperatureScale.fahrenheit
        ? Utils.convertToFahrenheit(maxValueInCelsius)
        : maxValueInCelsius;
  }

  @computed
  int get minTemperature {
    final temperatureScale = _saunaLocalStorageStore.temperatureScale;
    const minValueInCelsius = 20;
    return temperatureScale == TemperatureScale.fahrenheit
        ? Utils.convertToFahrenheit(minValueInCelsius)
        : minValueInCelsius;
  }

  @computed
  int get rangePointerTemperature {
    final targetTemperature = _targetTemperature ?? 20;

    final temperatureScale = _saunaLocalStorageStore.temperatureScale;
    return temperatureScale == TemperatureScale.fahrenheit
        ? Utils.convertToFahrenheit(targetTemperature.toInt())
        : targetTemperature.toInt();
  }

  @computed
  int get temperatureInterval {
    return _saunaLocalStorageStore.temperatureScale == TemperatureScale.fahrenheit ? 45 : 25;
  }

  late Timer _timer;

  @readonly
  int _secondsRemaining = FoundSpaceConstants.timeoutPopupDurationSecs;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
      } else {
        _secondsRemaining = 0;
        cancelTimer();
      }
    });
  }

  void cancelTimer() {
    _timer.cancel();
    _secondsRemaining = FoundSpaceConstants.timeoutPopupDurationSecs;
  }

  SaunaLightTabType get _defaultSaunaLightTabType {
    return _saunaStore.saunaLightControlType == SaunaLightControlType.mono
        ? SaunaLightTabType.mono
        : SaunaLightTabType.rgb;
  }

  String displayableTemperatureValue(int temperature) {
    final isFahrenheitScale = _saunaLocalStorageStore.temperatureScale == TemperatureScale.fahrenheit;
    if (isFahrenheitScale) {
      final fahrenheitValue = Utils.convertToFahrenheit(temperature);
      return "$fahrenheitValue°F";
    }
    return "$temperature°C";
  }

  @action
  void setResetLoading(bool isLoading) {
    _isResetLoading = isLoading;
  }

  @action
  void setSaunaFirmwarePopupType(SaunaFirmwarePopupType type) {
    _saunaFirmwarePopupType = type;
  }

  @action
  void setUpdateAvailable(bool isUpdateAvailable) {
    _isUpdateAvailable = isUpdateAvailable;
  }

  @action
  void setLightOpacity(double opacity) {
    _lightOpacity = opacity;
  }

  @action
  void setMonoLightStatus(bool status) {
    _monoLightStatus = status;
  }

  void _setup() {
    _targetDuration = _saunaStore.targetTimer.toDouble();
    _targetTemperature = _saunaStore.targetTemperature.toDouble();
  }

  @action
  Future<void> setArgument(SaunaControlPopupPageArguments arguments) async {
    final saunaBottomButton = arguments.saunaBottomButton;
    _selectedSaunaBottomButton = saunaBottomButton;
    setSelectedSaunaLightTabType(_defaultSaunaLightTabType);
    _setNavigationArrowVisibility();
    _setup();
  }

  @readonly
  SaunaBottomButton? _selectedSaunaBottomButton;

  @readonly
  AudioControlMenu _selectedAudioControlMenu = AudioControlMenu.sound;

  @readonly
  SaunaLightTabType _selectedSaunaLightTabType = SaunaLightTabType.rgb;

  @readonly
  SaunaAdvanceSettingsTabType _selectedAdvanceSettingsTabType = SaunaAdvanceSettingsTabType.general;

  @action
  Future<void> setSelectedSaunaBottomButton(SaunaBottomButton saunaBottomButton) async {
    _selectedSaunaBottomButton = saunaBottomButton;
    _saunaStore.setPopupType(type: PopupType.none);
    _setNavigationArrowVisibility();
    setSelectedSaunaAdvanceSettingsTabType(SaunaAdvanceSettingsTabType.general);
    setSelectedSaunaLightTabType(_defaultSaunaLightTabType);
    setSelectedAudioControlMenu(AudioControlMenu.sound);
  }

  @action
  Future<void> setNextSelectedSaunaBottomButton(SaunaBottomButton saunaBottomButton) async {
    final selectedSaunaBottomButton = _selectedSaunaBottomButton;
    if (selectedSaunaBottomButton == null) return;
    setSelectedSaunaLightTabType(_defaultSaunaLightTabType);
    setSelectedAudioControlMenu(AudioControlMenu.sound);
    final nextButtonType = saunaBottomButton.nextButtonType;
    _selectedSaunaBottomButton = nextButtonType;
    _saunaStore.setPopupType(type: PopupType.none);
    setSelectedSaunaAdvanceSettingsTabType(SaunaAdvanceSettingsTabType.general);
    _setNavigationArrowVisibility();
  }

  @action
  Future<void> setPrevSelectedSaunaBottomButton(SaunaBottomButton saunaBottomButton) async {
    final selectedSaunaBottomButton = _selectedSaunaBottomButton;
    if (selectedSaunaBottomButton == null) return;
    setSelectedSaunaLightTabType(_defaultSaunaLightTabType);
    setSelectedAudioControlMenu(AudioControlMenu.sound);
    final prevButtonType = saunaBottomButton.prevButtonType;
    _selectedSaunaBottomButton = prevButtonType;
    setSaunaFirmwarePopupType(SaunaFirmwarePopupType.none);
    _saunaStore.setPopupType(type: PopupType.none);
    _setNavigationArrowVisibility();
  }

  @action
  Future<void> setCurrentTemperature(double temperature) async {
    final temperatureScale = _saunaLocalStorageStore.temperatureScale;
    if (temperatureScale == TemperatureScale.fahrenheit) {
      final temperatureInCelsius = Utils.convertToCelsius(temperature.toInt());
      _targetTemperature = temperatureInCelsius.toDouble();
      return;
    }
    _targetTemperature = temperature;
  }

  @action
  Future<void> _setNavigationArrowVisibility() async {
    final selectedSaunaBottomButton = _selectedSaunaBottomButton;
    if (selectedSaunaBottomButton == null) return;
    final isSettingSelected = _saunaStore.selectedSaunaMenuType == SaunaMenuType.settings;
    if (isSettingSelected) {
      _shouldShowBackArrow = selectedSaunaBottomButton != SaunaBottomButton.saverAndSleepMode;
      _shouldShowForwardArrow = _saunaStore.shouldShowDebugMenu
          ? selectedSaunaBottomButton != SaunaBottomButton.debug
          : selectedSaunaBottomButton != SaunaBottomButton.advancedSettings;
    } else {
      _shouldShowBackArrow = selectedSaunaBottomButton != SaunaBottomButton.temperature;
      _shouldShowForwardArrow = selectedSaunaBottomButton != SaunaBottomButton.audio;
    }
  }

  @action
  Future<void> increaseTemperature() async {
    final currentTemperature = _targetTemperature;
    if (currentTemperature == null) return;
    if (_targetTemperature == 70) return;
    _targetTemperature = currentTemperature + 1;
    updateTargetTemperature();
  }

  @action
  Future<void> decreaseTemperature() async {
    final currentTemperature = _targetTemperature;
    if (currentTemperature == null) return;
    if (_targetTemperature == 20) return;
    _targetTemperature = currentTemperature - 1;
    updateTargetTemperature();
  }

  @action
  Future<void> setCurrentTime(double time) async {
    _targetDuration = time;
  }

  @action
  Future<void> increaseTime() async {
    final currentTime = _targetDuration;
    if (currentTime == null) return;
    if (_targetDuration == 60) return;
    _targetDuration = currentTime + 1;
    updateTargetTime();
  }

  @action
  Future<void> decreaseTime() async {
    final currentTime = _targetDuration;
    if (currentTime == null) return;
    if (_targetDuration == 1) return;
    _targetDuration = currentTime - 1;
    updateTargetTime();
  }

  @action
  Future<void> updateTargetTime() async {
    final targetDuration = _targetDuration;
    if (targetDuration == null) return;
    _saunaStore.updateTargetTime(targetTime: targetDuration.toInt());
  }

  @action
  Future<void> updateTargetTemperature() async {
    final targetTemperature = _targetTemperature;
    if (targetTemperature == null || targetTemperature < 0) return;

    _saunaStore.updateTargetTemperature(targetTemperature: targetTemperature);
  }

  @action
  void setSelectedAudioControlMenu(AudioControlMenu menu) => _selectedAudioControlMenu = menu;

  @action
  void setSelectedSaunaLightTabType(SaunaLightTabType type) => _selectedSaunaLightTabType = type;

  @action
  void setSelectedSaunaAdvanceSettingsTabType(SaunaAdvanceSettingsTabType type) =>
      _selectedAdvanceSettingsTabType = type;

  @action
  Future<void> setSaunaColorThemeModeType(SaunaColorThemeModeType saunaColorThemeModeType) async {
    _saunaColorThemeModeType = saunaColorThemeModeType;
    _saunaLocalStorageStore.setAppThemeSettings(isNightMode: _saunaColorThemeModeType == SaunaColorThemeModeType.dark);
  }
}
