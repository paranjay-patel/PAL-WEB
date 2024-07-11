import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as listener;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/screen_utils.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/common/widgets/sauna_toast.dart';
import 'package:found_space_flutter_web_application/main.dart';
import 'package:found_space_flutter_web_application/pages/sauna_security_pin/store/sauna_security_pin_page.store.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:mobx/mobx.dart';

enum PinKeyboardKey {
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  space,
  zero,
  backspace;

  String get value {
    switch (this) {
      case PinKeyboardKey.one:
        return '1';
      case PinKeyboardKey.two:
        return '2';
      case PinKeyboardKey.three:
        return '3';
      case PinKeyboardKey.four:
        return '4';
      case PinKeyboardKey.five:
        return '5';
      case PinKeyboardKey.six:
        return '6';
      case PinKeyboardKey.seven:
        return '7';
      case PinKeyboardKey.eight:
        return '8';
      case PinKeyboardKey.nine:
        return '9';
      case PinKeyboardKey.space:
        return '';
      case PinKeyboardKey.zero:
        return '0';
      case PinKeyboardKey.backspace:
        return '';
    }
  }
}

class SaunaSecurityPinPage extends StatefulWidget {
  final SaunaSecurityPinPageState pageState;
  const SaunaSecurityPinPage({Key? key, required this.pageState}) : super(key: key);

  @override
  _SaunaSecurityPinPageState createState() => _SaunaSecurityPinPageState();
}

class _SaunaSecurityPinPageState extends State<SaunaSecurityPinPage> with TickerProviderStateMixin {
  late ColorScheme _theme;
  late ScreenSize _screenSize;

  final _store = SaunaSecurityPinPageStore();

  final _reaction = CompositeReactionDisposer();

  @override
  void initState() {
    super.initState();
    _store.setSaunaSecurityPinPageState(widget.pageState);

    reaction<bool?>((_) => _store.isSucceed, (isSucceed) {
      if (isSucceed == null) return;

      final type = isSucceed ? ToastType.message : ToastType.error;
      final message = isSucceed ? _store.pageState.successToastMessage : 'PIN did not match';
      _store.setSucceed(null);
      if (message != null) fToast.showSaunaToast(type: type, message: message);

      if (isSucceed) Navigator.pop(context, true);
    }).disposeWith(_reaction);

    reaction<int>(
      (_) => _store.dismissPopupSecondsRemaining,
      (secondsRemaining) {
        if (secondsRemaining == 0) {
          _store.cancelDismissPopupTimer();
          Navigator.pop(context);
        }
      },
    ).disposeWith(_reaction);
  }

  @override
  void dispose() {
    _reaction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context).colorScheme;
    _screenSize = Utils.getScreenSize(context);

    final isVerifyPairing = _store.pageState == SaunaSecurityPinPageState.verifyPairing ||
        _store.pageState == SaunaSecurityPinPageState.verifySettings;
    final height = MediaQuery.of(context).size.height;

    return FocusScope(
      skipTraversal: true,
      child: Scaffold(
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
                    width:
                        isVerifyPairing ? ScreenUtil.getWidth(context, 820) : _screenSize.getWidth(min: 400, max: 500),
                    height: isVerifyPairing ? height - _screenSize.getHeight(min: 60, max: 90) : null,
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 14, max: 20)),
                          color: _theme.popupBackgroundColor,
                          boxShadow: _theme.saunaControlPageButtonShadow,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(_screenSize.getWidth(min: 20, max: 30)),
                          child: Observer(builder: (context) {
                            final isForgetScreenOpen = _store.isForgetScreenOpen;
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  children: [
                                    _TitleAndCloseButton(store: _store),
                                    if (!isForgetScreenOpen) _buildTimer(context),
                                  ],
                                ),
                                if (isForgetScreenOpen) ...[
                                  Expanded(
                                    child: _ForgotScreen(entityName: locator<SaunaStore>().saunaEntityName ?? ''),
                                  ),
                                ] else ...[
                                  SizedBox(height: _screenSize.getWidth(min: 26, max: 36)),
                                  _PinSecurityBox(store: _store),
                                  SizedBox(height: _screenSize.getWidth(min: 26, max: 36)),
                                  if (isVerifyPairing)
                                    Expanded(child: Center(child: _PinSecurityKeyboard(store: _store)))
                                  else
                                    _PinSecurityKeyboard(store: _store),
                                ],
                                if (isVerifyPairing) ...[
                                  SizedBox(height: _screenSize.getWidth(min: 20, max: 24)),
                                  if (!isForgetScreenOpen)
                                    _ForgotButton(
                                      onTap: () {
                                        _store.setIsForgetScreenOpen(true);
                                      },
                                    ),
                                  Stack(
                                    children: [
                                      SizedBox(height: _screenSize.getWidth(min: 16, max: 20)),
                                      if (isForgetScreenOpen) _buildTimer(context),
                                    ],
                                  ),
                                ]
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
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
      final countdown = _store.dismissPopupSecondsRemaining;
      if (countdown > 10 || countdown <= 0) return const SizedBox();

      return Align(
        alignment: _store.isForgetScreenOpen ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: _store.isForgetScreenOpen ? 0 : 8),
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
    _store.cancelDismissPopupTimer();
    _store.startDismissPopupTimer();
  }
}

