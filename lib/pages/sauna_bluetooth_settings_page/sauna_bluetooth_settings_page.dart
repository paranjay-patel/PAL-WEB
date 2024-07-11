import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as listener;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/sauna_system_extension.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_bluetooth_store.dart';
import 'package:found_space_flutter_web_application/common/themed_activity_indicator.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_bluetooth_settings_page/store/sauna_bluetooth_settings_page.store.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:mobx/mobx.dart';

class SaunaBluetoothSettingsPage extends StatefulWidget {
  const SaunaBluetoothSettingsPage({Key? key}) : super(key: key);

  @override
  _SaunaBluetoothSettingsPageState createState() => _SaunaBluetoothSettingsPageState();
}

class _SaunaBluetoothSettingsPageState extends State<SaunaBluetoothSettingsPage> {
  late ColorScheme _theme;
  late ScreenSize _screenSize;
  final _saunaBluetoothStore = locator<SaunaBluetoothStore>();
  final _store = SaunaBluetoothSettingsPageStore();
  final _reaction = CompositeReactionDisposer();

  @override
  void initState() {
    super.initState();
    _store.setup();

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
    _reaction.dispose();
    super.dispose();
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
            Navigator.pop(context);
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            color: _theme.mainPopupBaseBackgroundColor,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Center(
                child: Container(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Observer(builder: (context) {
                      final bluetoothState = _saunaBluetoothStore.bluetoothState;
                      bool shouldShowFooter = false;
                      var bluetoothName = '';
                      switch (bluetoothState) {
                        case BluetoothState.connected:
                          bluetoothName = _saunaBluetoothStore.bluetoothName;
                          shouldShowFooter = true;
                          break;
                        case BluetoothState.enabled:
                          bluetoothName = _saunaBluetoothStore.bluetoothAdvertiserName;
                          shouldShowFooter = true;
                          break;
                        case BluetoothState.disabled:
                          break;
                        default:
                      }

                      final isBluetoothEnabled = bluetoothState == BluetoothState.enabled;
                      final isBluetoothConnected = bluetoothState == BluetoothState.connected;
                      final isBluetoothEnableDisableLoading = _saunaBluetoothStore.isBluetoothEnableDisableLoading;

                      return Container(
                        width: _screenSize.getWidth(min: 525, max: 600),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 14, max: 20)),
                          color: _theme.popupBackgroundColor,
                          boxShadow: _theme.saunaControlPageButtonShadow,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: _screenSize.getWidth(min: 16, max: 24)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: _screenSize.getHeight(min: 18, max: 24)),
                              Row(
                                children: [
                                  Expanded(
                                      child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _TitleText(),
                                      _buildTimer(context),
                                    ],
                                  )),
                                  _CloseButton(),
                                ],
                              ),
                              SizedBox(height: _screenSize.getHeight(min: 22, max: 28)),
                              _Divider(),
                              SizedBox(height: _screenSize.getHeight(min: 22, max: 28)),
                              _BluetoothSection(
                                isSwitchOn: isBluetoothEnabled || isBluetoothConnected,
                                isLoading: isBluetoothEnableDisableLoading,
                                onSwitchChanged: (bool? value) {
                                  _saunaBluetoothStore.enableDisabledBluetooth();
                                },
                              ),
                              SizedBox(height: _screenSize.getHeight(min: 22, max: 28)),
                              _Divider(),
                              SizedBox(height: _screenSize.getHeight(min: 22, max: 28)),
                              if (shouldShowFooter)
                                _BluetoothFooter(
                                  bluetoothName: bluetoothName,
                                  isConnected: isBluetoothConnected,
                                ),
                              SizedBox(height: _screenSize.getHeight(min: 30, max: 40)),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimer(BuildContext context) {
    final _screenSize = Utils.getScreenSize(context);
    return Observer(builder: (context) {
      final countdown = _store.secondsRemaining;
      if (countdown > 10 || countdown <= 0) return const SizedBox();

      return Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
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

  void _resetTimer() {
    _store.cancelTimer();
    _store.startTimer();
  }
}

class _BluetoothFooter extends StatelessWidget {
  final String bluetoothName;
  final bool isConnected;

  const _BluetoothFooter({
    Key? key,
    required this.bluetoothName,
    this.isConnected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bluetoothName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.titleTextColor,
            fontSize: Utils.getScreenSize(context).getFontSize(min: 16, max: 20),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.left,
        ),
        if (isConnected) SizedBox(height: screenSize.getHeight(min: 4, max: 8)),
        if (isConnected)
          Text(
            'Connected',
            style: TextStyle(
              color: Theme.of(context).colorScheme.bluetoothSubTitleTextColor,
              fontSize: Utils.getScreenSize(context).getFontSize(min: 10, max: 16),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.left,
          ),
      ],
    );
  }
}

class _BluetoothSection extends StatelessWidget {
  final bool isSwitchOn;
  final bool isLoading;
  final Function(bool)? onSwitchChanged;
  const _BluetoothSection({
    Key? key,
    this.isSwitchOn = false,
    this.isLoading = false,
    this.onSwitchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Text(
            'Bluetooth On',
            style: TextStyle(
              color: Theme.of(context).colorScheme.titleTextColor,
              fontSize: Utils.getScreenSize(context).getFontSize(min: 16, max: 20),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        if (isLoading) const ThemedActivityIndicator(radius: 6),
        const SizedBox(width: 4),
        CupertinoSwitch(
          value: isSwitchOn,
          activeColor: ThemeColors.blue50,
          onChanged: onSwitchChanged,
        ),
      ],
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

class _TitleText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final screenSize = Utils.getScreenSize(context);

    return Text(
      'Bluetooth',
      style: TextStyle(
        fontSize: screenSize.getFontSize(min: 18, max: 24),
        fontWeight: FontWeight.bold,
        color: theme.titleTextColor,
      ),
      textAlign: TextAlign.left,
    );
  }
}

class _CloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;
    return FeedbackSoundWrapper(
      onTap: () {
        Navigator.pop(context);
      },
      child: SizedBox(
        width: screenSize.getWidth(min: 40, max: 50),
        height: screenSize.getHeight(min: 40, max: 50),
        child: Align(
          alignment: Alignment.center,
          child: Assets.close.toSvgPicture(
            width: screenSize.getWidth(min: 20, max: 24),
            height: screenSize.getHeight(min: 20, max: 24),
            color: theme.iconColor,
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String buttonText;
  final double height;
  final bool usedBorder;
  final Function() onTap;

  const _Button({
    required this.buttonText,
    required this.height,
    required this.onTap,
    this.usedBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);

    return FeedbackSoundWrapper(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenSize.getHeight(min: 14, max: 20)),
          color: usedBorder ? null : ThemeColors.blue50,
          border: usedBorder
              ? Border.all(
                  color: ThemeColors.blue50,
                  width: 2,
                )
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: screenSize.getFontSize(min: 14, max: 20),
            fontWeight: FontWeight.w600,
            color: usedBorder ? ThemeColors.blue50 : ThemeColors.neutral000,
          ),
        ),
      ),
    );
  }
}
