import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as listener;
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
import 'package:found_space_flutter_web_application/pages/sauna_update_page/store/sauna_update_page.store.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:mobx/mobx.dart';

class SaunaUpdatePage extends StatefulWidget {
  const SaunaUpdatePage({Key? key}) : super(key: key);

  @override
  _SaunaUpdatePageState createState() => _SaunaUpdatePageState();
}

class _SaunaUpdatePageState extends State<SaunaUpdatePage> with TickerProviderStateMixin {
  late ColorScheme _theme;
  late ScreenSize _screenSize;

  final _saunaStore = locator<SaunaStore>();

  final _reaction = CompositeReactionDisposer();

  final _store = SaunaUpdatePageStore();

  @override
  void initState() {
    super.initState();

    _store.startTimer();

    reaction((_) => _saunaStore.saunaUpdateState, (rest_api_models.SaunaUpdateState? saunaUpdateState) async {
      if (saunaUpdateState == rest_api_models.SaunaUpdateState.failed) {
        Navigator.pop(context);
      }
    }).disposeWith(_reaction);

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
    _reaction.dispose();
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context).colorScheme;
    _screenSize = Utils.getScreenSize(context);

    return FocusScope(
      skipTraversal: true,
      child: Scaffold(
        backgroundColor: _theme.mainPopupBackgroundColor,
        body: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Observer(
            builder: (_) {
              final saunaUpdateState = _saunaStore.saunaUpdateState;
              final showSaunaUpdateButton = saunaUpdateState == rest_api_models.SaunaUpdateState.standby ||
                  saunaUpdateState == rest_api_models.SaunaUpdateState.failed ||
                  saunaUpdateState == rest_api_models.SaunaUpdateState.success;
              final isLoading = _saunaStore.isSaunaUpdateLoading;

              return listener.Listener(
                onPointerDown: (_) => _resetTimer(),
                onPointerMove: (_) => _resetTimer(),
                onPointerUp: (_) => _resetTimer(),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: _theme.mainPopupBaseBackgroundColor,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                          child: Center(
                            child: Container(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  width: _screenSize.getWidth(min: 680, max: 820),
                                  height: _screenSize.getHeight(min: 550, max: 660),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 14, max: 20)),
                                    color: _theme.popupBackgroundColor,
                                    boxShadow: _theme.saunaControlPageButtonShadow,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(_screenSize.getWidth(min: 20, max: 30)),
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            _TitleAndCloseButton(showSaunaUpdateButton: showSaunaUpdateButton),
                                            _buildTimer(context),
                                          ],
                                        ),
                                        SizedBox(width: _screenSize.getWidth(min: 24, max: 32)),
                                        if (showSaunaUpdateButton)
                                          Expanded(child: _Description(text: _descriptionText()))
                                        else
                                          _Description(text: _descriptionText()),
                                        if (!showSaunaUpdateButton) ...[
                                          SizedBox(height: _screenSize.getWidth(min: 80, max: 100)),
                                          const ThemedActivityIndicator(),
                                        ],
                                        if (showSaunaUpdateButton)
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: _CancelButton(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                              SizedBox(width: _screenSize.getWidth(min: 24, max: 32)),
                                              Expanded(
                                                child: _UpdateButton(
                                                  isLoading: isLoading,
                                                  onTap: () {
                                                    if (isLoading) return;
                                                    _saunaStore.saunaUpdate();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
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
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _descriptionText() {
    final saunaUpdateState = _saunaStore.saunaUpdateState;

    if (saunaUpdateState != null) {
      if (saunaUpdateState == rest_api_models.SaunaUpdateState.standby) {
        return 'Once the update is installed, the sauna will restart. Please note that you won\'t be able to use the sauna during the update process.\n\nThe update to version ${_saunaStore.pendingFirmwareVersion}.';
      } else {
        return 'Updating Firmware from version ${_saunaStore.firmwareVersion} to version ${_saunaStore.pendingFirmwareVersion}. Do not turn off the system during the update.';
      }
    }
    return '';
  }

  Widget _buildTimer(BuildContext context) {
    final _screenSize = Utils.getScreenSize(context);
    return Observer(builder: (context) {
      final countdown = _store.secondsRemaining;
      if (countdown > 10 || countdown <= 0) return const SizedBox();

      return Align(
        alignment: Alignment.centerLeft,
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

class _TitleAndCloseButton extends StatelessWidget {
  final bool showSaunaUpdateButton;
  const _TitleAndCloseButton({
    Key? key,
    required this.showSaunaUpdateButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context).colorScheme;
    final _screenSize = Utils.getScreenSize(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: _screenSize.getHeight(min: 20, max: 30),
          width: _screenSize.getWidth(min: 40, max: 60),
        ),
        const Spacer(),
        Text(
          showSaunaUpdateButton ? 'Update Firmware?' : 'Updating Firmware',
          style: TextStyle(
            color: _theme.titleTextColor,
            fontSize: _screenSize.getFontSize(min: 18, max: 24),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer(),
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
                color: _theme.iconColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _UpdateButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;

  const _UpdateButton({
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);

    return FeedbackSoundWrapper(
      onTap: onTap,
      child: Container(
        height: screenSize.getHeight(min: 46, max: 56),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenSize.getHeight(min: 14, max: 20)),
          color: ThemeColors.primaryBlueColor,
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const ThemedActivityIndicator(isLightColorIndicator: true)
            : Text(
                'Yes, Update Firmware',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
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
            fontWeight: FontWeight.w600,
            fontSize: screenSize.getFontSize(min: 16, max: 20),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final String text;
  const _Description({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Text(
        text,
        style: TextStyle(
          color: theme.titleTextColor,
          fontWeight: FontWeight.w300,
          height: 1.8,
          fontSize: screenSize.getFontSize(min: 17, max: 20),
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
