import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/themed_activity_indicator.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/store/sauna_control_popup_page.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_page_common.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/widgets/sauna_advance_settings/sauna_advance_settings_tab_bar.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/widgets/sauna_advance_settings/sauna_general_settings_tab_page.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/widgets/sauna_advance_settings/sauna_security_settings_tab_page.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/widgets/sauna_advance_settings/sauna_sounds_and_temperature_settings_tab_page.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:mobx/mobx.dart';

extension SaunaFirmwarePopupTypeExtension on SaunaFirmwarePopupType {
  String get buttonText {
    switch (this) {
      case SaunaFirmwarePopupType.reset:
        return 'Yes, Reset';
      case SaunaFirmwarePopupType.restart:
        return 'Yes, Restart';
      default:
        return '';
    }
  }

  String get popupTitleText {
    switch (this) {
      case SaunaFirmwarePopupType.reset:
        return 'Are you sure you want to proceed with resetting your sauna device to its factory settings?';
      case SaunaFirmwarePopupType.restart:
        return 'Are you sure you want to restart the device?';
      default:
        return '';
    }
  }

  String get popupDescriptionText {
    switch (this) {
      case SaunaFirmwarePopupType.reset:
        return 'This action will permanently delete all user-stored preferences, including Wi-Fi configurations. By proceeding, you\'ll revert the sauna to its original settings, erasing any customized settings you may have saved. Please note that this cannot be undone, and all your personalized configurations will be lost. Additionally, resetting to factory settings will unpair any mobile devices previously connected to this sauna.';
      case SaunaFirmwarePopupType.restart:
        return 'Pressing "Yes" will temporarily turn off the sauna for a few seconds and initiate a reboot process.';
      default:
        return '';
    }
  }

  Color get buttonBackgroundColor {
    switch (this) {
      case SaunaFirmwarePopupType.reset:
        return ThemeColors.errorColor;
      case SaunaFirmwarePopupType.restart:
        return ThemeColors.primaryBlueColor;
      default:
        return ThemeColors.primaryBlueColor;
    }
  }
}

class SaunaAdvanceSettingsMode extends StatefulWidget {
  final SaunaControlPopupPageStore store;
  final VoidCallback onPinTap;
  final VoidCallback onPinPageClosed;
  const SaunaAdvanceSettingsMode({
    Key? key,
    required this.store,
    required this.onPinTap,
    required this.onPinPageClosed,
  }) : super(key: key);

  @override
  State<SaunaAdvanceSettingsMode> createState() => _SaunaAdvanceSettingsModeState();
}

class _SaunaAdvanceSettingsModeState extends State<SaunaAdvanceSettingsMode> {
  final _reaction = CompositeReactionDisposer();
  final _saunaStore = locator<SaunaStore>();

  @override
  void initState() {
    super.initState();

    reaction((_) => _saunaStore.isFactoryReset, (bool? isFactoryReset) {
      widget.store.setSaunaFirmwarePopupType(SaunaFirmwarePopupType.none);
    }).disposeWith(_reaction);
  }

  @override
  void dispose() {
    _reaction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);

