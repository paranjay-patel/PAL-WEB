import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/sauna_value_utils.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_bluetooth_store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_font.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_menu_button.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_page_common.dart';
import 'package:lottie/lottie.dart';
import 'package:mobx/mobx.dart';

class SaunaControlBottomBar extends StatefulWidget {
  final SaunaBottomButton? saunaBottomButton;
  final Function(SaunaBottomButton)? onButtonTap;
  final bool showInPopup;

  const SaunaControlBottomBar({
    Key? key,
    this.saunaBottomButton,
    this.onButtonTap,
    this.showInPopup = false,
  }) : super(key: key);

  @override
  State<SaunaControlBottomBar> createState() => _SaunaControlBottomBarState();
}

class _SaunaControlBottomBarState extends State<SaunaControlBottomBar> with TickerProviderStateMixin {
  late ScreenSize _screenSize;
  late AnimationController _settingMenuAnimationController;
  late Animation<Offset> _settingMenuOffsetAnimation;
  late AnimationController _homeMenuAnimationController;
  late Animation<Offset> _homeMenuOffsetAnimation;

  final _reaction = CompositeReactionDisposer();
  final _saunaStore = locator<SaunaStore>();
  final _saunaLocalStorageStore = locator<SaunaLocalStorageStore>();
  final _saunaBluetoothStore = locator<SaunaBluetoothStore>();

  @override
  void initState() {
    super.initState();
    // Setting Menu animation setup
    _settingMenuAnimationController = AnimationController(
      vsync: this,
      duration: widget.showInPopup ? Duration.zero : const Duration(milliseconds: 500),
    );
    _settingMenuOffsetAnimation = Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
      _settingMenuAnimationController,
    );