class _TitleAndCloseButton extends StatelessWidget {
  final SaunaSecurityPinPageStore store;

  const _TitleAndCloseButton({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context).colorScheme;
    final _screenSize = Utils.getScreenSize(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (store.isForgetScreenOpen)
              FeedbackSoundWrapper(
                onTap: () {
                  store.setIsForgetScreenOpen(false);
                },
                child: SizedBox(
                  width: _screenSize.getWidth(min: 40, max: 50),
                  height: _screenSize.getHeight(min: 40, max: 50),
                  child: Align(
                    alignment: Alignment.center,
                    child: Assets.arrowLeft.toSvgPicture(
                      width: _screenSize.getWidth(min: 20, max: 24),
                      height: _screenSize.getHeight(min: 20, max: 24),
                      color: _theme.iconColor,
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: _screenSize.getHeight(min: 20, max: 30),
                width: _screenSize.getWidth(min: 40, max: 60),
              ),
            const Spacer(),
            Observer(
              builder: (context) {
                return Text(
                  store.isForgetScreenOpen ? 'Forgot PIN' : store.pageAction.title,
                  style: TextStyle(
                    color: _theme.titleTextColor,
                    fontSize: _screenSize.getFontSize(min: 18, max: 24),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                );
              },
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
        ),
        Observer(builder: (context) {
          final secondsRemaining = store.secondsRemaining;
          if (store.isForgetScreenOpen) return const SizedBox();

          final secondsRemainingText = secondsRemaining <= 1 ? '1 second' : '$secondsRemaining seconds';

          if (store.pageState == SaunaSecurityPinPageState.verifyPairing ||
              store.pageState == SaunaSecurityPinPageState.verifySettings) {
            return Padding(
              padding: EdgeInsets.only(
                top: _screenSize.getWidth(min: 26, max: 36),
                bottom: _screenSize.getWidth(min: 16, max: 20),
              ),
              child: Text(
                store.isDisabledState
                    ? 'The provided PIN is incorrect.\nPlease wait for $secondsRemainingText before attempting another entry.'
                    : store.pageState == SaunaSecurityPinPageState.verifySettings
                        ? 'The device settings are currently secured.\nPlease enter the 6-digit device PIN to unlock access to the settings.'
                        : 'This device is currently secured for mobile pairing.\nKindly input the device PIN to unlock the pairing feature.',
                style: TextStyle(
                  color: _theme.iconColor,
                  fontSize: _screenSize.getFontSize(min: 16, max: 20),
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return const SizedBox();
          }
        }),
      ],
    );
  }
}

class _PinButton extends StatelessWidget {
  const _PinButton({
    Key? key,
    required this.onTap,
    required this.keyboardKey,
    this.isDisabled = false,
  }) : super(key: key);

  final VoidCallback onTap;
  final PinKeyboardKey keyboardKey;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final _screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;
    final color = isDisabled ? theme.pinButtonDisabledColor : ThemeColors.primaryBlueColor;
    if (keyboardKey == PinKeyboardKey.space) {
      return SizedBox(
        width: _screenSize.getWidth(min: 60, max: 80),
        height: _screenSize.getHeight(min: 60, max: 80),
      );
    }

    return FeedbackSoundWrapper(
      onTap: onTap,
      shouldPlay: !isDisabled,
      child: SizedBox(
        width: _screenSize.getWidth(min: 60, max: 80),
        height: _screenSize.getHeight(min: 60, max: 80),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 16, max: 20)),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: keyboardKey == PinKeyboardKey.backspace
                ? Assets.backspace.toSvgPicture(
                    width: _screenSize.getHeight(min: 24, max: 32),
                    height: _screenSize.getHeight(min: 24, max: 32),
                    color: color,
                  )
                : Text(
                    keyboardKey.value,
                    style: TextStyle(
                      color: color,
                      fontSize: _screenSize.getFontSize(min: 16, max: 20),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
        ),
      ),
    );
  }
}

class _PinSecurityBox extends StatelessWidget {
  final SaunaSecurityPinPageStore store;
  const _PinSecurityBox({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final securityPins = store.securityPins;

        final widgets = <Widget>[];
        for (int i = 0; i < 6; i++) {
          final isSelected = i < securityPins.length;
          widgets.add(_buildPinBox(context, isSelected: isSelected, isDisabled: store.isDisabledState));
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widgets,
        );
      },
    );
  }

  Widget _buildPinBox(BuildContext context, {required bool isSelected, bool isDisabled = false}) {
    final screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        width: screenSize.getHeight(min: 18, max: 24),
        height: screenSize.getHeight(min: 18, max: 24),
        alignment: Alignment.center,
        child: Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                Border.all(color: isDisabled ? theme.pinButtonDisabledColor : ThemeColors.primaryBlueColor, width: 2),
            color: isSelected ? ThemeColors.primaryBlueColor : Colors.transparent,
          ),
        ),
      ),
    );
  }
}

