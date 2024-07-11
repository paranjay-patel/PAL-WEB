import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/found_space_router.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/common/store/screen_saver.store.dart';
import 'package:found_space_flutter_web_application/common/svg_asset_image.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_home/store/sauna_home_page.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_security_pin/store/sauna_security_pin_page.store.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

enum SaunaMenuType {
  saunaControl,
  programs,
  settings,
}

extension SaunaMenuTypeExtensions on SaunaMenuType {
  SvgAssetImage get iconName {
    switch (this) {
      case SaunaMenuType.saunaControl:
        return Assets.saunaControl;
      case SaunaMenuType.programs:
        return Assets.saunaPrograms;
      case SaunaMenuType.settings:
        return Assets.settings;
    }
  }

  String get titleText {
    switch (this) {
      case SaunaMenuType.saunaControl:
        return 'Sauna Control';
      case SaunaMenuType.programs:
        return 'Programs';
      case SaunaMenuType.settings:
        return 'Settings';
    }
  }
}

class SaunaControlMenuButton extends StatefulWidget {
  final SaunaHomePageStore saunaControlPageStore;
  const SaunaControlMenuButton({
    Key? key,
    required this.saunaControlPageStore,
  }) : super(key: key);

  @override
  State<SaunaControlMenuButton> createState() => _SaunaControlMenuButtonState();
}

class _SaunaControlMenuButtonState extends State<SaunaControlMenuButton> with TickerProviderStateMixin {
  late AnimationController _animation;
  late Animation<double> _fadeInFadeOut;
  final _textEditingController = TextEditingController();
  final _saunaStore = locator<SaunaStore>();
  final _saunaLocalStorageStore = locator<SaunaLocalStorageStore>();
  final _reaction = CompositeReactionDisposer();

  late ScreenSize _screenSize;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1.0).animate(_animation);

    reaction<PopupType>(
      (_) => _saunaStore.popupType,
      (type) {
        if (type != PopupType.menu) {
          widget.saunaControlPageStore.isExpandedMenuButton = false;
          _animation.reverse(from: 0);
        }
      },
      fireImmediately: true,
    ).disposeWith(_reaction);
  }

  @override
  void dispose() {
    super.dispose();
    _reaction.dispose();
    _animation.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    _screenSize = Utils.getScreenSize(context);

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: _screenSize.getHeight(min: 20, max: 24),
          right: _screenSize.getHeight(min: 20, max: 24),
        ),
        child: Observer(
          builder: (context) {
            final popupType = _saunaStore.popupType;
            final isExpandedMenuButton = widget.saunaControlPageStore.isExpandedMenuButton;
            final isExpanded = isExpandedMenuButton && popupType == PopupType.menu;
            final selectedType = _saunaStore.selectedSaunaMenuType;

            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: _screenSize.getHeight(min: 60, max: 72),
                  width: _screenSize.getHeight(min: 60, max: 72),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 14, max: 20)),
                    color: theme.buttonBackgroundColor,
                    border: isExpanded ? Border.all(color: ThemeColors.orange20, width: 2) : null,
                    boxShadow: isExpanded ? null : theme.saunaControlPageButtonShadow,
                  ),
                  alignment: Alignment.center,
                  child: FeedbackSoundWrapper(
                    onTap: () {
                      _saunaStore.setPopupType(type: PopupType.menu);
                      widget.saunaControlPageStore.isExpandedMenuButton =
                          !widget.saunaControlPageStore.isExpandedMenuButton;
                      if (isExpanded) {
                        _animation.reverse();
                      } else {
                        _animation.forward();
                      }
                    },
                    child: Container(
                      height: _screenSize.getHeight(min: 60, max: 72),
                      width: _screenSize.getHeight(min: 60, max: 72),
                      alignment: Alignment.center,
                      child: (isExpanded ? Assets.close : Assets.menu).toSvgPicture(
                        width: _screenSize.getHeight(min: 24, max: 32),
                        height: _screenSize.getHeight(min: 24, max: 32),
                        color: theme.iconColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FadeTransition(
                  opacity: _fadeInFadeOut,
                  child: IgnorePointer(
                    ignoring: !isExpandedMenuButton,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 14, max: 20)),
                        color: theme.menuPopupBackgroundColor,
                        boxShadow: theme.saunaControlPageButtonShadow,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: SaunaMenuType.values.map((type) => _buildSettingsTile(type, selectedType)).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSettingsTile(SaunaMenuType type, SaunaMenuType selectedType) {
    final screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;
    final isSelected = type == selectedType;

    return FeedbackSoundWrapper(
      onTap: () async {
        if (isSelected) return;

        _saunaStore.setPopupType(type: PopupType.none);
        _saunaStore.setSelectedMenuType(type);
        widget.saunaControlPageStore.isExpandedMenuButton = false;
        _animation.reverse(from: 0);

        if (_saunaLocalStorageStore.isSecuritySettingsEnabled && type == SaunaMenuType.settings) {
          context.read<ScreenSaverStore>().cancelScreenSaverTimer();
          await Future.delayed(const Duration(milliseconds: 250));
          final status = await Navigator.pushNamed(
            context,
            RouteGenerator.saunaSecurityPinPage,
            arguments: SaunaSecurityPinPageState.verifySettings,
          ) as bool?;

          if (status == null) {
            _saunaStore.setSelectedMenuType(SaunaMenuType.saunaControl);
          }
        }

        if (type == SaunaMenuType.programs) {
          context.read<ScreenSaverStore>().cancelScreenSaverTimer();
        } else {
          context.read<ScreenSaverStore>().setupScreenSaverTimer();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: screenSize.getHeight(min: 64, max: 84),
          width: screenSize.getHeight(min: 170, max: 200),
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 24),
          decoration: BoxDecoration(
            color: isSelected ? theme.selectedAudioBackgroundColor : Colors.transparent,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            children: [
              type.iconName.toSvgPicture(
                width: screenSize.getWidth(min: 25, max: 32),
                height: screenSize.getWidth(min: 25, max: 32),
                color: isSelected ? ThemeColors.blue50 : theme.iconColor,
              ),
              const SizedBox(width: 4),
              Text(
                type.titleText,
                style: TextStyle(
                  color: isSelected ? ThemeColors.blue50 : theme.iconColor,
                  fontSize: screenSize.getFontSize(min: 14, max: 16),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
