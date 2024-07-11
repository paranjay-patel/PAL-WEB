import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/flutter_vertical_slider.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/inner_shadow.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_home/store/sauna_home_page.store.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:mobx/mobx.dart';

class SaunaControlBrightnessButton extends StatefulWidget {
  final SaunaHomePageStore saunaControlPageStore;
  const SaunaControlBrightnessButton({Key? key, required this.saunaControlPageStore}) : super(key: key);

  @override
  _SaunaControlBrightnessButtonState createState() => _SaunaControlBrightnessButtonState();
}

class _SaunaControlBrightnessButtonState extends State<SaunaControlBrightnessButton> {
  final _saunaStore = locator<SaunaStore>();
  double _brightness = 10.0;
  Timer? _timer;

  final _reaction = CompositeReactionDisposer();

  late ScreenSize _screenSize;

  @override
  void initState() {
    super.initState();

    reaction<int>(
      (_) => _saunaStore.brightness,
      (value) {
        setState(() {
          _brightness = value.toDouble();
        });
      },
      fireImmediately: true,
    ).disposeWith(_reaction);

    reaction<PopupType>(
      (_) => _saunaStore.popupType,
      (type) {
        if (type != PopupType.brightness) {
          widget.saunaControlPageStore.isExpandedBrightnessBar = false;
        }
      },
      fireImmediately: true,
    ).disposeWith(_reaction);
  }

  @override
  void dispose() {
    _reaction.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    _screenSize = Utils.getScreenSize(context);
    return Padding(
      padding: EdgeInsets.only(
        top: _screenSize.getHeight(min: 20, max: 24),
        left: 12,
      ),
      child: Observer(
        builder: (context) {
          final popupType = _saunaStore.popupType;
          final isExpanded = widget.saunaControlPageStore.isExpandedBrightnessBar && popupType == PopupType.brightness;
          final height =
              isExpanded ? _screenSize.getHeight(min: 380, max: 540) : _screenSize.getHeight(min: 60, max: 72);
          return Container(
            height: height,
            width: _screenSize.getHeight(min: 60, max: 72),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 14, max: 20)),
              color: theme.buttonBackgroundColor,
              boxShadow: theme.saunaControlPageButtonShadow,
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                FeedbackSoundWrapper(
                  onTap: () {
                    _saunaStore.setPopupType(type: PopupType.brightness);
                    widget.saunaControlPageStore.isExpandedBrightnessBar =
                        !widget.saunaControlPageStore.isExpandedBrightnessBar;
                  },
                  child: Container(
                    height: _screenSize.getHeight(min: 60, max: 72),
                    width: _screenSize.getHeight(min: 60, max: 72),
                    alignment: Alignment.center,
                    child: (isExpanded ? Assets.close : Assets.brightness).toSvgPicture(
                      width: _screenSize.getHeight(min: 24, max: 32),
                      height: _screenSize.getHeight(min: 24, max: 32),
                      color: theme.iconColor,
                    ),
                  ),
                ),
                if (isExpanded) ...[
                  Expanded(child: _buildBrightnessBar()),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBrightnessBar() {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
          ClipRect(
            child: VerticalSlider(
              onChanged: (newValue) {
                if (newValue < 5) return;
                setState(() => _brightness = newValue);
                _timer?.cancel();
                _timer = Timer(const Duration(seconds: 2), () {
                  _timer?.cancel();
                  _saunaStore.setSaunaSystemBrightness(_brightness.toInt());
                });
              },
              max: 100.0,
              min: 0.0,
              value: _brightness,
              width: _screenSize.getHeight(min: 42, max: 52),
              activeTrackColor: theme.activeBrightnessColor,
              inactiveTrackColor: theme.inactiveBrightnessColor,
            ),
          ),
          _buildBrightnessIcon(),
        ],
      ),
    );
  }

  Widget _buildBrightnessIcon() {
    final theme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.bottomCenter,
      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.only(bottom: 8),
          width: _screenSize.getHeight(min: 42, max: 52),
          height: _screenSize.getHeight(min: 42, max: 52),
          alignment: Alignment.center,
          child: Assets.brightness.toSvgPicture(
            width: _screenSize.getHeight(min: 24, max: 32),
            height: _screenSize.getHeight(min: 24, max: 32),
            color: theme.iconColor,
          ),
        ),
      ),
    );
  }
}
