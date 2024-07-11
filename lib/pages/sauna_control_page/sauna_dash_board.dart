import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/found_space_router.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/sauna_properties_extension.dart';
import 'package:found_space_flutter_web_application/common/reactions/sauna_toast_reaction_manager.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_bluetooth_store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/common/store/screen_saver.store.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/common/widgets/sauna_toast.dart';
import 'package:found_space_flutter_web_application/main.dart';
import 'package:found_space_flutter_web_application/pages/sauna_bluetooth_page/sauna_bluetooth_page.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_bottom_bar.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_brightness_button.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_menu_button.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_page_top_bar.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_volume_button.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_device_control.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_programs.dart';
import 'package:found_space_flutter_web_application/pages/sauna_firmware_update_page/sauna_firmware_update_page.dart';
import 'package:found_space_flutter_web_application/pages/sauna_home/store/sauna_home_page.store.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:found_space_flutter_web_application/src/chameleon_theme/widget/adaptive_chameleon_widget.dart';

import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class SaunaDashBoardPage extends StatefulWidget {
  final SaunaHomePageStore store;
  const SaunaDashBoardPage({required this.store, Key? key}) : super(key: key);

  @override
  State<SaunaDashBoardPage> createState() => _SaunaDashBoardPageState();
}

class _SaunaDashBoardPageState extends State<SaunaDashBoardPage> with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();
  final _reaction = CompositeReactionDisposer();
  final _saunaStore = locator<SaunaStore>();
  final _saunaLocalStorageStore = locator<SaunaLocalStorageStore>();
  final _saunaBluetoothStore = locator<SaunaBluetoothStore>();
  late ScreenSize _screenSize;

  late SaunaToastReactionManager _reactionManager;

  @override
  void initState() {
    super.initState();
    _reactionManager = SaunaToastReactionManager(_saunaStore);

    reaction((_) => _saunaStore.selectedSaunaMenuType, (SaunaMenuType selectedSaunaMenuType) {
      widget.store.shouldShowPrograms = selectedSaunaMenuType == SaunaMenuType.programs;
    }).disposeWith(_reaction);

    reaction((_) => _saunaStore.shouldReloadProperties, (bool shouldReloadProperties) {
      if (shouldReloadProperties) {
        Future.delayed(const Duration(seconds: 3), () {
          fToast.showSaunaToast(type: ToastType.message, message: "System configuration reloaded!");
        });
      }
    }).disposeWith(_reaction);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      reaction(
        (_) => _saunaBluetoothStore.bluetoothParingState,
        (BluetoothParingState? bluetoothParingState) async {
          final state = bluetoothParingState ?? BluetoothParingState.none;
          final isAttemptParing = state == BluetoothParingState.attemptParing;
          if (isAttemptParing) {
            _saunaStore.setPopupType(type: PopupType.bluetooth);
            context.read<ScreenSaverStore>().cancelScreenSaverTimer();

            Future.delayed(const Duration(seconds: 1), () async {
              await Navigator.pushNamed(
                context,
                RouteGenerator.saunaBluetoothPage,
              );

              _saunaStore.setPopupType(type: PopupType.none);
              context.read<ScreenSaverStore>().setupScreenSaverTimer();
            });
          }
        },
        fireImmediately: true,
      ).disposeWith(_reaction);

      reaction(
        (_) => _saunaStore.showFirmwareUpdateDialog,
        (bool showFirmwareUpdateDialog) {
          if (showFirmwareUpdateDialog) {
            Navigator.pushNamed(
              context,
              RouteGenerator.saunaFirmwareUpdatePage,
              arguments: SaunaFirmwareUpdatePageType.updateAvailable,
            );
          }
        },
        fireImmediately: true,
      ).disposeWith(_reaction);

      reaction(
        (_) => _saunaStore.showForceUpdateDialog,
        (bool showForceUpdateDialog) {
          if (showForceUpdateDialog) {
            Navigator.pushNamed(
              context,
              RouteGenerator.saunaFirmwareUpdatePage,
              arguments: SaunaFirmwareUpdatePageType.forceUpdate,
            );
          }
        },
        fireImmediately: true,
      ).disposeWith(_reaction);

      reaction(
        (_) => _saunaLocalStorageStore.isNightMode,
        (bool isNightMode) {
          AdaptiveChameleonTheme.of(context).changeThemeMode(dark: isNightMode);
        },
        fireImmediately: true,
      ).disposeWith(_reaction);

      if (rootNavigationKey.currentContext != null) {
        fToast.init(rootNavigationKey.currentContext!);

        _reactionManager.initReactions();
      }
    });
  }

  @override
  void dispose() {
    _reactionManager.disposeReactions();
    _scrollController.dispose();
    _reaction.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _screenSize = Utils.getScreenSize(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: Theme.of(context).colorScheme.backgroundGradientColors,
          ),
        ),
        child: Observer(
          builder: (context) {
            return Stack(
              children: [
                Column(
                  children: [
                    SaunaControlPageTopBar(
                      saunaStore: _saunaStore,
                      saunaLocalStorageStore: _saunaLocalStorageStore,
                      saunaBluetoothStore: _saunaBluetoothStore,
                    ),
                    SizedBox(height: _screenSize.getHeight(min: 30, max: 46)),
                    Expanded(
                      child: _buildHomePageStack(),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SaunaControlVolumeButton(saunaControlPageStore: widget.store),
                    SaunaControlBrightnessButton(saunaControlPageStore: widget.store),
                    _buildLeftSideButtonAndTimeDateWidget(),
                  ],
                ),
                SaunaControlMenuButton(saunaControlPageStore: widget.store),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLeftSideButtonAndTimeDateWidget() {
    final theme = Theme.of(context).colorScheme;
    return Observer(
      builder: (_) {
        final dateFormat = _saunaLocalStorageStore.defaultConvention.dateFormat;
        final currentDateTime = dateFormat.format(_saunaStore.currentDateTime ?? DateTime.now());
        final settingsMenuSelected = _saunaStore.selectedSaunaMenuType == SaunaMenuType.settings;
        return Padding(
          padding: EdgeInsets.only(left: 12, top: _screenSize.getHeight(min: 20, max: 24)),
          child: Container(
            height: _screenSize.getWidth(min: 60, max: 72),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentDateTime,
                  style: TextStyle(
                    fontSize: _screenSize.getFontSize(min: 16, max: 20),
                    fontWeight: FontWeight.w500,
                    color: theme.iconColor,
                  ),
                ),
                if (settingsMenuSelected)
                  FeedbackSoundWrapper(
                    onTap: () async {
                      _saunaStore.setPopupType(type: PopupType.dateAndTime);
                      context.read<ScreenSaverStore>().cancelScreenSaverTimer();
                      await Navigator.pushNamed(
                        context,
                        RouteGenerator.saunaDateAndTimePage,
                      );
                      _saunaStore.setPopupType(type: PopupType.none);
                      context.read<ScreenSaverStore>().setupScreenSaverTimer();
                    },
                    child: Container(
                      width: _screenSize.getHeight(min: 38, max: 44),
                      height: _screenSize.getHeight(min: 38, max: 44),
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: _screenSize.getHeight(min: 24, max: 32),
                        height: _screenSize.getHeight(min: 24, max: 32),
                        child: SvgPicture.asset(
                          Assets.smallSettings.assetName,
                          color: theme.iconColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomePageStack() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: widget.store.shouldShowPrograms
          ? SaunaPrograms()
          : Column(
              children: [
                const SaunaDeviceControl(),
                SizedBox(height: _screenSize.getHeight(min: 34, max: 54)),
                SaunaControlBottomBar(
                  onButtonTap: (buttonType) async {
                    _saunaStore.setPopupType(type: PopupType.none);
                    context.read<ScreenSaverStore>().cancelScreenSaverTimer();
                    await Navigator.pushNamed(
                      context,
                      RouteGenerator.saunaControlPopupPage,
                      arguments: SaunaControlPopupPageArguments(
                        saunaBottomButton: buttonType,
                        saunaHomePageStore: widget.store,
                      ),
                    );
                    context.read<ScreenSaverStore>().setupScreenSaverTimer();
                  },
                ),
              ],
            ),
    );
  }
}
