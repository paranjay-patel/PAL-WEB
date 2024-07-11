import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/flutter_vertical_slider.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/color_extension.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/inner_shadow.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/store/sauna_control_popup_page.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_page_common.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:lottie/lottie.dart';
import 'package:mobx/mobx.dart';

class SaunaLightControl extends StatefulWidget {
  final SaunaControlPopupPageStore store;
  const SaunaLightControl({Key? key, required this.store}) : super(key: key);

  @override
  State<SaunaLightControl> createState() => _SaunaLightControlState();
}

class _SaunaLightControlState extends State<SaunaLightControl> {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final selectedSaunaLightTabType = widget.store.selectedSaunaLightTabType;
      switch (selectedSaunaLightTabType) {
        case SaunaLightTabType.rgb:
          return _SaunaColourTherapyTabPage(store: widget.store);
        case SaunaLightTabType.mono:
          return _SaunaMonoLightTabPage(store: widget.store);
      }
    });
  }
}

class _SaunaColourTherapyTabPage extends StatefulWidget {
  final SaunaControlPopupPageStore store;
  const _SaunaColourTherapyTabPage({Key? key, required this.store}) : super(key: key);

  @override
  State<_SaunaColourTherapyTabPage> createState() => _SaunaColourTherapyTabPageState();
}

class _SaunaColourTherapyTabPageState extends State<_SaunaColourTherapyTabPage> {
  double _maxHeight = 0.0;

  Timer? _timer;
  final _saunaStore = locator<SaunaStore>();
  final _saunaLocalStorageStore = locator<SaunaLocalStorageStore>();

