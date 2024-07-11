import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:found_space_flutter_web_application/common/found_space_constants.dart';
import 'package:found_space_flutter_web_application/common/mobx_provider.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:mobx/mobx.dart';

part 'sauna_security_pin_page.store.g.dart';

enum SaunaSecurityPinPageState {
  create,
  change,
  verifyPairing,
  verifySettings;

  String? get successToastMessage {
    switch (this) {
      case SaunaSecurityPinPageState.create:
        return 'PIN has been successfully created';
      case SaunaSecurityPinPageState.change:
        return 'PIN has been successfully changed';
      case SaunaSecurityPinPageState.verifyPairing:
      case SaunaSecurityPinPageState.verifySettings:
        return null;
    }
  }
}

enum SaunaSecurityPinPageAction {
  create,
  verify,
  current,
  newPin,
  verifyNewPin,
  verifySecurityPin;

  String get title {
    switch (this) {
      case SaunaSecurityPinPageAction.create:
        return 'Create your PIN';
      case SaunaSecurityPinPageAction.verify:
        return 'Verify your PIN';
      case SaunaSecurityPinPageAction.current:
        return 'Enter current PIN';
      case SaunaSecurityPinPageAction.newPin:
        return 'Enter your new PIN';
      case SaunaSecurityPinPageAction.verifyNewPin:
        return 'Verify your new PIN';
      case SaunaSecurityPinPageAction.verifySecurityPin:
        return 'Enter device PIN';
      default:
        return '';
    }
  }
}

class SaunaSecurityPinPageStore = _SaunaSecurityPinPageStoreBase with _$SaunaSecurityPinPageStore;

abstract class _SaunaSecurityPinPageStoreBase with Store, Disposable {
  final _saunaStore = locator<SaunaStore>();
  final _saunaLocalStorageStore = locator<SaunaLocalStorageStore>();

  final createSaunaSecurityPins = ObservableList<String>();

  final verifySaunaSecurityPins = ObservableList<String>();

  final currentSaunaSecurityPins = ObservableList<String>();

  final newPinSaunaSecurityPins = ObservableList<String>();

  final verifyNewPinSaunaSecurityPins = ObservableList<String>();

  final verifySecurityPins = ObservableList<String>();

  @readonly
  SaunaSecurityPinPageState _pageState = SaunaSecurityPinPageState.create;

  @readonly
  SaunaSecurityPinPageAction _pageAction = SaunaSecurityPinPageAction.create;

  @readonly
  bool? _isSucceed;

  @readonly
  bool _isDisabledState = false;

  Timer? _dismissPopupTimer;

  @readonly
  int _dismissPopupSecondsRemaining = FoundSpaceConstants.timeoutPopupDurationSecs;

  @readonly
  bool _isForgetScreenOpen = false;

  @action
  void setIsForgetScreenOpen(bool isForgetScreenOpen) {
    _isForgetScreenOpen = isForgetScreenOpen;
    if (_isForgetScreenOpen) {
      verifySecurityPins.clear();
    }
  }

