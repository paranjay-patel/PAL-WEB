import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_rest_api/models/models.dart' as rest_api_models;
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/themed_activity_indicator.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/store/sauna_control_popup_page.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/store/sauna_wifi.store.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:mobx/mobx.dart';

class SaunaWifiSection extends StatefulWidget {
  final SaunaWifiStore saunaWifiStore;
  const SaunaWifiSection({
    Key? key,
    required this.saunaWifiStore,
  }) : super(key: key);

  @override
  _SaunaWifiSectionState createState() => _SaunaWifiSectionState();
}

class _SaunaWifiSectionState extends State<SaunaWifiSection> with TickerProviderStateMixin {
  late ColorScheme _theme;
  late ScreenSize _screenSize;

  final _store = SaunaControlPopupPageStore();

  final _saunaStore = locator<SaunaStore>();

  final _reaction = CompositeReactionDisposer();

  @override
  void initState() {
    super.initState();

    reaction((_) => _saunaStore.wifiState, (rest_api_models.WifiState wifiState) {
      switch (wifiState) {
        case rest_api_models.WifiState.active:
          widget.saunaWifiStore.setConnectWifiPopup(false);
          break;
        case rest_api_models.WifiState.unknown:
        case rest_api_models.WifiState.activating:
          break;
        case rest_api_models.WifiState.deactivated:
        case rest_api_models.WifiState.inactive:
        case rest_api_models.WifiState.neverActivated:
          widget.saunaWifiStore.setConnectWifiPopup(false);
          break;
      }
    }).disposeWith(_reaction);

    widget.saunaWifiStore.setRefreshIntervals(true);
    widget.saunaWifiStore.refresh();
  }