  @override
  void initState() {
    final activeRgbLight = _saunaStore.activeRgbLight;
    widget.store.setLightOpacity(activeRgbLight?.brightness ?? 0.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                _maxHeight = constraints.maxHeight;
                return Observer(
                  builder: (_) {
                    final colors = _saunaLocalStorageStore.colors;

                    final isTransitoryState = _saunaStore.isTransitoryState;

                    final activeRgbLight = _saunaStore.activeRgbLight;
                    final color = activeRgbLight?.color;
                    widget.store.setLightOpacity(activeRgbLight?.brightness ?? 0.0);

                    Color? selectedColor;
                    if (color != null && (activeRgbLight?.state ?? false)) {
                      selectedColor = Color.fromRGBO(color.r, color.g, color.b, 1.0);
                      _saunaLocalStorageStore.saveColor(selectedColor);
                    }
                    return SingleChildScrollView(
                      child: Container(
                        height: _maxHeight,
                        width: constraints.maxWidth,
                        alignment: Alignment.center,
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          children: colors.map(
                            (color) {
                              return SizedBox(
                                height: _maxHeight / 3,
                                width: constraints.maxWidth / 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: FeedbackSoundWrapper(
                                    onTap: () {
                                      final colorRGB = color.toColorRGB;
                                      final hasSelectedLight = color == selectedColor;
                                      _saunaStore.updateSaunaLight(
                                        colorRGB: colorRGB,
                                        state: hasSelectedLight ? !(activeRgbLight?.state ?? false) : true,
                                        brightness: activeRgbLight?.brightness ?? 1.0,
                                      );
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: color,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: color == selectedColor ? ThemeColors.grey40 : ThemeColors.grey30,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        if (color == selectedColor)
                                          Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black.withOpacity(.2),
                                            ),
                                            alignment: Alignment.center,
                                            child: isTransitoryState
                                                ? Lottie.asset(
                                                    Assets.lightBulb,
                                                    animate: true,
                                                    repeat: true,
                                                  )
                                                : Assets.light.toSvgPicture(
                                                    color: theme.lightSelectedColor,
                                                    width: 36,
                                                    height: 36,
                                                  ),
                                          )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                'Brightness',
                style: TextStyle(
                  color: theme.titleTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Observer(builder: (context) {
            final opacity = widget.store.lightOpacity;
            return SizedBox(
              width: double.infinity,
              height: 56,
              child: Stack(
                children: [
                  InnerShadow(
                    blur: 5,
                    color: theme.brightnessInnerShadowColor,
                    offset: const Offset(4, 4),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        color: theme.buttonBackgroundColor,
                      ),
                    ),
                  ),
                  VerticalSlider(
                    onChanged: (newValue) {
                      widget.store.setLightOpacity(newValue);
                      _timer?.cancel();

                      _timer = Timer(const Duration(seconds: 2), () {
                        _timer?.cancel();
                        final activeRgbLight = _saunaStore.activeRgbLight;
                        final colorRGB = activeRgbLight?.color;
                        if (activeRgbLight == null || colorRGB == null) return;

                        _saunaStore.updateSaunaLight(
                          colorRGB: colorRGB,
                          state: activeRgbLight.state ?? false,
                          brightness: double.parse(newValue.toStringAsFixed(2)),
                        );
                      });
                    },
                    quarterTurns: 0,
                    max: 1.0,
                    min: 0.0,
                    value: opacity,
                    width: 54,
                    activeTrackColor: theme.activeBrightnessColor,
                    inactiveTrackColor: theme.inactiveBrightnessColor,
                  ),
                  _buildBrightnessIcon(),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBrightnessIcon() {
    final theme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: IgnorePointer(
        child: Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          child: Assets.brightness.toSvgPicture(
            color: theme.iconColor,
            width: 32,
            height: 32,
          ),
        ),
      ),
    );
  }
}

class _SaunaMonoLightTabPage extends StatefulWidget {
  final SaunaControlPopupPageStore store;
  const _SaunaMonoLightTabPage({Key? key, required this.store}) : super(key: key);

  @override
  State<_SaunaMonoLightTabPage> createState() => _SaunaMonoLightTabPageState();
}

class _SaunaMonoLightTabPageState extends State<_SaunaMonoLightTabPage> {
  final _saunaStore = locator<SaunaStore>();

  final _reaction = CompositeReactionDisposer();

  @override
  void initState() {
    super.initState();
    widget.store.setMonoLightStatus(_saunaStore.activeMonoLight?.state ?? false);

    reaction<bool?>(
      (_) => _saunaStore.activeMonoLight?.state,
      (value) {
        widget.store.setMonoLightStatus(value ?? false);
      },
      fireImmediately: true,
    ).disposeWith(_reaction);
  }

  @override
  void dispose() {
    _reaction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Expanded(
      child: Observer(
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RotatedBox(
                  quarterTurns: 3,
                  child: FlutterSwitch(
                    width: 196.0,
                    height: 104.0,
                    toggleSize: 88.0,
                    value: widget.store.monoLightStatus,
                    borderRadius: 52.0,
                    padding: 8.0,
                    activeColor: theme.activateSwitchBackgroundColor,
                    inactiveColor: theme.deactivateSwitchBackgroundColor,
                    toggleColor: Colors.transparent,
                    toggleBorder: Border.all(
                      color: Colors.transparent,
                      width: 0.0,
                    ),
                    switchBorder: Border.all(
                      color: Colors.transparent,
                      width: 0.0,
                    ),
                    activeIcon: Container(
                      height: 88,
                      width: 88,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(44),
                        color: theme.activeSwitchBackgroundColor,
                      ),
                      alignment: Alignment.center,
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Assets.activeSwitch.toSvgPicture(
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                    inactiveIcon: Container(
                      height: 88,
                      width: 88,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(44),
                        color: theme.activeSwitchBackgroundColor,
                      ),
                      alignment: Alignment.center,
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Assets.inactiveSwitch.toSvgPicture(
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                    onToggle: (val) {
                      widget.store.setMonoLightStatus(val);
                      _saunaStore.updateSaunaMonoState(state: val);
                    },
                  )),
              const SizedBox(height: 24),
              _buildArrowIcon(),
              const SizedBox(height: 12),
              _buildInfoTitle(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildArrowIcon() {
    return (widget.store.monoLightStatus ? Assets.arrowDown : Assets.arrowUp).toSvgPicture(
      width: 12,
      height: 18,
      color: widget.store.monoLightStatus ? Theme.of(context).colorScheme.hintTextColor : ThemeColors.orange50,
    );
  }

  Widget _buildInfoTitle() {
    return Text(
      widget.store.monoLightStatus ? "Tap to turn the light off" : "Tap to turn the light on",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.normal,
        color: widget.store.monoLightStatus ? Theme.of(context).colorScheme.hintTextColor : ThemeColors.orange50,
        height: 1.3,
      ),
      textAlign: TextAlign.center,
    );
  }
}
