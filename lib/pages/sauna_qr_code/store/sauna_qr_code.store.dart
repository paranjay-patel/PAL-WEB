import 'dart:async';
import 'dart:convert';

import 'package:found_space_flutter_rest_api/found_space_flutter_rest_api.dart';
import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:found_space_flutter_web_application/common/mobx_provider.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:found_space_flutter_web_application/src/models/qr_code_data.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';

part 'sauna_qr_code.store.g.dart';

class SaunaQRCodeStore = _SaunaQRCodeStoreBase with _$SaunaQRCodeStore;

abstract class _SaunaQRCodeStoreBase with Store, Disposable {
  final _saunaStore = locator<SaunaStore>();

  _SaunaQRCodeStoreBase() {
    _isInternetConnected = _saunaStore.isWifiConnected || _saunaStore.isActiveEthernet;
    _fetchNetwork();
  }

  final _restAPIRepository = locator<RestAPIRepository>();
  final _logger = locator<Logger>();

  late Network? _network;

  late QRCodeData _qrCodeData;

  late SaunaPair? _saunaPair;

  @readonly
  bool _isInternetConnected = false;

  @readonly
  String _qrCode = '';

  @readonly
  bool _isLoading = false;

  late Timer _timer;

  @readonly
  int _secondsRemaining = 30;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
      } else {
        _secondsRemaining == 0;
        cancelTimer();
      }
    });
  }

  void cancelTimer() {
    _timer.cancel();
  }

  Future<void> _fetchNetwork() async {
    _isLoading = true;
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      _saunaPair = await _restAPIRepository.fetchSaunaPair(saunaId: credentials.item2);
      final token = _saunaPair?.token;

      assert(_saunaPair != null, '_saunaPair can\'t be null');
      assert(token != null, 'token can\'t be null');

      if (_saunaPair == null || token == null) return;

      final result = await _restAPIRepository.fetchSaunaNetwork(saunaId: credentials.item2);
      _network = result;
      _setupQRCodeData();
    } catch (error, stackTrace) {
      _logger.e('Error loading _fetchSaunaPair', error, stackTrace);
    }
  }

  void _setupQRCodeData() {
    final saunaIdentity = _saunaStore.saunaIdentity;
    final saunaId = saunaIdentity?.id;
    final token = _saunaPair?.token;
    final address = _network?.mode == NetworkMode.wifi ? _network?.wifi?.address : _network?.ethernet?.address;

    assert(saunaIdentity != null, 'saunaIdentity can\'t be null');
    assert(saunaId != null, 'saunaId can\'t be null');
    assert(token != null, 'token can\'t be null');
    assert(address != null, 'address can\'t be null');

    if (saunaIdentity == null || token == null || saunaId == null || address == null) return;

    _qrCodeData = QRCodeData(
      saunaId: saunaId,
      deviceToken: token,
      ip: address,
    );
    _qrCode = json.encode(_qrCodeData.toJson());
    _isLoading = false;
    _startTimer();
  }

  @action
  Future<void> retry() async {
    final isInternetConnected = _saunaStore.isWifiConnected || _saunaStore.isActiveEthernet;
    if (isInternetConnected) {
      _isInternetConnected = isInternetConnected;
      _fetchNetwork();
    }
  }
}
