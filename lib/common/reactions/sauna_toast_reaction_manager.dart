import 'package:found_space_flutter_rest_api/models/models.dart' as rest_api_models;
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/widgets/sauna_toast.dart';
import 'package:found_space_flutter_web_application/main.dart';
import 'package:mobx/mobx.dart';

class SaunaToastReactionManager {
  final _reaction = CompositeReactionDisposer();

  final SaunaStore _saunaStore;

  SaunaToastReactionManager(this._saunaStore);

  bool _firstReactionTriggered = false;

  void initReactions() {
    _reaction.dispose(); // Dispose of any existing reactions

    _reaction.add(reaction(
      (_) => _saunaStore.wifiState,
      (rest_api_models.WifiState wifiState) {
        switch (wifiState) {
          case rest_api_models.WifiState.active:
            _showWifiToast(isSucceed: true);
            break;
          case rest_api_models.WifiState.unknown:
          case rest_api_models.WifiState.activating:
            break;
          case rest_api_models.WifiState.deactivated:
          case rest_api_models.WifiState.inactive:
          case rest_api_models.WifiState.neverActivated:
            _showWifiToast();
            break;
        }
        _firstReactionTriggered = true;
      },
    ));

    _reaction.add(reaction(
      (_) => _saunaStore.isFactoryReset,
      (bool? isFactoryReset) {
        if (isFactoryReset == null) return;
        _showFactoryResetToast(isFactoryReset);
      },
    ));

    _reaction.add(reaction(
      (_) => _saunaStore.saunaUpdateState,
      (rest_api_models.SaunaUpdateState? saunaUpdateState) {
        if (saunaUpdateState == null) return;
        _showSaunaUpdateToast(saunaUpdateState);
      },
    ));
  }

  void disposeReactions() {
    _reaction.dispose();
  }

  void _showWifiToast({bool isSucceed = false}) {
    if (!_firstReactionTriggered) return;
    if (_saunaStore.wifiName.isEmpty) return;

    final type = isSucceed ? ToastType.message : ToastType.error;
    final message = isSucceed
        ? 'Successfully connected to the network ${_saunaStore.wifiName}'
        : 'Unable to connect to the network ${_saunaStore.wifiName}';
    fToast.showSaunaToast(type: type, message: message);
  }

  void _showFactoryResetToast(bool isFactoryReset) {
    final type = isFactoryReset ? ToastType.message : ToastType.error;
    final message = isFactoryReset ? 'The sauna settings have been reseted' : 'An error has occurred';

    fToast.showSaunaToast(type: type, message: message);
  }

  void _showSaunaUpdateToast(rest_api_models.SaunaUpdateState? saunaUpdateState) {
    if (saunaUpdateState == null) return;

    switch (saunaUpdateState) {
      case rest_api_models.SaunaUpdateState.unknown:
      case rest_api_models.SaunaUpdateState.standby:
      case rest_api_models.SaunaUpdateState.writing:
      case rest_api_models.SaunaUpdateState.downloading:
      case rest_api_models.SaunaUpdateState.refresh:
        break;
      case rest_api_models.SaunaUpdateState.success:
        fToast.showSaunaToast(
          type: ToastType.message,
          message: 'The firmware version ${_saunaStore.firmwareVersion} has been installed',
        );
        break;
      case rest_api_models.SaunaUpdateState.failed:
        fToast.showSaunaToast(type: ToastType.error, message: 'An error has occurred while firmware updating');
        break;
    }
  }
}
