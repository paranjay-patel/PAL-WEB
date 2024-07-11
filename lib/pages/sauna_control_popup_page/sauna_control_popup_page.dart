import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as listener;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/found_space_router.dart';
import 'package:found_space_flutter_web_application/common/screen_utils.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/store/sauna_control_popup_page.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_bottom_bar.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_page_common.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_volume_button.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/widgets/sauna_sounds/sauna_sounds_tab_page.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/widgets/sauna_color_theme_control.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/widgets/sauna_control_audio_tab_bar.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/widgets/sauna_control_light_tab_bar.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/widgets/sauna_debug_mode.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/widgets/sauna_advance_settings/sauna_advance_settings_mode.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/widgets/sauna_light_control.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/widgets/sauna_saver_sleep_mode.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/store/sauna_wifi.store.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:mobx/mobx.dart';

import 'widgets/sauna_sounds/sauna_music_tab_page.dart';
import 'widgets/sauna_temperature_control.dart';
import 'widgets/sauna_timer_control.dart';

class SaunaControlPopupPage extends StatefulWidget {
  const SaunaControlPopupPage({Key? key}) : super(key: key);

  @override
  State<SaunaControlPopupPage> createState() => _SaunaControlPopupPageState();
}

class _SaunaControlPopupPageState extends State<SaunaControlPopupPage> {
  SaunaControlPopupPageArguments? _arguments;
  late ColorScheme _theme;
  late ScreenSize _screenSize;
  final _textEditingController = TextEditingController();
  final _store = SaunaControlPopupPageStore();
  final _wifiStore = SaunaWifiStore();
  final _reaction = CompositeReactionDisposer();
  final _saunaStore = locator<SaunaStore>();
  final _saunaLocalStorageStore = locator<SaunaLocalStorageStore>();

  @override
  void initState() {
    super.initState();

    reaction<int>(
      (_) => _store.secondsRemaining,
      (secondsRemaining) {
        if (secondsRemaining == 0) {
          _store.cancelTimer();
          Navigator.pop(context);
        }
      },
    ).disposeWith(_reaction);
  }

  @override
  void dispose() {
    _store.dispose();
    _wifiStore.dispose();
    _textEditingController.dispose();
    _reaction.dispose();
    super.dispose();
  }

  void _resetTimer() {
    _store.cancelTimer();
    _store.startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_arguments != null) return;
    _arguments ??= ModalRoute.of(context)!.settings.arguments as SaunaControlPopupPageArguments?;
    final arguments = _arguments;
    if (arguments != null) {
      _store.setArgument(arguments);
      reaction<PopupType>(
        (_) => _saunaStore.popupType,
        (type) {
          if (type == PopupType.bluetooth) {
            Navigator.of(context).pop();
          }
        },
        fireImmediately: true,
      ).disposeWith(_reaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context).colorScheme;
    _screenSize = Utils.getScreenSize(context);
    return Scaffold(
      backgroundColor: _theme.mainPopupBackgroundColor,
      body: listener.Listener(
        onPointerDown: (_) => _resetTimer(),
        onPointerMove: (_) => _resetTimer(),
        onPointerUp: (_) => _resetTimer(),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            color: _theme.mainPopupBaseBackgroundColor,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 48),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildArrowButton(SaunaControlPopupPageButtonArrow.backward),
                              SizedBox(width: _screenSize.getWidth(min: 20, max: 24)),
                              _buildCenterContent(),
                              SizedBox(width: _screenSize.getWidth(min: 20, max: 24)),
                              _buildArrowButton(SaunaControlPopupPageButtonArrow.forward),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Observer(builder: (context) {
                          return SaunaControlBottomBar(
                            saunaBottomButton: _store.selectedSaunaBottomButton,
                            showInPopup: true,
                            onButtonTap: (saunaBottomButton) async {
                              _store.setSelectedSaunaBottomButton(saunaBottomButton);
                            },
                          );
                        }),
                      ],
                    ),
                    _buildVolumeButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVolumeButton() {
    return Observer(builder: (_) {
      final isAudioControl = _store.selectedSaunaBottomButton == SaunaBottomButton.audio;
      final saunaHomePageStore = _arguments?.saunaHomePageStore;

      if (isAudioControl && saunaHomePageStore != null) {
        return SaunaControlVolumeButton(saunaControlPageStore: saunaHomePageStore);
      }

      return const SizedBox();
    });
  }

