import 'package:mobx/mobx.dart';
import 'dart:async';
import 'package:found_space_flutter_web_application/common/mobx_provider.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_page_common.dart';

part 'sauna_home_page.store.g.dart';

class SaunaHomePageStore = _SaunaHomePageStoreBase with _$SaunaHomePageStore;

abstract class _SaunaHomePageStoreBase with Store, Disposable {
  Timer? _dateAndTimeTimer;

  @readonly
  SaunaMode _selectedSaunaMode = SaunaMode.dashboard;

  @observable
  bool isExpandedBrightnessBar = false;

  @observable
  bool isExpandedMenuButton = false;

  @readonly
  bool _isSettingTapped = false;

  @observable
  bool shouldShowPrograms = false;

  @readonly
  bool _isExpandedVolumeBar = false;

  @action
  void setExpandedVolumeBar(bool isExpanded) => _isExpandedVolumeBar = isExpanded;

  @action
  Future<void> setSelectedSaunaMode(SaunaMode saunaMode) async {
    _selectedSaunaMode = saunaMode;
  }

  @action
  Future<void> settingButtonTapped() async {
    _isSettingTapped = !_isSettingTapped;
  }

  void setSaunaMode(SaunaMode mode) => _selectedSaunaMode = mode;

  @override
  void dispose() {
    _dateAndTimeTimer?.cancel();
    super.dispose();
  }
}
