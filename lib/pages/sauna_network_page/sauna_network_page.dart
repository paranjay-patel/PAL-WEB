import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as listener;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_rest_api/models/src/network.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/wifi_state_extension.dart';
import 'package:found_space_flutter_web_application/common/themed_activity_indicator.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/common/virtual_keyboard/virtual_keyboard.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/store/sauna_control_popup_page.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/store/sauna_wifi.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_network_page/widgets/sauna_join_wifi.dart';
import 'package:found_space_flutter_web_application/pages/sauna_network_page/widgets/sauna_wifi_connect_status_popup.dart';
import 'package:found_space_flutter_web_application/pages/sauna_network_page/widgets/sauna_wifi_section.dart';
import 'package:mobx/mobx.dart';

enum NetworkType {
  wifi,
  ethernet;

  String get title {
    switch (this) {
      case NetworkType.wifi:
        return 'WiFi';
      case NetworkType.ethernet:
        return 'Ethernet';
    }
  }
}

class SaunaNetworkPage extends StatefulWidget {
  const SaunaNetworkPage({Key? key}) : super(key: key);

  @override
  _SaunaNetworkPageState createState() => _SaunaNetworkPageState();
}

class _SaunaNetworkPageState extends State<SaunaNetworkPage> with TickerProviderStateMixin {
  late ScreenSize _screenSize;

  final _store = SaunaControlPopupPageStore();
  final _saunaWifiStore = SaunaWifiStore();

  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();

  final _reaction = CompositeReactionDisposer();

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
    _focusNode.dispose();
    _reaction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = Utils.getScreenSize(context);