class _PinSecurityKeyboard extends StatelessWidget {
  final SaunaSecurityPinPageStore store;
  const _PinSecurityKeyboard({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenSize = Utils.getScreenSize(context);
    return Observer(
      builder: (context) {
        final isDisabled = store.isDisabledState;

        return SizedBox(
          width: _screenSize.getWidth(min: 200, max: 250),
          height: _screenSize.getHeight(min: 300, max: 350),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: _screenSize.getWidth(min: 18, max: 24),
              mainAxisSpacing: _screenSize.getWidth(min: 18, max: 24),
            ),
            itemCount: PinKeyboardKey.values.length,
            itemBuilder: (BuildContext context, int index) {
              final keyboardKey = PinKeyboardKey.values[index];
              return _PinButton(
                keyboardKey: keyboardKey,
                isDisabled: isDisabled,
                onTap: () {
                  if (isDisabled) return;

                  switch (keyboardKey) {
                    case PinKeyboardKey.one:
                    case PinKeyboardKey.two:
                    case PinKeyboardKey.three:
                    case PinKeyboardKey.four:
                    case PinKeyboardKey.five:
                    case PinKeyboardKey.six:
                    case PinKeyboardKey.seven:
                    case PinKeyboardKey.eight:
                    case PinKeyboardKey.nine:
                    case PinKeyboardKey.zero:
                      store.setSecurityPin(keyboardKey.value);
                      break;
                    case PinKeyboardKey.space:
                      break;
                    case PinKeyboardKey.backspace:
                      store.removeSecurityPin();
                      break;
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _ForgotButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ForgotButton({Key? key, required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;
    return Container(
      width: _screenSize.getWidth(min: 200, max: 250),
      height: _screenSize.getHeight(min: 40, max: 50),
      alignment: Alignment.center,
      child: FeedbackSoundWrapper(
        onTap: onTap,
        child: Text(
          'Forgot PIN?',
          style: TextStyle(
            color: theme.forgotButtonColor,
            fontSize: _screenSize.getFontSize(min: 16, max: 20),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ForgotScreen extends StatelessWidget {
  final String entityName;

  const _ForgotScreen({Key? key, required this.entityName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenSize = Utils.getScreenSize(context);
    final _theme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _screenSize.getHeight(min: 60, max: 80)),
        child: Text(
          'If you need help unlocking the device, please reach out to $entityName support.',
          style: TextStyle(
            color: _theme.titleTextColor,
            fontSize: _screenSize.getFontSize(min: 16, max: 20),
            fontWeight: FontWeight.normal,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