    // Home Menu Animation setup
    _homeMenuAnimationController = AnimationController(
      vsync: this,
      duration: widget.showInPopup ? Duration.zero : const Duration(milliseconds: 500),
    );
    _homeMenuOffsetAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(-1.0, 0.0)).animate(
      _homeMenuAnimationController,
    );

    reaction<SaunaMenuType>((_) => _saunaStore.selectedSaunaMenuType, (saunaMenuType) {
      // Update menus and animation
      if (saunaMenuType == SaunaMenuType.programs) return;
      if (saunaMenuType == SaunaMenuType.settings) {
        _settingMenuAnimationController.forward();
        _homeMenuAnimationController.forward();
      } else {
        _settingMenuAnimationController.reverse();
        _homeMenuAnimationController.reverse();
      }
    }, fireImmediately: true)
        .disposeWith(_reaction);
  }

  @override
  void dispose() {
    _reaction.dispose();
    _settingMenuAnimationController.dispose();
    _homeMenuAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = Utils.getScreenSize(context);

    return Observer(
      builder: (context) {
        final homePageMenu = _saunaStore.homePageMenu;
        final settingMenu = _saunaStore.settingMenus;
        return Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 24),
          child: SizedBox(
            height: _bottomBarHeight,
            width: double.infinity,
            child: Stack(
              children: [
                SlideTransition(
                  position: _homeMenuOffsetAnimation,
                  child: ListView.builder(
                    shrinkWrap: true,
                    clipBehavior: Clip.none,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: homePageMenu.length,
                    itemBuilder: (context, index) {
                      final saunaBottomButton = homePageMenu[index];
                      return _buildBaseButton(saunaBottomButton, length: homePageMenu.length);
                    },
                  ),
                ),
                SlideTransition(
                  position: _settingMenuOffsetAnimation,
                  child: ListView.builder(
                    shrinkWrap: true,
                    clipBehavior: Clip.none,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: settingMenu.length,
                    itemBuilder: (context, index) {
                      final saunaBottomButton = settingMenu[index];
                      return _buildBaseButton(
                        saunaBottomButton,
                        length: settingMenu.length,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBaseButton(SaunaBottomButton saunaBottomButton, {required int length}) {
    final theme = Theme.of(context).colorScheme;
    final isShrinkLayout = length > 5;
    final padding = (length * (isShrinkLayout ? 16 : 20)) + 28;
    final menuWidth = ((MediaQuery.of(context).size.width - padding) / length);

    return Observer(
      builder: (context) {
        return FeedbackSoundWrapper(
          onTap: () {
            final onTap = widget.onButtonTap;
            if (onTap == null) return;
            onTap.call(saunaBottomButton);
          },
          child: Container(
            height: _bottomBarHeight,
            width: menuWidth,
            margin: EdgeInsets.symmetric(horizontal: isShrinkLayout ? 8 : 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 12, max: 20)),
              color: theme.buttonBackgroundColor,
              boxShadow: theme.saunaControlPageButtonShadow,
              border: Border.all(
                width: 2,
                color: saunaBottomButton == widget.saunaBottomButton ? theme.selectedBorderColor : Colors.transparent,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: _selectionIndicatorWidth,
                  height: 2,
                  margin: const EdgeInsets.only(top: 8),
                  alignment: Alignment.center,
                  color: saunaBottomButton == widget.saunaBottomButton ? theme.selectedBorderColor : Colors.transparent,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!saunaBottomButton.shouldShowText)
                        Observer(builder: (context) {
                          final isAudioPlaying = _saunaBluetoothStore.isAudioPlaying;
                          final isLightOn = _saunaStore.isLightOn;

                          final isTransitoryState =
                              _saunaStore.isTransitoryState && saunaBottomButton == SaunaBottomButton.light;

                          if (isTransitoryState) {
                            return Lottie.asset(
                              Theme.of(context).colorScheme.saunaLightGIF,
                              animate: true,
                              repeat: true,
                              width: _iconHeight,
                              height: _iconHeight,
                            );
                          }

                          return SvgPicture.asset(
                            saunaBottomButton.iconName(context, isAudioPlaying: isAudioPlaying, isLightOn: isLightOn),
                            width: _iconHeight,
                            height: _iconHeight,
                          );
                        })
                      else
                        Container(
                          height: _iconHeight,
                          alignment: Alignment.center,
                          child: saunaBottomButton == SaunaBottomButton.programTime
                              ? RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${_saunaStore.remainingTime}',
                                        style: TextStyle(
                                          color: theme.titleTextColor,
                                          fontSize: _screenSize.getFontSize(min: 34, max: 44),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: ThemeFont.defaultFontFamily,
                                        ),
                                      ),
                                      TextSpan(
                                        text: _saunaStore.remainingTime > 1.0 ? 'mins' : 'min',
                                        style: TextStyle(
                                          color: theme.titleTextColor,
                                          fontSize: _screenSize.getFontSize(min: 18, max: 28),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: ThemeFont.defaultFontFamily,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Text(
                                  _title(saunaBottomButton),
                                  style: TextStyle(
                                    fontSize: _titleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: theme.titleTextColor,
                                    height: 0.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      const SizedBox(height: 6),
                      Observer(builder: (context) {
                        final isAudioPlaying = _saunaBluetoothStore.isAudioPlaying;
                        final isTransitoryState =
                            _saunaStore.isTransitoryState && saunaBottomButton == SaunaBottomButton.light;
                        return Text(
                          subtitleText(
                            isAudioPlaying: isAudioPlaying,
                            buttonType: saunaBottomButton,
                            isTransitoryState: isTransitoryState,
                          ),
                          style: TextStyle(
                            fontSize: _subtitleFontSize,
                            fontWeight: isTransitoryState ? FontWeight.w600 : FontWeight.normal,
                            color: isTransitoryState ? theme.titleTextColor : theme.subTitleTextColor,
                          ),
                          textAlign: TextAlign.center,
                        );
                      })
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  String _title(SaunaBottomButton buttonType) {
    switch (buttonType) {
      case SaunaBottomButton.temperature:
        final currentAverageTemperature = _saunaStore.currentAverageTemperature;
        final temperatureScale = _saunaLocalStorageStore.temperatureScale;
        return SaunaValueUtils.getAverageTemperature(currentAverageTemperature, temperatureScale: temperatureScale);
      case SaunaBottomButton.programTime:
        final remainingTime = _saunaStore.remainingTime;
        return SaunaValueUtils.getRemainingTime(remainingTime);
      default:
        return "";
    }
  }

  String subtitleText({
    bool isAudioPlaying = false,
    bool isTransitoryState = false,
    required SaunaBottomButton buttonType,
  }) {
    switch (buttonType) {
      case SaunaBottomButton.temperature:
        final targetTemperature = _saunaStore.targetTemperature.round();
        final temperatureScale = _saunaLocalStorageStore.temperatureScale;
        return SaunaValueUtils.getTargetTemperature(targetTemperature, temperatureScale: temperatureScale);
      case SaunaBottomButton.programTime:
        final targetTimer = _saunaStore.targetTimer;
        return SaunaValueUtils.getTargetTimer(targetTimer);
      case SaunaBottomButton.light:
        return isTransitoryState ? 'Lights: Waiting' : 'Lights';
      case SaunaBottomButton.audio:
        return isAudioPlaying ? 'Audio: On' : 'Audio: Off';
      case SaunaBottomButton.saverAndSleepMode:
        return 'Focus & Sleep Mode';
      case SaunaBottomButton.colorTheme:
        final isNightMode = _saunaLocalStorageStore.isNightMode;
        return 'Color Theme: ${isNightMode ? 'Dark' : 'Light'}';
      case SaunaBottomButton.advancedSettings:
        return 'Advanced Settings';
      case SaunaBottomButton.debug:
        return 'Debug';
    }
  }

  String _lightOnOffValue(bool state) {
    return state ? "on" : "off";
  }

  double get _selectionIndicatorWidth {
    return _screenSize.getWidth(min: 64, max: 80);
  }

  double get _bottomBarHeight {
    return _screenSize.getHeight(min: 120, max: 184);
  }

  double get _iconHeight {
    return _screenSize.getHeight(min: 50, max: 80);
  }

  double get _titleFontSize {
    return _screenSize.getFontSize(min: 34, max: 44);
  }

  double get _subtitleFontSize {
    return _screenSize.getFontSize(min: 12, max: 20);
  }
}
