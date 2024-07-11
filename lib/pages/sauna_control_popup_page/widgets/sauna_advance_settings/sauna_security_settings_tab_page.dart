import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/common/found_space_router.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/widgets/sauna_advance_settings/sauna_system_settings_section.dart';
import 'package:found_space_flutter_web_application/pages/sauna_security_pin/store/sauna_security_pin_page.store.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';

class SaunaSecuritySettingsTabPage extends StatefulWidget {
  final VoidCallback onPinTap;
  final VoidCallback onPinPageClosed;

  const SaunaSecuritySettingsTabPage({
    Key? key,
    required this.onPinTap,
    required this.onPinPageClosed,
  }) : super(key: key);

  @override
  State<SaunaSecuritySettingsTabPage> createState() => _SaunaSecuritySettingsTabPageState();
}

class _SaunaSecuritySettingsTabPageState extends State<SaunaSecuritySettingsTabPage> {
  final _saunaLocalStorageStore = locator<SaunaLocalStorageStore>();

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenSize.getHeight(min: 20, max: 26)),
                  Text(
                    'Use PIN for:',
                    style: TextStyle(
                      color: theme.titleTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: screenSize.getFontSize(min: 16, max: 20),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: screenSize.getHeight(min: 20, max: 26)),
                  Observer(builder: (_) {
                    final isOn = _saunaLocalStorageStore.isSecuritySettingsEnabled;

                    return SaunaSystemSettingsSection(
                      type: SystemSettingsType.settings,
                      isOn: isOn,
                      onChanged: (bool value) async {
                        await _onChangedToggled(value, type: SystemSettingsType.settings);
                      },
                    );
                  }),
                  SizedBox(height: screenSize.getHeight(min: 20, max: 26)),
                  Observer(builder: (_) {
                    final isOn = _saunaLocalStorageStore.isSaunaPairingEnabled;

                    return SaunaSystemSettingsSection(
                      type: SystemSettingsType.saunaPairing,
                      isOn: isOn,
                      onChanged: (bool value) async {
                        await _onChangedToggled(value, type: SystemSettingsType.saunaPairing);
                      },
                    );
                  }),
                  SizedBox(height: screenSize.getHeight(min: 20, max: 26)),
                  _Divider(),
                  SizedBox(height: screenSize.getHeight(min: 20, max: 26)),
                  Text(
                    'Control and Program screens:',
                    style: TextStyle(
                      color: theme.titleTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: screenSize.getFontSize(min: 16, max: 20),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: screenSize.getHeight(min: 20, max: 26)),
                  Observer(builder: (_) {
                    final isOn = _saunaLocalStorageStore.isWifiButtonEnabled;

                    return SaunaSystemSettingsSection(
                      type: SystemSettingsType.enableWifiButton,
                      isOn: isOn,
                      onChanged: (bool value) async {
                        await _onChangedToggled(value, type: SystemSettingsType.enableWifiButton);
                      },
                    );
                  }),
                  SizedBox(height: screenSize.getHeight(min: 20, max: 26)),
                  Observer(builder: (_) {
                    final isOn = _saunaLocalStorageStore.isBluetoothButtonEnabled;

                    return SaunaSystemSettingsSection(
                      type: SystemSettingsType.enableBluetoothButton,
                      isOn: isOn,
                      onChanged: (bool value) async {
                        await _onChangedToggled(value, type: SystemSettingsType.enableBluetoothButton);
                      },
                    );
                  }),
                  SizedBox(height: screenSize.getHeight(min: 20, max: 26)),
                ],
              ),
            ),
          ),
        ),
        Observer(
          builder: (_) {
            final currentSecurityPin = _saunaLocalStorageStore.currentSecurityPin;
            if (currentSecurityPin == null || currentSecurityPin.isEmpty) return const SizedBox();

            return Center(
              child: _ChangePinButton(
                onTap: () async {
                  widget.onPinTap();
                  await Navigator.pushNamed(
                    context,
                    RouteGenerator.saunaSecurityPinPage,
                    arguments: SaunaSecurityPinPageState.change,
                  );
                  widget.onPinPageClosed();
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _onChangedToggled(bool value, {required SystemSettingsType type}) async {
    final currentSecurityPin = _saunaLocalStorageStore.currentSecurityPin;
    if (currentSecurityPin != null && currentSecurityPin.isNotEmpty) {
      widget.onPinTap();
      final status = await Navigator.pushNamed(
        context,
        RouteGenerator.saunaSecurityPinPage,
        arguments: SaunaSecurityPinPageState.verifySettings,
      ) as bool?;
      if (status == true) {
        _saunaLocalStorageStore.setSecuritySetting(type: type, status: value);
      }
      widget.onPinPageClosed();
      return;
    }

    widget.onPinTap();
    final status = await Navigator.pushNamed(
      context,
      RouteGenerator.saunaSecurityPinPage,
      arguments: SaunaSecurityPinPageState.create,
    ) as bool?;
    if (status == true) {
      _saunaLocalStorageStore.setSecuritySetting(type: type, status: value);
    }
    widget.onPinPageClosed();
  }
}

class _ChangePinButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ChangePinButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);

    return FeedbackSoundWrapper(
      onTap: onTap,
      child: Container(
        height: screenSize.getHeight(min: 44, max: 54),
        width: screenSize.getWidth(min: 260, max: 330),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenSize.getHeight(min: 16, max: 20)),
          border: Border.all(color: ThemeColors.primaryBlueColor, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          'Change PIN',
          style: TextStyle(
            color: ThemeColors.primaryBlueColor,
            fontWeight: FontWeight.w600,
            fontSize: screenSize.getFontSize(min: 14, max: 20),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      height: 1,
      color: theme.dividerColor,
    );
  }
}