  @override
  void dispose() {
    _reaction.dispose();
    widget.saunaWifiStore.setRefreshIntervals(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context).colorScheme;
    _screenSize = Utils.getScreenSize(context);

    return Observer(
      builder: (_) {
        final isLoading = widget.saunaWifiStore.isLoadingScanWifi;
        final activeNetworks = widget.saunaWifiStore.currentActiveWifi;
        final otherNetworks = widget.saunaWifiStore.wifiNetworks;
        final isScanView = !isLoading && otherNetworks.isEmpty && widget.saunaWifiStore.currentActiveWifi == null;
        final showConnectWifiPopup = widget.saunaWifiStore.showConnectWifiPopup;

        final shouldShowScanSection = !isLoading && !isScanView;

        return Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildSeparator(),
                  Expanded(
                    child: isLoading
                        ? _buildLoadingView()
                        : isScanView
                            ? _buildScanView()
                            : SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    if (activeNetworks != null) ...[_buildWifiTile(activeNetworks)],
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: otherNetworks.length,
                                      itemBuilder: (context, index) {
                                        return _buildWifiTile(otherNetworks[index]);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                  ),
                  if (shouldShowScanSection && !showConnectWifiPopup)
                    _WifiScanSection(
                      onScanTap: () {
                        final isWifiLoading = widget.saunaWifiStore.isLoadingScanWifi;
                        if (isWifiLoading) return;
                        widget.saunaWifiStore.scanWifi();
                      },
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingView() {
    return const Center(child: ThemedActivityIndicator());
  }

  Widget _buildHeaderTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: _screenSize.getFontSize(min: 12, max: 16),
        fontWeight: FontWeight.normal,
        color: _theme.wifiHeaderTitleTextColor,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildWifiTile(rest_api_models.Wifi saunaWifi) {
    final wifiName = saunaWifi.ssid ?? '';
    final isActiveNetwork = saunaWifi.inUse ?? false;
    return Container(
      height: _screenSize.getHeight(min: 64, max: 88),
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wifiName,
                  style: TextStyle(
                    fontSize: _screenSize.getFontSize(min: 14, max: 20),
                    fontWeight: FontWeight.w500,
                    color: _theme.titleTextColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                if (isActiveNetwork) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Connected',
                    style: TextStyle(
                      fontSize: _screenSize.getFontSize(min: 14, max: 16),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff03A200),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ],
            ),
          ),
          if (isActiveNetwork) ...[
            _buildForgotButton(),
          ] else ...[
            _buildConnectButton(saunaWifi),
          ],
        ],
      ),
    );
  }

  Widget _buildForgotButton() {
    return Observer(builder: (context) {
      final isLoading = widget.saunaWifiStore.isForgetWifiLoading;
      return FeedbackSoundWrapper(
        onTap: () {
          if (isLoading) return;
          widget.saunaWifiStore.forgotWifi();
        },
        child: Container(
          height: _screenSize.getHeight(min: 40, max: 56),
          width: _screenSize.getWidth(min: 140, max: 190),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 12, max: 20)),
            color: ThemeColors.blue10,
          ),
          alignment: Alignment.center,
          child: isLoading
              ? const ThemedActivityIndicator()
              : Text(
                  'Forgot Network',
                  style: TextStyle(
                    fontSize: _screenSize.getFontSize(min: 14, max: 20),
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.blue50,
                  ),
                  textAlign: TextAlign.center,
                ),
        ),
      );
    });
  }

  Widget _buildConnectButton(rest_api_models.Wifi saunaWifi) {
    return FeedbackSoundWrapper(
      onTap: () {
        final isActiveNetwork = saunaWifi.inUse ?? false;
        if (!isActiveNetwork) {
          widget.saunaWifiStore.setSelectedWifi(saunaWifi);
          widget.saunaWifiStore.setConnectWifiPopup(true);
        }
      },
      child: Container(
        height: _screenSize.getHeight(min: 40, max: 56),
        width: _screenSize.getWidth(min: 140, max: 190),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 12, max: 20)),
          color: ThemeColors.blue50,
        ),
        child: Text(
          'Connect',
          style: TextStyle(
            fontSize: _screenSize.getFontSize(min: 14, max: 20),
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      height: 1,
      color: _theme.tickMarkColor,
    );
  }

  Widget _buildScanView() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ThemeColors.blue10,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.wifiOff.toSvgPicture(
            width: _screenSize.getWidth(min: 20, max: 24),
            height: _screenSize.getHeight(min: 20, max: 24),
          ),
          SizedBox(height: _screenSize.getHeight(min: 8, max: 16)),
          Text(
            'No wifi Networks Found',
            style: TextStyle(
              fontSize: _screenSize.getFontSize(min: 14, max: 20),
              fontWeight: FontWeight.normal,
              color: _theme.unselectedAudioIcon,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: _screenSize.getHeight(min: 24, max: 36)),
          FeedbackSoundWrapper(
            onTap: () {
              final isLoading = widget.saunaWifiStore.isLoadingScanWifi;
              if (isLoading) return;
              widget.saunaWifiStore.scanWifi();
            },
            child: Container(
              height: _screenSize.getHeight(min: 46, max: 56),
              width: _screenSize.getWidth(min: 200, max: 240),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 14, max: 20)),
                color: ThemeColors.blue50,
              ),
              alignment: Alignment.center,
              child: Text(
                'Scan Again',
                style: TextStyle(
                  fontSize: _screenSize.getFontSize(min: 14, max: 20),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
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
}

class _WifiScanSection extends StatelessWidget {
  final Function() onScanTap;

  const _WifiScanSection({
    Key? key,
    required this.onScanTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;

    return Container(
      color: theme.popupBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            height: screenSize.getHeight(min: 50, max: 80),
            padding: EdgeInsets.symmetric(horizontal: screenSize.getHeight(min: 16, max: 24)),
            decoration: BoxDecoration(
              color: theme.buttonColor,
              borderRadius: BorderRadius.circular(screenSize.getHeight(min: 14, max: 20)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'Didn’t find what you were looking for?',
                    style: TextStyle(
                      color: theme.titleTextColor,
                      fontSize: screenSize.getFontSize(min: 14, max: 20),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                FeedbackSoundWrapper(
                  onTap: onScanTap,
                  child: Container(
                    height: screenSize.getHeight(min: 50, max: 80),
                    alignment: Alignment.center,
                    child: Text(
                      'Scan Again',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.scanButtonTextColor,
                        fontSize: screenSize.getFontSize(min: 14, max: 20),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenSize.getHeight(min: 16, max: 24)),
        ],
      ),
    );
  }
}
