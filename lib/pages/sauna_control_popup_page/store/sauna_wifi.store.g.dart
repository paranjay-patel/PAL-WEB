// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sauna_wifi.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SaunaWifiStore on _SaunaWifiStoreBase, Store {
  Computed<NetworkMode>? _$networkModeComputed;

  @override
  NetworkMode get networkMode =>
      (_$networkModeComputed ??= Computed<NetworkMode>(() => super.networkMode,
              name: '_SaunaWifiStoreBase.networkMode'))
          .value;
  Computed<bool>? _$isActiveEthernetComputed;

  @override
  bool get isActiveEthernet => (_$isActiveEthernetComputed ??= Computed<bool>(
          () => super.isActiveEthernet,
          name: '_SaunaWifiStoreBase.isActiveEthernet'))
      .value;
  Computed<bool>? _$isInActiveWifiComputed;

  @override
  bool get isInActiveWifi =>
      (_$isInActiveWifiComputed ??= Computed<bool>(() => super.isInActiveWifi,
              name: '_SaunaWifiStoreBase.isInActiveWifi'))
          .value;

  late final _$_isLoadingScanWifiAtom =
      Atom(name: '_SaunaWifiStoreBase._isLoadingScanWifi', context: context);

  bool get isLoadingScanWifi {
    _$_isLoadingScanWifiAtom.reportRead();
    return super._isLoadingScanWifi;
  }

  @override
  bool get _isLoadingScanWifi => isLoadingScanWifi;

  @override
  set _isLoadingScanWifi(bool value) {
    _$_isLoadingScanWifiAtom.reportWrite(value, super._isLoadingScanWifi, () {
      super._isLoadingScanWifi = value;
    });
  }

  late final _$_connectingWifiAtom =
      Atom(name: '_SaunaWifiStoreBase._connectingWifi', context: context);

  bool get connectingWifi {
    _$_connectingWifiAtom.reportRead();
    return super._connectingWifi;
  }

  @override
  bool get _connectingWifi => connectingWifi;

  @override
  set _connectingWifi(bool value) {
    _$_connectingWifiAtom.reportWrite(value, super._connectingWifi, () {
      super._connectingWifi = value;
    });
  }

  late final _$_currentActiveWifiAtom =
      Atom(name: '_SaunaWifiStoreBase._currentActiveWifi', context: context);

  Wifi? get currentActiveWifi {
    _$_currentActiveWifiAtom.reportRead();
    return super._currentActiveWifi;
  }

  @override
  Wifi? get _currentActiveWifi => currentActiveWifi;

  @override
  set _currentActiveWifi(Wifi? value) {
    _$_currentActiveWifiAtom.reportWrite(value, super._currentActiveWifi, () {
      super._currentActiveWifi = value;
    });
  }

  late final _$_selectedWifiAtom =
      Atom(name: '_SaunaWifiStoreBase._selectedWifi', context: context);

  Wifi? get selectedWifi {
    _$_selectedWifiAtom.reportRead();
    return super._selectedWifi;
  }

  @override
  Wifi? get _selectedWifi => selectedWifi;

  @override
  set _selectedWifi(Wifi? value) {
    _$_selectedWifiAtom.reportWrite(value, super._selectedWifi, () {
      super._selectedWifi = value;
    });
  }

  late final _$_isIncorrectPasswordAtom =
      Atom(name: '_SaunaWifiStoreBase._isIncorrectPassword', context: context);

  bool? get isIncorrectPassword {
    _$_isIncorrectPasswordAtom.reportRead();
    return super._isIncorrectPassword;
  }

  @override
  bool? get _isIncorrectPassword => isIncorrectPassword;

  @override
  set _isIncorrectPassword(bool? value) {
    _$_isIncorrectPasswordAtom.reportWrite(value, super._isIncorrectPassword,
        () {
      super._isIncorrectPassword = value;
    });
  }

  late final _$_showPasswordAtom =
      Atom(name: '_SaunaWifiStoreBase._showPassword', context: context);

  bool get showPassword {
    _$_showPasswordAtom.reportRead();
    return super._showPassword;
  }

  @override
  bool get _showPassword => showPassword;

  @override
  set _showPassword(bool value) {
    _$_showPasswordAtom.reportWrite(value, super._showPassword, () {
      super._showPassword = value;
    });
  }

  late final _$_showConnectWifiPopupAtom =
      Atom(name: '_SaunaWifiStoreBase._showConnectWifiPopup', context: context);

  bool get showConnectWifiPopup {
    _$_showConnectWifiPopupAtom.reportRead();
    return super._showConnectWifiPopup;
  }

  @override
  bool get _showConnectWifiPopup => showConnectWifiPopup;

  @override
  set _showConnectWifiPopup(bool value) {
    _$_showConnectWifiPopupAtom.reportWrite(value, super._showConnectWifiPopup,
        () {
      super._showConnectWifiPopup = value;
    });
  }

  late final _$_isForgetWifiLoadingAtom =
      Atom(name: '_SaunaWifiStoreBase._isForgetWifiLoading', context: context);

  bool get isForgetWifiLoading {
    _$_isForgetWifiLoadingAtom.reportRead();
    return super._isForgetWifiLoading;
  }

  @override
  bool get _isForgetWifiLoading => isForgetWifiLoading;

  @override
  set _isForgetWifiLoading(bool value) {
    _$_isForgetWifiLoadingAtom.reportWrite(value, super._isForgetWifiLoading,
        () {
      super._isForgetWifiLoading = value;
    });
  }

  late final _$_selectedSwitchModeAtom =
      Atom(name: '_SaunaWifiStoreBase._selectedSwitchMode', context: context);

  NetworkMode? get selectedSwitchMode {
    _$_selectedSwitchModeAtom.reportRead();
    return super._selectedSwitchMode;
  }

  @override
  NetworkMode? get _selectedSwitchMode => selectedSwitchMode;

  @override
  set _selectedSwitchMode(NetworkMode? value) {
    _$_selectedSwitchModeAtom.reportWrite(value, super._selectedSwitchMode, () {
      super._selectedSwitchMode = value;
    });
  }

  late final _$_isLoadingAtom =
      Atom(name: '_SaunaWifiStoreBase._isLoading', context: context);

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

  late final _$scanWifiAsyncAction =
      AsyncAction('_SaunaWifiStoreBase.scanWifi', context: context);

  @override
  Future<void> scanWifi() {
    return _$scanWifiAsyncAction.run(() => super.scanWifi());
  }

  late final _$connectWifiAsyncAction =
      AsyncAction('_SaunaWifiStoreBase.connectWifi', context: context);

  @override
  Future<void> connectWifi({required String password}) {
    return _$connectWifiAsyncAction
        .run(() => super.connectWifi(password: password));
  }

  late final _$setSelectedWifiAsyncAction =
      AsyncAction('_SaunaWifiStoreBase.setSelectedWifi', context: context);

  @override
  Future<void> setSelectedWifi(Wifi selectedWifi) {
    return _$setSelectedWifiAsyncAction
        .run(() => super.setSelectedWifi(selectedWifi));
  }

  late final _$setConnectWifiPopupAsyncAction =
      AsyncAction('_SaunaWifiStoreBase.setConnectWifiPopup', context: context);

  @override
  Future<void> setConnectWifiPopup(bool status,
      {bool shouldResetScanRefresh = true}) {
    return _$setConnectWifiPopupAsyncAction.run(() => super.setConnectWifiPopup(
        status,
        shouldResetScanRefresh: shouldResetScanRefresh));
  }

  late final _$forgotWifiAsyncAction =
      AsyncAction('_SaunaWifiStoreBase.forgotWifi', context: context);

  @override
  Future<void> forgotWifi() {
    return _$forgotWifiAsyncAction.run(() => super.forgotWifi());
  }

  late final _$putSaunaNetworkAsyncAction =
      AsyncAction('_SaunaWifiStoreBase.putSaunaNetwork', context: context);

  @override
  Future<void> putSaunaNetwork({required NetworkMode mode}) {
    return _$putSaunaNetworkAsyncAction
        .run(() => super.putSaunaNetwork(mode: mode));
  }

  late final _$shouldShowPasswordAsyncAction =
      AsyncAction('_SaunaWifiStoreBase.shouldShowPassword', context: context);

  @override
  Future<void> shouldShowPassword() {
    return _$shouldShowPasswordAsyncAction
        .run(() => super.shouldShowPassword());
  }

  late final _$_SaunaWifiStoreBaseActionController =
      ActionController(name: '_SaunaWifiStoreBase', context: context);

  @override
  void setIsIncorrectPassword(bool value) {
    final _$actionInfo = _$_SaunaWifiStoreBaseActionController.startAction(
        name: '_SaunaWifiStoreBase.setIsIncorrectPassword');
    try {
      return super.setIsIncorrectPassword(value);
    } finally {
      _$_SaunaWifiStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
networkMode: ${networkMode},
isActiveEthernet: ${isActiveEthernet},
isInActiveWifi: ${isInActiveWifi}
    ''';
  }
}