  Widget _buildArrowButton(SaunaControlPopupPageButtonArrow saunaControlPopupPageButtonArrow) {
    return Observer(
      builder: (context) {
        switch (saunaControlPopupPageButtonArrow) {
          case SaunaControlPopupPageButtonArrow.backward:
            if (!_store.shouldShowBackArrow) return SizedBox(width: _screenSize.getWidth(min: 60, max: 72));
            break;
          case SaunaControlPopupPageButtonArrow.forward:
            if (!_store.shouldShowForwardArrow) return SizedBox(width: _screenSize.getWidth(min: 60, max: 72));
            break;
          default:
        }

        return FeedbackSoundWrapper(
          onTap: () async {
            final saunaBottomButton = _store.selectedSaunaBottomButton;
            if (saunaBottomButton == null) return;
            switch (saunaControlPopupPageButtonArrow) {
              case SaunaControlPopupPageButtonArrow.backward:
                _store.setPrevSelectedSaunaBottomButton(saunaBottomButton);
                break;
              case SaunaControlPopupPageButtonArrow.forward:
                _store.setNextSelectedSaunaBottomButton(saunaBottomButton);
                break;
              default:
            }
          },
          child: Container(
            height: _screenSize.getHeight(min: 60, max: 72),
            width: _screenSize.getWidth(min: 60, max: 72),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: _theme.arrowBackgroundColor,
              boxShadow: _theme.saunaControlPageButtonShadow,
            ),
            alignment: Alignment.center,
            child: saunaControlPopupPageButtonArrow.icon.toSvgPicture(
              width: _screenSize.getWidth(min: 25, max: 32),
              height: _screenSize.getHeight(min: 25, max: 32),
              color: _theme.iconColor,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCenterContent() {
    return Observer(
      builder: (_) {
        final isAudioControl = _store.selectedSaunaBottomButton == SaunaBottomButton.audio;
        final isLightControl = _store.selectedSaunaBottomButton == SaunaBottomButton.light;
        final isAdvanceSettingsControl = _store.selectedSaunaBottomButton == SaunaBottomButton.advancedSettings;

        final showSpacing = isAudioControl || isLightControl || isAdvanceSettingsControl;

        return Center(
          child: InkWell(
            onTap: () {},
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: AspectRatio(
              aspectRatio: _screenSize.getWidth(min: 720, max: 820) / 572,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      _store.selectedSaunaBottomButton != SaunaBottomButton.audio
                          ? _screenSize.getHeight(min: 24, max: 32)
                          : 0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: _theme.popupBackgroundColor,
                      boxShadow: _theme.saunaControlPageButtonShadow,
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            _buildTitle(),
                            SizedBox(
                              height: _screenSize.getHeight(
                                min: showSpacing ? 10 : 14,
                                max: showSpacing ? 14 : 20,
                              ),
                            ),
                            _buildCenterControl(),
                            SizedBox(
                              height: _screenSize.getHeight(
                                min: showSpacing ? 0 : 28,
                                max: showSpacing ? 0 : 24,
                              ),
                            ),
                          ],
                        ),
                        _buildBottomWidget(),
                      ],
                    ),
                  ),
                  _buildCloseButton(),
                  _buildTimer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCenterControl() {
    final currentSelectedButton = _store.selectedSaunaBottomButton;
    if (currentSelectedButton == null) return const SizedBox();
    switch (currentSelectedButton) {
      case SaunaBottomButton.temperature:
        return SaunaTemperatureControl(store: _store);
      case SaunaBottomButton.programTime:
        return SaunaTimerControl(store: _store);
      case SaunaBottomButton.light:
        return SaunaLightControl(
          store: _store,
          key: Key(currentSelectedButton.name),
        );
      case SaunaBottomButton.audio:
        return Observer(builder: (context) {
          switch (_store.selectedAudioControlMenu) {
            case AudioControlMenu.sound:
              return const SaunaSoundsTabPage();
            case AudioControlMenu.music:
              return const SaunaMusicTabPage();
          }
        });
      case SaunaBottomButton.saverAndSleepMode:
        return const SaunaSavedSleepMode();
      case SaunaBottomButton.colorTheme:
        return SaunaColorThemeControl(store: _store);
      case SaunaBottomButton.advancedSettings:
        return SaunaAdvanceSettingsMode(
          store: _store,
          onPinTap: () {
            _store.cancelTimer();
          },
          onPinPageClosed: () {
            _store.startTimer();
          },
        );
      case SaunaBottomButton.debug:
        return const SaunaDebugMode();
      default:
        return const SizedBox();
    }
  }

  Widget _buildTimer() {
    return Observer(builder: (context) {
      final countdown = _store.secondsRemaining;
      if (countdown > 10 || countdown <= 0) return const SizedBox();

      return Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.only(
            top: _screenSize.getHeight(min: 20, max: 30),
            left: _screenSize.getHeight(min: 20, max: 30),
          ),
          child: Text(
            '$countdown',
            style: TextStyle(
              color: Theme.of(context).colorScheme.titleTextColor,
              fontSize: _screenSize.getFontSize(min: 16, max: 20),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      );
    });
  }

  Widget _buildTitle() {
    final isAudioControl = _store.selectedSaunaBottomButton == SaunaBottomButton.audio;
    final isLightControl = _store.selectedSaunaBottomButton == SaunaBottomButton.light;
    if (isLightControl) return _buildLightHeader();

    final padding = ScreenUtil.getWidth(context, 32);

    return Padding(
      padding: isAudioControl ? EdgeInsets.only(left: padding, right: padding) : const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isAudioControl)
            Expanded(
              child: Observer(builder: (context) {
                final isNightMode = _saunaLocalStorageStore.isNightMode;
                var text = _store.selectedSaunaBottomButton?.titleText(isNightMode: isNightMode) ?? '';
                if (_store.saunaFirmwarePopupType != SaunaFirmwarePopupType.none) {
                  return const SizedBox();
                }

                return Text(
                  text,
                  style: TextStyle(
                    color: _theme.titleTextColor,
                    fontSize: _screenSize.getFontSize(min: 18, max: 24),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                );
              }),
            ),
          if (isAudioControl)
            Expanded(
              child: SaunaControlAudioTabBar(
                store: _store,
                onTabTapped: (AudioControlMenu audioControlMenu) {
                  _store.setSelectedAudioControlMenu(audioControlMenu);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLightHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _saunaStore.saunaLightControlType.title,
          style: TextStyle(
            color: _theme.titleTextColor,
            fontSize: _screenSize.getFontSize(min: 18, max: 24),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        if (_saunaStore.saunaLightControlType.isRgb) ...[
          const SizedBox(height: 4),
          Text(
            "Please select a colour",
            style: TextStyle(
              color: _theme.wifiSubTitleTextColor,
              fontSize: _screenSize.getFontSize(min: 12, max: 16),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          )
        ],
        SizedBox(height: _screenSize.getHeight(min: 16, max: 20)),
        if (_saunaStore.saunaLightControlType.isSegmentController)
          SaunaControlLightTabBar(
            store: _store,
            onTabTapped: (SaunaLightTabType type) {
              _store.setSelectedSaunaLightTabType(type);
            },
          ),
      ],
    );
  }

  Widget _buildCloseButton() {
    return Positioned(
      top: _screenSize.getHeight(min: 20, max: 30),
      right: _screenSize.getWidth(min: 16, max: 20),
      child: FeedbackSoundWrapper(
        onTap: () {
          Navigator.pop(context);
        },
        child: SizedBox(
          width: _screenSize.getWidth(min: 40, max: 50),
          height: _screenSize.getHeight(min: 40, max: 50),
          child: Align(
            alignment: Alignment.center,
            child: Assets.close.toSvgPicture(
              width: _screenSize.getWidth(min: 20, max: 24),
              height: _screenSize.getHeight(min: 20, max: 24),
              color: _theme.iconColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomWidget() {
    final currentSelectedButton = _store.selectedSaunaBottomButton;
    switch (currentSelectedButton) {
      case SaunaBottomButton.temperature:
        return _IncreaseDecreaseButton(
          onButtonTap: (type) {
            if (type.isIncrementType) {
              _store.increaseTemperature();
            } else {
              _store.decreaseTemperature();
            }
          },
        );
      case SaunaBottomButton.programTime:
        return _IncreaseDecreaseButton(
          onButtonTap: (type) {
            if (type.isIncrementType) {
              _store.increaseTime();
            } else {
              _store.decreaseTime();
            }
          },
        );
      case SaunaBottomButton.light:
      case SaunaBottomButton.audio:
        return const SizedBox();
      default:
        return const SizedBox();
    }
  }
}

class _IncreaseDecreaseButton extends StatelessWidget {
  final Function(IncrementDecrementButtonType) onButtonTap;

  const _IncreaseDecreaseButton({Key? key, required this.onButtonTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIncreaseOrDecreaseButton(context),
          SizedBox(width: Utils.getScreenSize(context).getWidth(min: 160, max: 200)),
          _buildIncreaseOrDecreaseButton(context, type: IncrementDecrementButtonType.increment),
        ],
      ),
    );
  }

  Widget _buildIncreaseOrDecreaseButton(
    BuildContext context, {
    IncrementDecrementButtonType type = IncrementDecrementButtonType.decrement,
  }) {
    final theme = Theme.of(context).colorScheme;
    final screenSize = Utils.getScreenSize(context);
    return FeedbackSoundWrapper(
      onTap: () {
        onButtonTap.call(type);
      },
      child: Container(
        height: screenSize.getHeight(min: 60, max: 72),
        width: screenSize.getWidth(min: 60, max: 72),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theme.buttonColor,
          border: Border.all(color: theme.buttonBorderColor, width: 2),
        ),
        alignment: Alignment.center,
        child: (type.isIncrementType ? Assets.plus : Assets.minus).toSvgPicture(
          width: screenSize.getWidth(min: 25, max: 32),
          height: screenSize.getHeight(min: 25, max: 32),
          color: theme.iconColor,
        ),
      ),
    );
  }
}
