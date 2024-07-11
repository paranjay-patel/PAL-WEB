import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_rest_api/models/models.dart' as model;
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_bluetooth_store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/common/store/screen_saver.store.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_bluetooth_page/sauna_bluetooth_page.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/sauna_dash_board.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_menu_button.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_page_common.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/widgets/sauna_simple_mode_page.dart';
import 'package:found_space_flutter_web_application/pages/sauna_home/store/sauna_home_page.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_turned_off_mode/sauna_turned_off_mode.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _SaunaTabBarPageState createState() => _SaunaTabBarPageState();
}

class _SaunaTabBarPageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  final _saunaLocalStorageStore = locator<SaunaLocalStorageStore>();
  final _saunaBluetoothStore = locator<SaunaBluetoothStore>();
  final _store = SaunaHomePageStore();

  final _compositeReaction = CompositeReactionDisposer();

  late ScreenSaverStore _screenSaverStore;

  late ScreenSize _screenSize;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _screenSaverStore = context.read<ScreenSaverStore>();

    reaction((_) => _screenSaverStore.moveToCorrespondingTab, (bool moveToCorrespondingTab) {
      if (moveToCorrespondingTab) {
        switch (_screenSaverStore.saunaSaverSleepModeType) {
          case model.SaunaSaverSleepModeType.saverMode:
            _store.setSaunaMode(SaunaMode.simple);
            _tabController.animateTo(
              SaunaMode.values.indexOf(SaunaMode.simple),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
            );
            break;
          case model.SaunaSaverSleepModeType.sleepMode:
            _store.setSaunaMode(SaunaMode.turnOffScreen);
            _tabController.animateTo(
              SaunaMode.values.indexOf(SaunaMode.turnOffScreen),
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
            );
            break;
          case model.SaunaSaverSleepModeType.keepScreenOn:
            _store.setSaunaMode(SaunaMode.dashboard);
            break;
          case model.SaunaSaverSleepModeType.unknown:
            break;
        }
      }
    }).disposeWith(_compositeReaction);

    reaction(
      (_) => _saunaBluetoothStore.bluetoothParingState,
      (BluetoothParingState? bluetoothParingState) async {
        final state = bluetoothParingState ?? BluetoothParingState.none;
        final isAttemptParing = state == BluetoothParingState.attemptParing;
        if (isAttemptParing) {
          _store.setSaunaMode(SaunaMode.dashboard);
          _tabController.animateTo(
            SaunaMode.values.indexOf(SaunaMode.dashboard),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        }
      },
      fireImmediately: true,
    ).disposeWith(_compositeReaction);
  }

  @override
  void dispose() {
    super.dispose();
    _compositeReaction.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = Utils.getScreenSize(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SaunaDashBoardPage(store: _store),
              SaunaSimpleModePage(onTap: () {
                if (_saunaLocalStorageStore.isSecuritySettingsEnabled) {
                  locator<SaunaStore>().setSelectedMenuType(SaunaMenuType.saunaControl);
                }
                locator<SaunaStore>().setPopupType(type: PopupType.none);
                _store.setSaunaMode(SaunaMode.dashboard);
                _screenSaverStore.setupScreenSaverTimer();

                _tabController.animateTo(
                  SaunaMode.values.indexOf(SaunaMode.dashboard),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              }),
              SaunaTurnedOffModePage(
                onTap: () {
                  if (_saunaLocalStorageStore.isSecuritySettingsEnabled) {
                    locator<SaunaStore>().setSelectedMenuType(SaunaMenuType.saunaControl);
                  }
                  _store.setSaunaMode(SaunaMode.dashboard);
                  _screenSaverStore.setupScreenSaverTimer();
                  Future.delayed(const Duration(milliseconds: 200), () {
                    _tabController.animateTo(
                      SaunaMode.values.indexOf(SaunaMode.dashboard),
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                    );
                  });
                },
              ),
            ],
          ),
          Observer(builder: (context) {
            return Opacity(
              opacity: _store.selectedSaunaMode == SaunaMode.turnOffScreen ? 0.0 : 1.0,
              child: _buildTabBar(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: EdgeInsets.only(top: _screenSize.getHeight(min: 20, max: 24)),
      child: Container(
        height: _screenSize.getHeight(min: 60, max: 72),
        width: _screenSize.getWidth(min: 186, max: 220),
        decoration: BoxDecoration(
          color: _store.selectedSaunaMode.tabBarBackgroundColor(context),
          borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 14, max: 20)),
          boxShadow: _store.selectedSaunaMode.innerPageViewShadow(context),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 14, max: 20)),
            color: _store.selectedSaunaMode.buttonBackgroundColor(context),
            boxShadow: _store.selectedSaunaMode.saunaControlPageButtonShadow(context),
          ),
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          onTap: (index) {
            if (_saunaLocalStorageStore.isSecuritySettingsEnabled) {
              locator<SaunaStore>().setSelectedMenuType(SaunaMenuType.saunaControl);
            }
            locator<SaunaStore>().setPopupType(type: PopupType.none);
            final selectedTab = SaunaMode.values[index];
            _store.setSaunaMode(selectedTab);
            _screenSaverStore.setupScreenSaverTimer();
          },
          tabs: SaunaMode.values.map((tab) {
            return Tab(
              key: Key(tab.toString()),
              icon: tab.icon.toSvgPicture(
                width: _screenSize.getHeight(min: 24, max: 32),
                height: _screenSize.getHeight(min: 24, max: 32),
                color: _store.selectedSaunaMode.iconColor(context),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
