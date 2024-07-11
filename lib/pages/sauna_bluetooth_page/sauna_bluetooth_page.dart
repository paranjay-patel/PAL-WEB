import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_bluetooth_store.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/bluetooth_extension.dart';
import 'package:mobx/mobx.dart';

enum BluetoothParingState {
  none,
  attemptParing,
  paired,
  failed,
}

class SaunaBluetoothPage extends StatefulWidget {
  const SaunaBluetoothPage({Key? key}) : super(key: key);

  @override
  _SaunaBluetoothPageState createState() => _SaunaBluetoothPageState();
}

class _SaunaBluetoothPageState extends State<SaunaBluetoothPage> {
  late ColorScheme _theme;
  late ScreenSize _screenSize;
  final _reaction = CompositeReactionDisposer();
  final _saunaBluetoothStore = locator<SaunaBluetoothStore>();

  var _hasPaired = false;
  var _bluetoothName = '';

  @override
  void initState() {
    super.initState();

    reaction((_) => _saunaBluetoothStore.bluetoothParingState, (BluetoothParingState? bluetoothParingState) async {
      final state = bluetoothParingState ?? BluetoothParingState.none;
      switch (state) {
        case BluetoothParingState.none:
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pop(context);
          });
          break;
        case BluetoothParingState.attemptParing:
          break;
        case BluetoothParingState.paired:
        case BluetoothParingState.failed:
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pop(context);
          });
          break;
      }
    }, fireImmediately: true)
        .disposeWith(_reaction);
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context).colorScheme;
    _screenSize = Utils.getScreenSize(context);

    return Scaffold(
      backgroundColor: _theme.mainPopupBackgroundColor,
      body: InkWell(
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
                    final showBluetoothPairing =
                        _saunaBluetoothStore.bluetoothParingState == BluetoothParingState.attemptParing;
                    if (_saunaBluetoothStore.bluetoothParingState == BluetoothParingState.paired) {
                      _hasPaired = true;
                    } else if (_saunaBluetoothStore.bluetoothParingState == BluetoothParingState.failed) {
                      _hasPaired = false;
                    }
                    final deviceName = _saunaBluetoothStore.bluetooth?.deviceName;
                    if (deviceName != null && deviceName.isNotEmpty) {
                      _bluetoothName = deviceName;
                    }
                    final bluetoothCode = _saunaBluetoothStore.bluetooth?.deviceParingCode ?? '';

                    return Container(
                      width: _screenSize.getWidth(min: 525, max: 600),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 14, max: 20)),
                        color: _theme.popupBackgroundColor,
                        boxShadow: _theme.saunaControlPageButtonShadow,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: _screenSize.getHeight(min: 22, max: 30)),
                          Center(
                            child: Text(
                              'Pair your Bluetooth device',
                              style: TextStyle(
                                color: _theme.titleTextColor,
                                fontSize: _screenSize.getFontSize(min: 18, max: 24),
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Opacity(
                                opacity: showBluetoothPairing ? 1 : 0,
                                child: IgnorePointer(
                                  ignoring: !showBluetoothPairing,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: _screenSize.getHeight(min: 40, max: 60)),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Assets.bluetoothConnection.toSvgPicture(
                                            width: _screenSize.getHeight(min: 80, max: 100),
                                            height: _screenSize.getHeight(min: 80, max: 100),
                                            color: _theme.iconColor,
                                          ),
                                          Assets.bluetoothNetwork.toSvgPicture(
                                            width: _screenSize.getHeight(min: 80, max: 100),
                                            height: _screenSize.getHeight(min: 80, max: 100),
                                            color: _theme.iconColor,
                                          ),
                                          Assets.qrCodeOne.toSvgPicture(
                                            width: _screenSize.getHeight(min: 80, max: 100),
                                            height: _screenSize.getHeight(min: 80, max: 100),
                                            color: _theme.iconColor,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: _screenSize.getHeight(min: 18, max: 24)),
                                      Text(
                                        '$_bluetoothName wants to connect via Bluetooth',
                                        style: TextStyle(
                                          color: _theme.iconColor,
                                          fontSize: _screenSize.getFontSize(min: 16, max: 20),
                                          fontWeight: FontWeight.w300,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: _screenSize.getHeight(min: 28, max: 40)),
                                      Text(
                                        bluetoothCode,
                                        style: TextStyle(
                                          color: _theme.iconColor,
                                          fontSize: _screenSize.getFontSize(min: 44, max: 64),
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 8,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: _screenSize.getHeight(min: 34, max: 50)),
                                      Row(
                                        children: [
                                          SizedBox(width: _screenSize.getWidth(min: 14, max: 20)),
                                          Expanded(
                                            child: _Button(
                                              buttonText: 'Decline',
                                              height: _screenSize.getHeight(min: 54, max: 68),
                                              usedBorder: true,
                                              onTap: () {
                                                final deviceAddress =
                                                    _saunaBluetoothStore.bluetooth?.deviceAddress ?? '';
                                                _saunaBluetoothStore.paidOrRejectBluetooth(
                                                  acceptPairing: false,
                                                  address: deviceAddress,
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(width: _screenSize.getWidth(min: 22, max: 32)),
                                          Expanded(
                                            child: _Button(
                                              buttonText: 'Accept',
                                              height: _screenSize.getHeight(min: 54, max: 68),
                                              onTap: () {
                                                final deviceAddress =
                                                    _saunaBluetoothStore.bluetooth?.deviceAddress ?? '';
                                                _saunaBluetoothStore.paidOrRejectBluetooth(
                                                  acceptPairing: true,
                                                  address: deviceAddress,
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(width: _screenSize.getWidth(min: 14, max: 20)),
                                        ],
                                      ),
                                      SizedBox(height: _screenSize.getHeight(min: 22, max: 30)),
                                    ],
                                  ),
                                ),
                              ),
                              if (!showBluetoothPairing)
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: _screenSize.getHeight(min: 90, max: 120),
                                      width: _screenSize.getHeight(min: 90, max: 120),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _hasPaired
                                            ? _theme.bluetoothConnectedBackgroundColor
                                            : _theme.bluetoothDisconnectedBackgroundColor,
                                      ),
                                      alignment: Alignment.center,
                                      child: (_hasPaired ? Assets.bluetoothConnected : Assets.bluetoothDisconnected)
                                          .toSvgPicture(
                                        width: _screenSize.getHeight(min: 50, max: 64),
                                        height: _screenSize.getHeight(min: 50, max: 64),
                                        color: _hasPaired
                                            ? _theme.bluetoothConnectedIconColor
                                            : _theme.bluetoothDisconnectedIconColor,
                                      ),
                                    ),
                                    SizedBox(height: _screenSize.getHeight(min: 20, max: 28)),
                                    Text(
                                      _hasPaired
                                          ? '$_bluetoothName connected'
                                          : 'Connection with $_bluetoothName failed',
                                      style: TextStyle(
                                        color: _theme.iconColor,
                                        fontSize: _screenSize.getFontSize(min: 16, max: 20),
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: _screenSize.getHeight(min: 26, max: 40)),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
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
