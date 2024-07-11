import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:found_space_flutter_rest_api/found_space_flutter_rest_api.dart';
import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:collection/collection.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/mobx_provider.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';

part 'sauna_wifi.store.g.dart';

class SaunaWifiStore = _SaunaWifiStoreBase with _$SaunaWifiStore;

abstract class _SaunaWifiStoreBase with Store, Disposable {
  final _restAPIRepository = locator<RestAPIRepository>();
  final _saunaStore = locator<SaunaStore>();
  final _logger = locator<Logger>();
  bool shouldRefreshAtIntervals = false;

  final _reaction = CompositeReactionDisposer();

  _SaunaWifiStoreBase() {
    reaction((_) => _saunaStore.currentHostAPI, (String currentHostAPI) {
      if (currentHostAPI.isNotEmpty) {
        refresh();
      }
    }).disposeWith(_reaction);
  }

  @readonly
  bool _isLoadingScanWifi = false;

  @readonly
  bool _connectingWifi = false;

  @readonly
  Wifi? _currentActiveWifi;

  @readonly
  Wifi? _selectedWifi;

  @readonly
  bool? _isIncorrectPassword;

  @readonly
  bool _showPassword = false;

  @readonly
  bool _showConnectWifiPopup = false;

  @readonly
  bool _isForgetWifiLoading = false;

  @computed
  NetworkMode get networkMode => _saunaStore.networkMode;

  @computed
  bool get isActiveEthernet => _saunaStore.isActiveEthernet;

  @computed
  bool get isInActiveWifi => _saunaStore.wifiState == WifiState.inactive;

  @readonly
  NetworkMode? _selectedSwitchMode;

  @readonly
  bool _isLoading = false;

  final wifiNetworks = ObservableList<Wifi>();

  void refresh() {
    _clear();
    scanWifi();
  }

  @action
  Future<void> scanWifi() async {
    try {
      _isLoadingScanWifi = true;
      await _fetchScanWifi();
      _isLoadingScanWifi = false;
    } catch (error) {
      locator<Logger>().e(error);
      _isLoadingScanWifi = false;
    }
  }

  Future<void> _fetchScanWifi({bool shouldReset = true}) async {
    try {
      if (shouldReset) {
        wifiNetworks.clear();
      }
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      final result = await _restAPIRepository.fetchWifiScan(saunaId: credentials.item2);
      _currentActiveWifi = result.firstWhereOrNull((element) => element.inUse == true);
      result.removeWhere((element) => element.inUse == true);
      wifiNetworks.addAll(result);
    } catch (error, stackTrace) {
      _logger.e('Error loading _fetchScanWifi', error, stackTrace);
    }

    if (shouldRefreshAtIntervals) {
      refreshScanWifi();
    }
  }

  Future<void> refreshScanWifi() async {
    debugPrint("_refreshScanWifi $shouldRefreshAtIntervals");
    if (!shouldRefreshAtIntervals) return;
    try {
      await Future.delayed(const Duration(seconds: 5));
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      final result = await _restAPIRepository.fetchWifiScan(saunaId: credentials.item2);

      if (!shouldRefreshAtIntervals) return;

      wifiNetworks.clear();
      _currentActiveWifi = result.firstWhereOrNull((element) => element.inUse == true);
      result.removeWhere((element) => element.inUse == true);
      wifiNetworks.addAll(result);
    } catch (error, stackTrace) {
      _logger.e('Error loading _fetchScanWifi', error, stackTrace);
    }
    refreshScanWifi();
  }

  @action
  Future<void> connectWifi({required String password}) async {
    if (password.trim().isEmpty) {
      _isIncorrectPassword = true;
      return;
    }
    try {
      if (_connectingWifi) return;
      _isIncorrectPassword = false;
      if (_selectedWifi == null) return;
      _connectingWifi = true;
      await _connectWifi(password: password);
    } catch (error) {
      _connectingWifi = false;
      locator<Logger>().e(error);
      _isIncorrectPassword = true;
    }
  }

  @action
  void setIsIncorrectPassword(bool value) {
    _isIncorrectPassword = value;
    _showPassword = false;
  }

  Future<void> _connectWifi({required String password}) async {
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      final result = await _restAPIRepository.setWifiNetwork(
        saunaId: credentials.item2,
        ssid: _selectedWifi?.ssid ?? '',
        psk: password,
      );
      if (result != null && result.state == WifiState.active) {
        _currentActiveWifi = null;
        _currentActiveWifi = result;
        _selectedWifi = null;
      } else {
        _currentActiveWifi = null;
        _selectedWifi = null;
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading _connectWifi', error, stackTrace);
      rethrow;
    }
  }

  @action
  Future<void> setSelectedWifi(Wifi selectedWifi) async {
    _selectedWifi = selectedWifi;
  }

  @action
  Future<void> setConnectWifiPopup(bool status, {bool shouldResetScanRefresh = true}) async {
    if (!status) {
      _connectingWifi = false;
      _selectedWifi = null;
    }
    shouldRefreshAtIntervals = !status;
    _showConnectWifiPopup = status;
    if (shouldRefreshAtIntervals && shouldResetScanRefresh) {
      refreshScanWifi();
    }
  }

  void setRefreshIntervals(bool shouldStartRefresh) {
    shouldRefreshAtIntervals = shouldStartRefresh;
  }

  @action
  Future<void> forgotWifi() async {
    _isForgetWifiLoading = true;
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      final result = await _restAPIRepository.forgetWifi(saunaId: credentials.item2);

      if (result) {
        _currentActiveWifi = null;
      }
      _isForgetWifiLoading = false;
    } catch (error, stackTrace) {
      _isForgetWifiLoading = false;
      _logger.e('Error loading forgetWifi', error, stackTrace);
    }
  }

  @action
  Future<void> putSaunaNetwork({required NetworkMode mode}) async {
    _isLoading = true;
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      await _restAPIRepository.putSaunaNetwork(
        saunaId: credentials.item2,
        mode: mode,
      );
      _isLoading = false;
      _selectedSwitchMode = null;
    } catch (error, stackTrace) {
      _logger.e('Error loading putSaunaNetwork', error, stackTrace);
      _isLoading = false;
      _selectedSwitchMode = null;
    }
  }

  @action
  Future<void> shouldShowPassword() async {
    _showPassword = !_showPassword;
  }

  void setSelectSwitchMode(NetworkMode mode) {
    _selectedSwitchMode = mode;
  }

  void _clear() {
    _currentActiveWifi = null;
    _isLoadingScanWifi = false;
    _connectingWifi = false;
    wifiNetworks.clear();
  }

  @override
  void dispose() {
    _reaction.dispose();
    super.dispose();
  }
}
