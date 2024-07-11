// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sauna_control_popup_page.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SaunaControlPopupPageStore on _SaunaControlPopupPageStoreBase, Store {
  Computed<int>? _$maxTemperatureComputed;

  @override
  int get maxTemperature =>
      (_$maxTemperatureComputed ??= Computed<int>(() => super.maxTemperature,
              name: '_SaunaControlPopupPageStoreBase.maxTemperature'))
          .value;
  Computed<int>? _$minTemperatureComputed;

  @override
  int get minTemperature =>
      (_$minTemperatureComputed ??= Computed<int>(() => super.minTemperature,
              name: '_SaunaControlPopupPageStoreBase.minTemperature'))
          .value;
  Computed<int>? _$rangePointerTemperatureComputed;

  @override
  int get rangePointerTemperature => (_$rangePointerTemperatureComputed ??=
          Computed<int>(() => super.rangePointerTemperature,
              name: '_SaunaControlPopupPageStoreBase.rangePointerTemperature'))
      .value;
  Computed<int>? _$temperatureIntervalComputed;

  @override
  int get temperatureInterval => (_$temperatureIntervalComputed ??=
          Computed<int>(() => super.temperatureInterval,
              name: '_SaunaControlPopupPageStoreBase.temperatureInterval'))
      .value;

  late final _$_targetTemperatureAtom = Atom(
      name: '_SaunaControlPopupPageStoreBase._targetTemperature',
      context: context);

  double? get targetTemperature {
    _$_targetTemperatureAtom.reportRead();
    return super._targetTemperature;
  }

  @override
  double? get _targetTemperature => targetTemperature;

  @override
  set _targetTemperature(double? value) {
    _$_targetTemperatureAtom.reportWrite(value, super._targetTemperature, () {
      super._targetTemperature = value;
    });
  }

  late final _$_saunaColorThemeModeTypeAtom = Atom(
      name: '_SaunaControlPopupPageStoreBase._saunaColorThemeModeType',
      context: context);

  SaunaColorThemeModeType get saunaColorThemeModeType {
    _$_saunaColorThemeModeTypeAtom.reportRead();
    return super._saunaColorThemeModeType;
  }

  @override
  SaunaColorThemeModeType get _saunaColorThemeModeType =>
      saunaColorThemeModeType;

  @override
  set _saunaColorThemeModeType(SaunaColorThemeModeType value) {
    _$_saunaColorThemeModeTypeAtom
        .reportWrite(value, super._saunaColorThemeModeType, () {
      super._saunaColorThemeModeType = value;
    });
  }

  late final _$_targetDurationAtom = Atom(
      name: '_SaunaControlPopupPageStoreBase._targetDuration',
      context: context);

  double? get targetDuration {
    _$_targetDurationAtom.reportRead();
    return super._targetDuration;
  }

  @override
  double? get _targetDuration => targetDuration;

  @override
  set _targetDuration(double? value) {
    _$_targetDurationAtom.reportWrite(value, super._targetDuration, () {
      super._targetDuration = value;
    });
  }

  late final _$_shouldShowBackArrowAtom = Atom(
      name: '_SaunaControlPopupPageStoreBase._shouldShowBackArrow',
      context: context);

  bool get shouldShowBackArrow {
    _$_shouldShowBackArrowAtom.reportRead();
    return super._shouldShowBackArrow;
  }

  @override
  bool get _shouldShowBackArrow => shouldShowBackArrow;

  @override
  set _shouldShowBackArrow(bool value) {
    _$_shouldShowBackArrowAtom.reportWrite(value, super._shouldShowBackArrow,
        () {
      super._shouldShowBackArrow = value;
    });
  }

  late final _$_shouldShowForwardArrowAtom = Atom(
      name: '_SaunaControlPopupPageStoreBase._shouldShowForwardArrow',
      context: context);

  bool get shouldShowForwardArrow {
    _$_shouldShowForwardArrowAtom.reportRead();
    return super._shouldShowForwardArrow;
  }

  @override
  bool get _shouldShowForwardArrow => shouldShowForwardArrow;

  @override
  set _shouldShowForwardArrow(bool value) {
    _$_shouldShowForwardArrowAtom
        .reportWrite(value, super._shouldShowForwardArrow, () {
      super._shouldShowForwardArrow = value;
    });
  }

  late final _$_lightOpacityAtom = Atom(
      name: '_SaunaControlPopupPageStoreBase._lightOpacity', context: context);

  double get lightOpacity {
    _$_lightOpacityAtom.reportRead();
    return super._lightOpacity;
  }

  @override
  double get _lightOpacity => lightOpacity;

  @override
  set _lightOpacity(double value) {
    _$_lightOpacityAtom.reportWrite(value, super._lightOpacity, () {
      super._lightOpacity = value;
    });
  }

  late final _$_monoLightStatusAtom = Atom(
      name: '_SaunaControlPopupPageStoreBase._monoLightStatus',
      context: context);

  bool get monoLightStatus {
    _$_monoLightStatusAtom.reportRead();
    return super._monoLightStatus;
  }

  @override
  bool get _monoLightStatus => monoLightStatus;

  @override
  set _monoLightStatus(bool value) {
    _$_monoLightStatusAtom.reportWrite(value, super._monoLightStatus, () {
      super._monoLightStatus = value;
    });
  }

  late final _$_isUpdateAvailableAtom = Atom(
      name: '_SaunaControlPopupPageStoreBase._isUpdateAvailable',
      context: context);

  bool get isUpdateAvailable {
    _$_isUpdateAvailableAtom.reportRead();
    return super._isUpdateAvailable;
  }

  @override
  bool get _isUpdateAvailable => isUpdateAvailable;

  @override
  set _isUpdateAvailable(bool value) {
    _$_isUpdateAvailableAtom.reportWrite(value, super._isUpdateAvailable, () {
      super._isUpdateAvailable = value;
    });
  }

  late final _$_isResetLoadingAtom = Atom(
      name: '_SaunaControlPopupPageStoreBase._isResetLoading',
      context: context);

  bool get isResetLoading {
    _$_isResetLoadingAtom.reportRead();
    return super._isResetLoading;
  }

  @override
  bool get _isResetLoading => isResetLoading;

  @override
  set _isResetLoading(bool value) {
    _$_isResetLoadingAtom.reportWrite(value, super._isResetLoading, () {
      super._isResetLoading = value;
    });
  }

  late final _$_saunaFirmwarePopupTypeAtom = Atom(
      name: '_SaunaControlPopupPageStoreBase._saunaFirmwarePopupType',
      context: context);

  SaunaFirmwarePopupType get saunaFirmwarePopupType {
    _$_saunaFirmwarePopupTypeAtom.reportRead();
    return super._saunaFirmwarePopupType;
  }

  @override
  SaunaFirmwarePopupType get _saunaFirmwarePopupType => saunaFirmwarePopupType;

  @override
  set _saunaFirmwarePopupType(SaunaFirmwarePopupType value) {
    _$_saunaFirmwarePopupTypeAtom
        .reportWrite(value, super._saunaFirmwarePopupType, () {
      super._saunaFirmwarePopupType = value;
    });
  }

  late final _$_secondsRemainingAtom = Atom(
      name: '_SaunaControlPopupPageStoreBase._secondsRemaining',
      context: context);

  int get secondsRemaining {
    _$_secondsRemainingAtom.reportRead();
    return super._secondsRemaining;
  }

  @override
  int get _secondsRemaining => secondsRemaining;

  @override
  set _secondsRemaining(int value) {
    _$_secondsRemainingAtom.reportWrite(value, super._secondsRemaining, () {
      super._secondsRemaining = value;
    });
  }

  late final _$_selectedSaunaBottomButtonAtom = Atom(
      name: '_SaunaControlPopupPageStoreBase._selectedSaunaBottomButton',
      context: context);

  SaunaBottomButton? get selectedSaunaBottomButton {
    _$_selectedSaunaBottomButtonAtom.reportRead();
    return super._selectedSaunaBottomButton;
  }

  @override
  SaunaBottomButton? get _selectedSaunaBottomButton =>
      selectedSaunaBottomButton;

  @override
  set _selectedSaunaBottomButton(SaunaBottomButton? value) {
    _$_selectedSaunaBottomButtonAtom
        .reportWrite(value, super._selectedSaunaBottomButton, () {
      super._selectedSaunaBottomButton = value;
    });
  }

  late final _$_selectedAudioControlMenuAtom = Atom(
      name: '_SaunaControlPopupPageStoreBase._selectedAudioControlMenu',
      context: context);

  AudioControlMenu get selectedAudioControlMenu {
    _$_selectedAudioControlMenuAtom.reportRead();
    return super._selectedAudioControlMenu;
  }

  @override
  AudioControlMenu get _selectedAudioControlMenu => selectedAudioControlMenu;

  @override
  set _selectedAudioControlMenu(AudioControlMenu value) {
    _$_selectedAudioControlMenuAtom
        .reportWrite(value, super._selectedAudioControlMenu, () {
      super._selectedAudioControlMenu = value;
    });
  }

  late final _$_selectedSaunaLightTabTypeAtom = Atom(
      name: '_SaunaControlPopupPageStoreBase._selectedSaunaLightTabType',
      context: context);

  SaunaLightTabType get selectedSaunaLightTabType {
    _$_selectedSaunaLightTabTypeAtom.reportRead();
    return super._selectedSaunaLightTabType;
  }

  @override
  SaunaLightTabType get _selectedSaunaLightTabType => selectedSaunaLightTabType;

  @override
  set _selectedSaunaLightTabType(SaunaLightTabType value) {
    _$_selectedSaunaLightTabTypeAtom
        .reportWrite(value, super._selectedSaunaLightTabType, () {
      super._selectedSaunaLightTabType = value;
    });
  }

  late final _$_selectedAdvanceSettingsTabTypeAtom = Atom(
      name: '_SaunaControlPopupPageStoreBase._selectedAdvanceSettingsTabType',
      context: context);

  SaunaAdvanceSettingsTabType get selectedAdvanceSettingsTabType {
    _$_selectedAdvanceSettingsTabTypeAtom.reportRead();
    return super._selectedAdvanceSettingsTabType;
  }

  @override
  SaunaAdvanceSettingsTabType get _selectedAdvanceSettingsTabType =>
      selectedAdvanceSettingsTabType;

  @override
  set _selectedAdvanceSettingsTabType(SaunaAdvanceSettingsTabType value) {
    _$_selectedAdvanceSettingsTabTypeAtom
        .reportWrite(value, super._selectedAdvanceSettingsTabType, () {
      super._selectedAdvanceSettingsTabType = value;
    });
  }

  late final _$setArgumentAsyncAction = AsyncAction(
      '_SaunaControlPopupPageStoreBase.setArgument',
      context: context);

  @override
  Future<void> setArgument(SaunaControlPopupPageArguments arguments) {
    return _$setArgumentAsyncAction.run(() => super.setArgument(arguments));
  }

  late final _$setSelectedSaunaBottomButtonAsyncAction = AsyncAction(
      '_SaunaControlPopupPageStoreBase.setSelectedSaunaBottomButton',
      context: context);

  @override
  Future<void> setSelectedSaunaBottomButton(
      SaunaBottomButton saunaBottomButton) {
    return _$setSelectedSaunaBottomButtonAsyncAction
        .run(() => super.setSelectedSaunaBottomButton(saunaBottomButton));
  }

  late final _$setNextSelectedSaunaBottomButtonAsyncAction = AsyncAction(
      '_SaunaControlPopupPageStoreBase.setNextSelectedSaunaBottomButton',
      context: context);

  @override
  Future<void> setNextSelectedSaunaBottomButton(
      SaunaBottomButton saunaBottomButton) {
    return _$setNextSelectedSaunaBottomButtonAsyncAction
        .run(() => super.setNextSelectedSaunaBottomButton(saunaBottomButton));
  }

  late final _$setPrevSelectedSaunaBottomButtonAsyncAction = AsyncAction(
      '_SaunaControlPopupPageStoreBase.setPrevSelectedSaunaBottomButton',
      context: context);

  @override
  Future<void> setPrevSelectedSaunaBottomButton(
      SaunaBottomButton saunaBottomButton) {
    return _$setPrevSelectedSaunaBottomButtonAsyncAction
        .run(() => super.setPrevSelectedSaunaBottomButton(saunaBottomButton));
  }

  late final _$setCurrentTemperatureAsyncAction = AsyncAction(
      '_SaunaControlPopupPageStoreBase.setCurrentTemperature',
      context: context);

  @override
  Future<void> setCurrentTemperature(double temperature) {
    return _$setCurrentTemperatureAsyncAction
        .run(() => super.setCurrentTemperature(temperature));
  }

  late final _$_setNavigationArrowVisibilityAsyncAction = AsyncAction(
      '_SaunaControlPopupPageStoreBase._setNavigationArrowVisibility',
      context: context);

  @override
  Future<void> _setNavigationArrowVisibility() {
    return _$_setNavigationArrowVisibilityAsyncAction
        .run(() => super._setNavigationArrowVisibility());
  }

  late final _$increaseTemperatureAsyncAction = AsyncAction(
      '_SaunaControlPopupPageStoreBase.increaseTemperature',
      context: context);

  @override
  Future<void> increaseTemperature() {
    return _$increaseTemperatureAsyncAction
        .run(() => super.increaseTemperature());
  }

  late final _$decreaseTemperatureAsyncAction = AsyncAction(
      '_SaunaControlPopupPageStoreBase.decreaseTemperature',
      context: context);

  @override
  Future<void> decreaseTemperature() {
    return _$decreaseTemperatureAsyncAction
        .run(() => super.decreaseTemperature());
  }

  late final _$setCurrentTimeAsyncAction = AsyncAction(
      '_SaunaControlPopupPageStoreBase.setCurrentTime',
      context: context);

  @override
  Future<void> setCurrentTime(double time) {
    return _$setCurrentTimeAsyncAction.run(() => super.setCurrentTime(time));
  }

  late final _$increaseTimeAsyncAction = AsyncAction(
      '_SaunaControlPopupPageStoreBase.increaseTime',
      context: context);

  @override
  Future<void> increaseTime() {
    return _$increaseTimeAsyncAction.run(() => super.increaseTime());
  }

  late final _$decreaseTimeAsyncAction = AsyncAction(
      '_SaunaControlPopupPageStoreBase.decreaseTime',
      context: context);

  @override
  Future<void> decreaseTime() {
    return _$decreaseTimeAsyncAction.run(() => super.decreaseTime());
  }

  late final _$updateTargetTimeAsyncAction = AsyncAction(
      '_SaunaControlPopupPageStoreBase.updateTargetTime',
      context: context);

  @override
  Future<void> updateTargetTime() {
    return _$updateTargetTimeAsyncAction.run(() => super.updateTargetTime());
  }

  late final _$updateTargetTemperatureAsyncAction = AsyncAction(
      '_SaunaControlPopupPageStoreBase.updateTargetTemperature',
      context: context);

  @override
  Future<void> updateTargetTemperature() {
    return _$updateTargetTemperatureAsyncAction
        .run(() => super.updateTargetTemperature());
  }

  late final _$setSaunaColorThemeModeTypeAsyncAction = AsyncAction(
      '_SaunaControlPopupPageStoreBase.setSaunaColorThemeModeType',
      context: context);

  @override
  Future<void> setSaunaColorThemeModeType(
      SaunaColorThemeModeType saunaColorThemeModeType) {
    return _$setSaunaColorThemeModeTypeAsyncAction
        .run(() => super.setSaunaColorThemeModeType(saunaColorThemeModeType));
  }

  late final _$_SaunaControlPopupPageStoreBaseActionController =
      ActionController(
          name: '_SaunaControlPopupPageStoreBase', context: context);

  @override
  void setResetLoading(bool isLoading) {
    final _$actionInfo = _$_SaunaControlPopupPageStoreBaseActionController
        .startAction(name: '_SaunaControlPopupPageStoreBase.setResetLoading');
    try {
      return super.setResetLoading(isLoading);
    } finally {
      _$_SaunaControlPopupPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSaunaFirmwarePopupType(SaunaFirmwarePopupType type) {
    final _$actionInfo =
        _$_SaunaControlPopupPageStoreBaseActionController.startAction(
            name: '_SaunaControlPopupPageStoreBase.setSaunaFirmwarePopupType');
    try {
      return super.setSaunaFirmwarePopupType(type);
    } finally {
      _$_SaunaControlPopupPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUpdateAvailable(bool isUpdateAvailable) {
    final _$actionInfo =
        _$_SaunaControlPopupPageStoreBaseActionController.startAction(
            name: '_SaunaControlPopupPageStoreBase.setUpdateAvailable');
    try {
      return super.setUpdateAvailable(isUpdateAvailable);
    } finally {
      _$_SaunaControlPopupPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLightOpacity(double opacity) {
    final _$actionInfo = _$_SaunaControlPopupPageStoreBaseActionController
        .startAction(name: '_SaunaControlPopupPageStoreBase.setLightOpacity');
    try {
      return super.setLightOpacity(opacity);
    } finally {
      _$_SaunaControlPopupPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMonoLightStatus(bool status) {
    final _$actionInfo =
        _$_SaunaControlPopupPageStoreBaseActionController.startAction(
            name: '_SaunaControlPopupPageStoreBase.setMonoLightStatus');
    try {
      return super.setMonoLightStatus(status);
    } finally {
      _$_SaunaControlPopupPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedAudioControlMenu(AudioControlMenu menu) {
    final _$actionInfo =
        _$_SaunaControlPopupPageStoreBaseActionController.startAction(
            name:
                '_SaunaControlPopupPageStoreBase.setSelectedAudioControlMenu');
    try {
      return super.setSelectedAudioControlMenu(menu);
    } finally {
      _$_SaunaControlPopupPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedSaunaLightTabType(SaunaLightTabType type) {
    final _$actionInfo =
        _$_SaunaControlPopupPageStoreBaseActionController.startAction(
            name:
                '_SaunaControlPopupPageStoreBase.setSelectedSaunaLightTabType');
    try {
      return super.setSelectedSaunaLightTabType(type);
    } finally {
      _$_SaunaControlPopupPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedSaunaAdvanceSettingsTabType(
      SaunaAdvanceSettingsTabType type) {
    final _$actionInfo =
        _$_SaunaControlPopupPageStoreBaseActionController.startAction(
            name:
                '_SaunaControlPopupPageStoreBase.setSelectedSaunaAdvanceSettingsTabType');
    try {
      return super.setSelectedSaunaAdvanceSettingsTabType(type);
    } finally {
      _$_SaunaControlPopupPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
maxTemperature: ${maxTemperature},
minTemperature: ${minTemperature},
rangePointerTemperature: ${rangePointerTemperature},
temperatureInterval: ${temperatureInterval}
    ''';
  }
}
