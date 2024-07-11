import 'dart:async';

import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/mobx_provider.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/utils/sauna_saver_sleep_mode_utils.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:mobx/mobx.dart';

part 'screen_saver.store.g.dart';

class ScreenSaverStore = _ScreenSaverStoreBase with _$ScreenSaverStore;

abstract class _ScreenSaverStoreBase with Store, Disposable {
  final _saunaLocalStorageStore = locator<SaunaLocalStorageStore>();
  _ScreenSaverStoreBase();

  @readonly
  SaunaSaverSleepModeType _saunaSaverSleepModeType = SaunaSaverSleepModeType.saverMode;

  @readonly
  SaunaSaverSleepDuration _saunaSaverSleepDuration = SaunaSaverSleepDuration.oneMin;

  final _compositeReaction = CompositeReactionDisposer();

  Timer? _screenSaverTimer;

  @readonly
  bool _moveToCorrespondingTab = false;

  Future<void> fetchSaunaSaverMode() async {
    _saunaSaverSleepModeType = _saunaLocalStorageStore.saunaSaverSleepModeType;
    _saunaSaverSleepDuration = _saunaLocalStorageStore.saunaSaverSleepDuration;
    setupScreenSaverTimer();
  }

  @action
  Future<void> setSaunaSaverSleepModeType(SaunaSaverSleepModeType saunaSaverSleepModeType) async {
    _saunaSaverSleepModeType = saunaSaverSleepModeType;
    _saunaLocalStorageStore.setAppSaunaSaverSettings(
      saunaSaverSleepModeType: saunaSaverSleepModeType,
      saunaSaverSleepDuration: _saunaSaverSleepDuration,
    );
  }

  @action
  Future<void> setSaunaSaverSleepDuration(SaunaSaverSleepDuration saunaSaverSleepDuration) async {
    _saunaSaverSleepDuration = saunaSaverSleepDuration;
    _saunaLocalStorageStore.setAppSaunaSaverSettings(
      saunaSaverSleepModeType: _saunaSaverSleepModeType,
      saunaSaverSleepDuration: saunaSaverSleepDuration,
    );
  }

  void setupScreenSaverTimer() {
    _screenSaverTimer?.cancel();
    _screenSaverTimer = null;
    _moveToCorrespondingTab = false;

    if (_saunaSaverSleepModeType != SaunaSaverSleepModeType.keepScreenOn) {
      _screenSaverTimer ??= Timer.periodic(Duration(minutes: _saunaSaverSleepDuration.timeDuration), (Timer timer) {
        _moveToCorrespondingTab = true;
      });
    }
  }

  void cancelScreenSaverTimer() {
    _screenSaverTimer?.cancel();
    _screenSaverTimer = null;
    _moveToCorrespondingTab = false;
  }

  @override
  void dispose() {
    _compositeReaction.dispose();
    _screenSaverTimer?.cancel();
    super.dispose();
  }
}
