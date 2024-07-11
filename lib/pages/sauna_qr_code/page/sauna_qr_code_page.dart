import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/screen_utils.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/themed_activity_indicator.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/widgets/no_internet_connection.dart';
import 'package:found_space_flutter_web_application/pages/sauna_qr_code/store/sauna_qr_code.store.dart';
import 'package:mobx/mobx.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';

class SaunaControlQRPage extends StatefulWidget {
  const SaunaControlQRPage({Key? key}) : super(key: key);

  @override
  _SaunaControlQRPageState createState() => _SaunaControlQRPageState();
}

class _SaunaControlQRPageState extends State<SaunaControlQRPage> {
  late ScreenSize _screenSize;
  final _reaction = CompositeReactionDisposer();
  final _saunaStore = locator<SaunaStore>();

  final _store = SaunaQRCodeStore();

  @override
  void initState() {
    reaction<PopupType>(
      (_) => _saunaStore.popupType,
      (type) {
        if (type == PopupType.bluetooth) {
          Navigator.of(context).pop();
        }
      },
      fireImmediately: true,
    ).disposeWith(_reaction);

    reaction<int>(
      (_) => _store.secondsRemaining,
      (secondsRemaining) {
        if (secondsRemaining == 0) {
          _store.cancelTimer();
          Navigator.pop(context);
        }
      },
    ).disposeWith(_reaction);
    super.initState();
  }

  @override
  void dispose() {
    _store.dispose();
    _reaction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = Utils.getScreenSize(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.mainPopupBackgroundColor,
      body: InkWell(
        onTap: () {
          _store.cancelTimer();
          Navigator.pop(context);
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          color: Theme.of(context).colorScheme.mainPopupBaseBackgroundColor,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: _screenSize.getHeight(min: 30, max: 45)),
                  Expanded(
                    child: _buildCenterWidget(),
                  ),
                  SizedBox(height: _screenSize.getHeight(min: 30, max: 45)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterWidget() {
    return InkWell(
      onTap: () {},
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: ScreenUtil.getWidth(context, 820),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: ThemeColors.neutral900.withOpacity(0.04),
              blurRadius: 1,
              offset: const Offset(0, 0),
            ),
            BoxShadow(
              color: ThemeColors.neutral900.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: const Color(0xffE6E6E6).withOpacity(.07),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: ScreenUtil.getHeight(context, 28)),
                _buildTitleAndCloseButton(),
                SizedBox(height: ScreenUtil.getHeight(context, 30)),
                Expanded(
                  child: Observer(builder: (context) {
                    final isInternetConnected = _store.isInternetConnected;
                    if (!isInternetConnected) {
                      return NoInternetConnection(
                        onTap: () {
                          Navigator.pop(context, true);
                        },
                        noInternetConnectionPageType: NoInternetConnectionPageType.qrCode,
                      );
                    } else {
                      return _qrCodeWidget();
                    }
                  }),
                ),
              ],
            ),
            _buildTimer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimer() {
    return Observer(builder: (context) {
      final countdown = _store.secondsRemaining;
      if (countdown > 10 || countdown <= 0) return const SizedBox();

      return Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.only(
            top: _screenSize.getHeight(min: 30, max: 45),
            left: _screenSize.getHeight(min: 30, max: 45),
          ),
          child: Text(
            '$countdown',
            style: TextStyle(
              color: ThemeColors.grey90,
              fontSize: _screenSize.getFontSize(min: 16, max: 20),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      );
    });
  }

  Widget _qrCodeWidget() {
    final isLoading = _store.isLoading;
    final deviceHeight = MediaQuery.of(context).size.height;
    final topAndBottomSpacing = _screenSize.getHeight(min: 80, max: 100);
    final spacing = ScreenUtil.getHeight(context, 200);
    final imageHeight = ScreenUtil.getHeight(context, 200);
    final height = deviceHeight - (topAndBottomSpacing + spacing + imageHeight);
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.qrCodeOne.toSvgPicture(
              width: _screenSize.getHeight(min: 80, max: 100),
              height: _screenSize.getHeight(min: 80, max: 100),
              color: ThemeColors.grey70,
            ),
            SizedBox(width: _screenSize.getHeight(min: 10, max: 16)),
            Assets.qrCodeTwo.toSvgPicture(
              width: _screenSize.getHeight(min: 80, max: 100),
              height: _screenSize.getHeight(min: 80, max: 100),
              color: ThemeColors.grey70,
            ),
            Assets.qrCodeThree.toSvgPicture(
              width: _screenSize.getHeight(min: 80, max: 100),
              height: _screenSize.getHeight(min: 80, max: 100),
              color: ThemeColors.grey70,
            ),
          ],
        ),
        SizedBox(height: _screenSize.getHeight(min: 18, max: 24)),
        Text(
          'Scan QR code to connect the sauna with the Found—Space app\nand allow you to manage sauna remotely.',
          style: TextStyle(
            color: ThemeColors.grey80,
            fontSize: _screenSize.getFontSize(min: 16, max: 20),
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: _screenSize.getHeight(min: 25, max: 50)),
        Expanded(
          child: SizedBox(
            height: double.infinity,
            child: isLoading
                ? const Center(
                    child: ThemedActivityIndicator(
                      isLightColorIndicator: false,
                    ),
                  )
                : PrettyQr(
                    size: height,
                    data: _store.qrCode,
                    errorCorrectLevel: QrErrorCorrectLevel.M,
                    roundEdges: true,
                    elementColor: ThemeColors.grey90,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleAndCloseButton() {
    final padding = _screenSize.getHeight(min: 16, max: 24);
    return Padding(
      padding: EdgeInsets.only(left: padding, right: padding),
      child: Row(
        children: [
          SizedBox(width: ScreenUtil.getWidth(context, 30)),
          Expanded(
            child: Text(
              'Connect to the mobile app',
              style: TextStyle(
                color: ThemeColors.grey90,
                fontSize: _screenSize.getFontSize(min: 18, max: 24),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 10),
          FeedbackSoundWrapper(
            onTap: () {
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
                  color: ThemeColors.grey80,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