    return FocusScope(
      skipTraversal: true,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.mainPopupBackgroundColor,
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
            child: Observer(
              builder: (_) {
                final showConnectWifiPopup = _saunaWifiStore.showConnectWifiPopup;
                final showWifiConnectStatusPopup = _saunaWifiStore.showWifiConnectStatusPopup;

                if (showConnectWifiPopup) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _focusNode.requestFocus();
                  });
                }

                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Theme.of(context).colorScheme.mainPopupBaseBackgroundColor,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                          child: Center(
                            child: Container(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  width: showConnectWifiPopup
                                      ? _screenSize.getHeight(min: 600, max: 700)
                                      : _screenSize.getWidth(min: 680, max: 820),
                                  height: showConnectWifiPopup
                                      ? _screenSize.getHeight(min: 350, max: 400)
                                      : _screenSize.getHeight(min: 550, max: 660),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 14, max: 20)),
                                    color: Theme.of(context).colorScheme.popupBackgroundColor,
                                    boxShadow: Theme.of(context).colorScheme.saunaControlPageButtonShadow,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(_screenSize.getWidth(min: 20, max: 30)),
                                    child: Column(
                                      children: [
                                        _buildTitleAndButtons(),
                                        if (showConnectWifiPopup) ...[
                                          Expanded(
                                            child: SaunaJoinWifi(
                                              store: _saunaWifiStore,
                                              saunaControlPopupPageStore: _store,
                                              textEditingController: _textEditingController,
                                              focusNode: _focusNode,
                                            ),
                                          ),
                                        ] else if (showWifiConnectStatusPopup) ...[
                                          Expanded(
                                            child: SaunaWifiConnectStatusPopup(
                                              store: _saunaWifiStore,
                                            ),
                                          ),
                                        ] else ...[
                                          _SaunaNetworkSection(
                                            type: NetworkType.wifi,
                                            isOn: _saunaWifiStore.networkMode == NetworkMode.wifi,
                                            isLoading: _saunaWifiStore.isLoading &&
                                                _saunaWifiStore.selectedSwitchMode == NetworkMode.wifi,
                                            isInActiveWifi: _saunaWifiStore.isInActiveWifi,
                                            onChanged: (value) {
                                              _saunaWifiStore.setSelectSwitchMode(NetworkMode.wifi);
                                              if (_saunaWifiStore.networkMode == NetworkMode.wifi) {
                                                _saunaWifiStore.putSaunaNetwork(mode: NetworkMode.none);
                                              } else {
                                                _saunaWifiStore.putSaunaNetwork(mode: NetworkMode.wifi);
                                              }
                                            },
                                          ),
                                          if (_saunaWifiStore.networkMode == NetworkMode.wifi)
                                            Expanded(
                                              child: SaunaWifiSection(
                                                saunaWifiStore: _saunaWifiStore,
                                              ),
                                            ),
                                          _buildSeparator(),
                                          _SaunaNetworkSection(
                                            type: NetworkType.ethernet,
                                            isOn: _saunaWifiStore.networkMode == NetworkMode.ethernet,
                                            isLoading: _saunaWifiStore.isLoading &&
                                                _saunaWifiStore.selectedSwitchMode == NetworkMode.ethernet,
                                            isActiveEthernet: _saunaWifiStore.isActiveEthernet,
                                            onChanged: (value) {
                                              _saunaWifiStore.setSelectSwitchMode(NetworkMode.ethernet);
                                              if (_saunaWifiStore.networkMode == NetworkMode.ethernet) {
                                                _saunaWifiStore.putSaunaNetwork(mode: NetworkMode.none);
                                              } else {
                                                _saunaWifiStore.putSaunaNetwork(mode: NetworkMode.ethernet);
                                              }
                                            },
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (showConnectWifiPopup)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Theme.of(context).colorScheme.mainPopupBackgroundColor,
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {},
                            child: IgnorePointer(
                              ignoring: _saunaWifiStore.connectingWifi,
                              child: VirtualKeyboard(
                                height: 340,
                                textColor: Colors.black,
                                textController: _textEditingController,
                                focusNode: _focusNode,
                                fontSize: 18,
                                type: VirtualKeyboardType.Alphanumeric,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _resetTimer() {
    if (_saunaWifiStore.showConnectWifiPopup || _saunaWifiStore.showWifiConnectStatusPopup) {
      _store.cancelTimer();
      return;
    }
    _store.cancelTimer();
    _store.startTimer();
  }

  Widget _buildTitleAndButtons() {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: _screenSize.getHeight(min: 20, max: 30),
              width: _screenSize.getWidth(min: 40, max: 60),
            ),
            const Spacer(),
            Observer(builder: (context) {
              final showWifiConnectStatusPopup = _saunaWifiStore.showWifiConnectStatusPopup;

              return Text(
                showWifiConnectStatusPopup ? _saunaWifiStore.wifiState.wifiConnectionStatusText : 'Network connection',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.titleTextColor,
                  fontSize: _screenSize.getFontSize(min: 18, max: 24),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              );
            }),
            const Spacer(),
            FeedbackSoundWrapper(
              onTap: () {
                _saunaWifiStore.setConnectWifiPopup(false, shouldResetScanRefresh: false);
                _saunaWifiStore.setRefreshIntervals(false);
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
                    color: Theme.of(context).colorScheme.iconColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        _buildTimer(),
      ],
    );
  }

  Widget _buildTimer() {
    final screenSize = Utils.getScreenSize(context);
    return Observer(builder: (context) {
      final countdown = _store.secondsRemaining;
      if (countdown > 10 || countdown <= 0) return const SizedBox();

      return Align(
        alignment: Alignment.topLeft,
        child: Text(
          '$countdown',
          style: TextStyle(
            color: Theme.of(context).colorScheme.titleTextColor,
            fontSize: screenSize.getFontSize(min: 16, max: 20),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.right,
        ),
      );
    });
  }

  Widget _buildSeparator() {
    return Container(
      height: 1,
      color: Theme.of(context).colorScheme.tickMarkColor,
    );
  }
}

class _SaunaNetworkSection extends StatelessWidget {
  final NetworkType type;
  final bool isOn;
  final Function(bool)? onChanged;
  final bool isActiveEthernet;
  final bool isLoading;
  final bool isInActiveWifi;

  const _SaunaNetworkSection({
    this.type = NetworkType.wifi,
    this.isOn = false,
    this.onChanged,
    this.isActiveEthernet = false,
    this.isLoading = false,
    this.isInActiveWifi = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenSize.getHeight(min: 20, max: 24)),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type.title,
                style: TextStyle(
                  color: theme.titleTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: screenSize.getFontSize(min: 16, max: 20),
                ),
                textAlign: TextAlign.left,
              ),
              if (isOn && type == NetworkType.wifi && isInActiveWifi) ...[
                const SizedBox(height: 4),
                Text(
                  'Connection is lost',
                  style: TextStyle(
                    color: const Color(0xffEE3F16),
                    fontWeight: FontWeight.w600,
                    fontSize: screenSize.getFontSize(min: 12, max: 16),
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
              if (isOn && type == NetworkType.ethernet) ...[
                const SizedBox(height: 4),
                Text(
                  isActiveEthernet ? 'Connected' : 'Offline',
                  style: TextStyle(
                    color: isActiveEthernet ? const Color(0xff03A200) : const Color(0xffEE3F16),
                    fontWeight: FontWeight.w600,
                    fontSize: screenSize.getFontSize(min: 12, max: 16),
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ],
          ),
          const Spacer(),
          SizedBox(width: screenSize.getFontSize(min: 6, max: 8)),
          if (isLoading) ...[
            const ThemedActivityIndicator(radius: 8),
          ],
          SizedBox(width: screenSize.getFontSize(min: 6, max: 8)),
          Text(
            isOn ? 'ON' : 'OFF',
            style: TextStyle(
              color: ThemeColors.primaryBlueColor,
              fontWeight: FontWeight.w600,
              fontSize: screenSize.getFontSize(min: 16, max: 20),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(width: screenSize.getFontSize(min: 6, max: 8)),
          CupertinoSwitch(
            value: isOn,
            activeColor: ThemeColors.blue50,
            onChanged: (value) {
              if (isLoading) return;
              onChanged?.call(value);
            },
          ),
          SizedBox(width: screenSize.getFontSize(min: 10, max: 12)),
        ],
      ),
    );
  }
}