    return Observer(
      builder: (context) {
        final showAlertPopup = widget.store.saunaFirmwarePopupType != SaunaFirmwarePopupType.none;
        if (showAlertPopup) {
          return _AlertPopup(
            type: widget.store.saunaFirmwarePopupType,
            store: widget.store,
          );
        }

        return Expanded(
          child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenSize.getHeight(min: 8, max: 16)),
                    SaunaAdvanceSettingsTabBar(
                      store: widget.store,
                      onTabTapped: (saunaAdvanceSettingsType) {
                        widget.store.setSelectedSaunaAdvanceSettingsTabType(saunaAdvanceSettingsType);
                      },
                    ),
                    if (widget.store.selectedAdvanceSettingsTabType == SaunaAdvanceSettingsTabType.general)
                      Expanded(
                        child: SaunaGeneralSettingsTabPage(
                          store: widget.store,
                          onResetTap: () {
                            widget.store.setSaunaFirmwarePopupType(SaunaFirmwarePopupType.reset);
                          },
                          onRestartTap: () {
                            widget.store.setSaunaFirmwarePopupType(SaunaFirmwarePopupType.restart);
                          },
                        ),
                      )
                    else if (widget.store.selectedAdvanceSettingsTabType == SaunaAdvanceSettingsTabType.security)
                      Expanded(
                        child: SaunaSecuritySettingsTabPage(
                          onPinTap: widget.onPinTap,
                          onPinPageClosed: widget.onPinPageClosed,
                        ),
                      )
                    else if (widget.store.selectedAdvanceSettingsTabType ==
                        SaunaAdvanceSettingsTabType.soundAndTemperature)
                      const Expanded(child: SaunaSoundsAndTemperatureSettingsTabPage())
                    else
                      const Expanded(child: SizedBox()),
                  ],
                ),
              )),
        );
      },
    );
  }
}

class _AlertPopup extends StatelessWidget {
  final SaunaFirmwarePopupType type;
  final SaunaControlPopupPageStore store;

  const _AlertPopup({required this.type, required this.store});

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;
    final saunaStore = locator<SaunaStore>();

    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(right: screenSize.getWidth(min: 60, max: 100)),
                child: Text(
                  type.popupTitleText,
                  style: TextStyle(
                    color: theme.titleTextColor,
                    fontWeight: FontWeight.bold,
                    height: 1.8,
                    fontSize: screenSize.getFontSize(min: 18, max: 24),
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            SizedBox(height: screenSize.getHeight(min: 20, max: 28)),
            Text(
              type.popupDescriptionText,
              style: TextStyle(
                color: theme.titleTextColor,
                fontWeight: FontWeight.w300,
                height: 1.8,
                fontSize: screenSize.getFontSize(min: 17, max: 20),
              ),
              textAlign: TextAlign.start,
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: _CancelButton(
                    onTap: () {
                      store.setSaunaFirmwarePopupType(SaunaFirmwarePopupType.none);
                    },
                  ),
                ),
                SizedBox(width: screenSize.getWidth(min: 80, max: 100)),
                Expanded(
                  child: Observer(builder: (context) {
                    final isLoading = saunaStore.isLoading;

                    return _UpdateOrResetButton(
                      type: type,
                      isLoading: isLoading,
                      onTap: () {
                        if (isLoading) return;
                        if (type == SaunaFirmwarePopupType.reset) {
                          saunaStore.factoryReset();
                        } else if (type == SaunaFirmwarePopupType.restart) {
                          saunaStore.saunaRestart();
                        }
                      },
                    );
                  }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _UpdateOrResetButton extends StatelessWidget {
  final VoidCallback onTap;
  final SaunaFirmwarePopupType type;
  final bool isLoading;

  const _UpdateOrResetButton({
    required this.onTap,
    required this.type,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);

    return FeedbackSoundWrapper(
      onTap: onTap,
      child: Container(
        height: screenSize.getHeight(min: 46, max: 56),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenSize.getHeight(min: 14, max: 20)),
          color: type.buttonBackgroundColor,
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const ThemedActivityIndicator(isLightColorIndicator: true)
            : Text(
                type.buttonText,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: screenSize.getFontSize(min: 16, max: 20),
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CancelButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;

    return FeedbackSoundWrapper(
      onTap: onTap,
      child: Container(
        height: screenSize.getHeight(min: 46, max: 56),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenSize.getHeight(min: 14, max: 20)),
          color: theme.popupBackgroundColor,
          border: Border.all(color: ThemeColors.primaryBlueColor, width: 2.0),
        ),
        alignment: Alignment.center,
        child: Text(
          'Cancel',
          style: TextStyle(
            color: ThemeColors.primaryBlueColor,
            fontWeight: FontWeight.bold,
            fontSize: screenSize.getFontSize(min: 16, max: 20),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