  void startDismissPopupTimer() {
    if (_pageAction != SaunaSecurityPinPageAction.verifySecurityPin) return;

    _dismissPopupTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_dismissPopupSecondsRemaining > 0) {
        _dismissPopupSecondsRemaining--;
      } else {
        _dismissPopupSecondsRemaining == 0;
        cancelDismissPopupTimer();
      }
    });
  }

  void cancelDismissPopupTimer() {
    if (_pageAction != SaunaSecurityPinPageAction.verifySecurityPin) return;
    _dismissPopupTimer?.cancel();
    _dismissPopupSecondsRemaining = FoundSpaceConstants.timeoutPopupDurationSecs;
  }

  Timer? _timer;

  @readonly
  int _secondsRemaining = 10;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 1) {
        _secondsRemaining--;
        cancelDismissPopupTimer();
      } else {
        _secondsRemaining == 0;
        setIsDisabledState(false);
        _cancelTimer();
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _secondsRemaining = 10;
    startDismissPopupTimer();
  }

  @computed
  List<String> get securityPins {
    switch (_pageAction) {
      case SaunaSecurityPinPageAction.create:
        return createSaunaSecurityPins.toList();
      case SaunaSecurityPinPageAction.verify:
        return verifySaunaSecurityPins.toList();
      case SaunaSecurityPinPageAction.current:
        return currentSaunaSecurityPins.toList();
      case SaunaSecurityPinPageAction.newPin:
        return newPinSaunaSecurityPins.toList();
      case SaunaSecurityPinPageAction.verifyNewPin:
        return verifyNewPinSaunaSecurityPins.toList();
      case SaunaSecurityPinPageAction.verifySecurityPin:
        return verifySecurityPins.toList();
    }
  }

  @action
  void setSaunaSecurityPinPageState(SaunaSecurityPinPageState state) {
    _pageState = state;
    switch (state) {
      case SaunaSecurityPinPageState.create:
        _pageAction = SaunaSecurityPinPageAction.create;
        break;
      case SaunaSecurityPinPageState.change:
        _pageAction = SaunaSecurityPinPageAction.current;
        break;
      case SaunaSecurityPinPageState.verifyPairing:
      case SaunaSecurityPinPageState.verifySettings:
        _pageAction = SaunaSecurityPinPageAction.verifySecurityPin;
        startDismissPopupTimer();
        break;
    }
  }

  @action
  void setSaunaSecurityPinPageAction(SaunaSecurityPinPageAction action) {
    _pageAction = action;
  }

  @action
  void setSucceed(bool? isSucceed) {
    _isSucceed = isSucceed;
  }

  @action
  void setIsDisabledState(bool isDisabledState) {
    _isDisabledState = isDisabledState;
  }

  @action
  Future<void> setSecurityPin(String pin) async {
    switch (_pageAction) {
      case SaunaSecurityPinPageAction.create:
        if (createSaunaSecurityPins.length >= 6) {
          setSaunaSecurityPinPageAction(SaunaSecurityPinPageAction.verify);
          break;
        }
        createSaunaSecurityPins.add(pin);
        if (createSaunaSecurityPins.length == 6) {
          setSaunaSecurityPinPageAction(SaunaSecurityPinPageAction.verify);
          break;
        }
        break;
      case SaunaSecurityPinPageAction.verify:
        if (verifySaunaSecurityPins.length >= 6) return;
        verifySaunaSecurityPins.add(pin);
        if (verifySaunaSecurityPins.length == 6) {
          if (createSaunaSecurityPins.join() == verifySaunaSecurityPins.join()) {
            await _saunaLocalStorageStore.setSaunaSecurityPin(pin: createSaunaSecurityPins.join());
            _isSucceed = true;
          } else {
            verifySaunaSecurityPins.clear();
            _isSucceed = false;
          }
        }
        break;
      case SaunaSecurityPinPageAction.current:
        if (currentSaunaSecurityPins.length >= 6) {
          if (currentSaunaSecurityPins.join() == _saunaLocalStorageStore.currentSecurityPin) {
            setSaunaSecurityPinPageAction(SaunaSecurityPinPageAction.newPin);
          }
          break;
        }
        currentSaunaSecurityPins.add(pin);
        if (currentSaunaSecurityPins.length == 6) {
          if (currentSaunaSecurityPins.join() == _saunaLocalStorageStore.currentSecurityPin) {
            setSaunaSecurityPinPageAction(SaunaSecurityPinPageAction.newPin);
          } else {
            final masterPin = _generatePin(saunaId: _saunaStore.saunaId ?? '', digitLength: 6);
            if (masterPin == currentSaunaSecurityPins.join()) {
              setSaunaSecurityPinPageAction(SaunaSecurityPinPageAction.newPin);
            } else {
              currentSaunaSecurityPins.clear();
              _isSucceed = false;
            }
          }
        }
        break;
      case SaunaSecurityPinPageAction.newPin:
        if (newPinSaunaSecurityPins.length >= 6) {
          setSaunaSecurityPinPageAction(SaunaSecurityPinPageAction.verifyNewPin);
          break;
        }
        newPinSaunaSecurityPins.add(pin);
        if (newPinSaunaSecurityPins.length == 6) {
          setSaunaSecurityPinPageAction(SaunaSecurityPinPageAction.verifyNewPin);
        }
        break;
      case SaunaSecurityPinPageAction.verifyNewPin:
        if (verifyNewPinSaunaSecurityPins.length >= 6) return;
        verifyNewPinSaunaSecurityPins.add(pin);
        if (verifyNewPinSaunaSecurityPins.length == 6) {
          if (newPinSaunaSecurityPins.join() == verifyNewPinSaunaSecurityPins.join()) {
            await _saunaLocalStorageStore.setSaunaSecurityPin(pin: verifyNewPinSaunaSecurityPins.join());
            _isSucceed = true;
          } else {
            verifyNewPinSaunaSecurityPins.clear();
            _isSucceed = false;
          }
        }
        break;
      case SaunaSecurityPinPageAction.verifySecurityPin:
        if (verifySecurityPins.length >= 6) return;
        verifySecurityPins.add(pin);
        if (verifySecurityPins.length == 6) {
          if (verifySecurityPins.join() == _saunaLocalStorageStore.currentSecurityPin) {
            _isSucceed = true;
          } else {
            final masterPin = _generatePin(saunaId: _saunaStore.saunaId ?? '', digitLength: 6);
            if (masterPin == verifySecurityPins.join()) {
              _isSucceed = true;
            } else {
              _startTimer();
              verifySecurityPins.clear();
              setIsDisabledState(true);
            }
          }
        }
        break;
    }
  }

  String? _generatePin({required String saunaId, required int digitLength}) {
    if (digitLength <= 0) {
      // Ensure the digit length is a positive value
      return null;
    }
    final data = utf8.encode(saunaId);

    final digest = sha256.convert(data);

    // Convert the digest to a hexadecimal string
    final hexString = digest.toString();

    // Filter out non-numeric characters
    final numericString = hexString.replaceAll(RegExp(r'[^0-9]'), '');

    // Reverse to add complexity
    final reversedNumericString = numericString.split('').reversed.join();

    // Take the first 'digitLength' characters of the numeric string
    final endIndex = digitLength.clamp(0, reversedNumericString.length);
    final pin = reversedNumericString.substring(0, endIndex);

    return pin;
  }

  @action
  void removeSecurityPin() {
    switch (_pageAction) {
      case SaunaSecurityPinPageAction.create:
        if (createSaunaSecurityPins.isEmpty) {
          setSaunaSecurityPinPageAction(SaunaSecurityPinPageAction.create);
          break;
        }
        createSaunaSecurityPins.removeLast();
        break;
      case SaunaSecurityPinPageAction.verify:
        if (verifySaunaSecurityPins.isEmpty) {
          setSaunaSecurityPinPageAction(SaunaSecurityPinPageAction.create);
          break;
        }
        verifySaunaSecurityPins.removeLast();
        break;
      case SaunaSecurityPinPageAction.current:
        if (currentSaunaSecurityPins.isEmpty) {
          setSaunaSecurityPinPageAction(SaunaSecurityPinPageAction.current);
          break;
        }
        currentSaunaSecurityPins.removeLast();
        break;
      case SaunaSecurityPinPageAction.newPin:
        if (newPinSaunaSecurityPins.isEmpty) {
          setSaunaSecurityPinPageAction(SaunaSecurityPinPageAction.current);
          break;
        }
        newPinSaunaSecurityPins.removeLast();
        break;
      case SaunaSecurityPinPageAction.verifyNewPin:
        if (verifyNewPinSaunaSecurityPins.isEmpty) {
          setSaunaSecurityPinPageAction(SaunaSecurityPinPageAction.newPin);
          break;
        }
        verifyNewPinSaunaSecurityPins.removeLast();
        break;
      case SaunaSecurityPinPageAction.verifySecurityPin:
        if (verifySecurityPins.isEmpty) break;
        verifySecurityPins.removeLast();
        break;
    }
  }
}
