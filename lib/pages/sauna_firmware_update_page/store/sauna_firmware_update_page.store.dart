import 'dart:async';
import 'package:found_space_flutter_web_application/common/found_space_constants.dart';
import 'package:mobx/mobx.dart';

import 'package:found_space_flutter_web_application/common/mobx_provider.dart';

part 'sauna_firmware_update_page.store.g.dart';

class SaunaFirmwareUpdatePageStore = _SaunaFirmwareUpdatePageStoreBase with _$SaunaFirmwareUpdatePageStore;

abstract class _SaunaFirmwareUpdatePageStoreBase with Store, Disposable {
  void setup() {
    startTimer();
  }

  late Timer _timer;

  @readonly
  int _secondsRemaining = FoundSpaceConstants.timeoutPopupDurationSecs;

  void startTimer() {
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
    _secondsRemaining = FoundSpaceConstants.timeoutPopupDurationSecs;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
