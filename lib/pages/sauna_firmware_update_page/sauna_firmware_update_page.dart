import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as listener;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_firmware_update_page/store/sauna_firmware_update_page.store.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:mobx/mobx.dart';

enum SaunaFirmwareUpdatePageType {
  updateAvailable,
  forceUpdate;

  String get title {
    switch (this) {
      case SaunaFirmwareUpdatePageType.updateAvailable:
        return 'Updates are available!';
      case SaunaFirmwareUpdatePageType.forceUpdate:
        return 'The firmware will be updated';
    }
  }

  String description(String version) {
    switch (this) {
      case SaunaFirmwareUpdatePageType.updateAvailable:
        return 'The latest firmware update, version $version, brings several significant improvements that will enhance your overall experience with the sauna. Would you like to proceed with the update?';
      case SaunaFirmwareUpdatePageType.forceUpdate:
        return 'To ensure optimal performance of the sauna, the firmware will be updated to version $version';
    }
  }
}

class SaunaFirmwareUpdatePage extends StatefulWidget {
  final SaunaFirmwareUpdatePageType type;
  const SaunaFirmwareUpdatePage({Key? key, required this.type}) : super(key: key);

  @override
  _SaunaFirmwareUpdatePageState createState() => _SaunaFirmwareUpdatePageState();
}

class _SaunaFirmwareUpdatePageState extends State<SaunaFirmwareUpdatePage> {
  late ColorScheme _theme;
  late ScreenSize _screenSize;
  final _saunaStore = locator<SaunaStore>();
  final _store = SaunaFirmwareUpdatePageStore();
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
          _saunaStore.setUpdateAfterSessionTapped(true);
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

    return Scaffold(
      backgroundColor: _theme.mainPopupBackgroundColor,
      body: listener.Listener(
        onPointerDown: (_) => _resetTimer(),
        onPointerMove: (_) => _resetTimer(),
        onPointerUp: (_) => _resetTimer(),
        child: InkWell(
          onTap: () {
            if (widget.type == SaunaFirmwareUpdatePageType.forceUpdate) {
              _saunaStore.setUpdateAfterSessionTapped(true);
            }

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
                      return Container(
                        width: _screenSize.getWidth(
                          min: widget.type == SaunaFirmwareUpdatePageType.forceUpdate ? 500 : 525,
                          max: 600,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 14, max: 20)),
                          color: _theme.popupBackgroundColor,
                          boxShadow: _theme.saunaControlPageButtonShadow,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: _screenSize.getWidth(min: 24, max: 30)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: _screenSize.getHeight(min: 18, max: 24)),
                              Stack(
                                children: [
                                  Center(
                                    child: _TitleText(title: widget.type.title),
                                  ),
                                  _buildTimer(context),
                                ],
                              ),
                              SizedBox(height: _screenSize.getHeight(min: 30, max: 40)),
                              Observer(
                                builder: (context) {
                                  final version = _saunaStore.pendingFirmwareVersion ?? '';
                                  return _DescriptionText(description: widget.type.description(version));
                                },
                              ),
                              Observer(
                                builder: (context) {
                                  var pendingUpdateReleaseNotes = _saunaStore.pendingUpdateReleaseNotes;
                                  if (pendingUpdateReleaseNotes.isEmpty &&
                                      widget.type == SaunaFirmwareUpdatePageType.updateAvailable) {
                                    pendingUpdateReleaseNotes = [
                                      'This update brings performance enhancements, as well as important bug fixes, ensuring a smoother and more enjoyable sauna experience'
                                    ];
                                  }

                                  return ScrollConfiguration(
                                    behavior: ScrollConfiguration.of(context).copyWith(
                                      dragDevices: {
                                        PointerDeviceKind.touch,
                                        PointerDeviceKind.mouse,
                                      },
                                    ),
                                    child: SizedBox(
                                      height: pendingUpdateReleaseNotes.length <= 6
                                          ? null
                                          : _screenSize.getHeight(min: 200, max: 250),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(height: _screenSize.getHeight(min: 8, max: 16)),
                                            ...pendingUpdateReleaseNotes.map((note) {
                                              return _DescriptionText(
                                                description: note,
                                                fontSize: _screenSize.getFontSize(min: 12, max: 18),
                                                isBulletPoint: _saunaStore.pendingUpdateReleaseNotes.isNotEmpty,
                                              );
                                            }).toList(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (widget.type == SaunaFirmwareUpdatePageType.forceUpdate) ...[
                                SizedBox(height: _screenSize.getHeight(min: 24, max: 30)),
                                const _DescriptionText(
                                  description:
                                      'Once your sauna session is finished, the update will automatically begin.',
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                              SizedBox(height: _screenSize.getHeight(min: 30, max: 40)),
                              if (widget.type == SaunaFirmwareUpdatePageType.updateAvailable)
                                Row(
                                  children: [
                                    _Button(
                                      buttonText: 'Remind me later',
                                      height: _screenSize.getHeight(min: 40, max: 50),
                                      usedBorder: true,
                                      onTap: () {
                                        _saunaStore.setRemindMeLaterForUpdateTapped(false);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    const Spacer(),
                                    _Button(
                                      buttonText: 'Update after session',
                                      height: _screenSize.getHeight(min: 40, max: 50),
                                      onTap: () {
                                        _saunaStore.setUpdateAfterSessionTapped(true);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                )
                              else
                                Center(
                                  child: _Button(
                                    buttonText: 'OK',
                                    height: _screenSize.getHeight(min: 40, max: 50),
                                    onTap: () {
                                      _saunaStore.setUpdateAfterSessionTapped(true);
                                      Navigator.pop(context);
                                    },
                                  ),
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

class _TitleText extends StatelessWidget {
  final String title;
  const _TitleText({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final screenSize = Utils.getScreenSize(context);

    return Text(
      title,
      style: TextStyle(
        fontSize: screenSize.getFontSize(min: 18, max: 24),
        fontWeight: FontWeight.bold,
        color: theme.titleTextColor,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _DescriptionText extends StatelessWidget {
  final String description;
  final FontWeight fontWeight;
  final double? fontSize;
  final bool isBulletPoint;

  const _DescriptionText({
    required this.description,
    this.fontWeight = FontWeight.w300,
    this.fontSize,
    this.isBulletPoint = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final screenSize = Utils.getScreenSize(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isBulletPoint)
          Text(
            ' • ',
            style: TextStyle(
              fontSize: fontSize ?? screenSize.getFontSize(min: 14, max: 20),
              fontWeight: fontWeight,
              color: theme.titleTextColor,
              height: 1.8,
            ),
            textAlign: TextAlign.left,
          ),
        Expanded(
          child: Text(
            description,
            style: TextStyle(
              fontSize: fontSize ?? screenSize.getFontSize(min: 14, max: 20),
              fontWeight: fontWeight,
              color: theme.titleTextColor,
              height: 1.8,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ],
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
        width: screenSize.getHeight(min: 220, max: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenSize.getHeight(min: 14, max: 20)),
          color: usedBorder ? null : ThemeColors.primaryBlueColor,
          border: usedBorder ? Border.all(color: ThemeColors.primaryBlueColor, width: 2) : null,
        ),
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: screenSize.getFontSize(min: 14, max: 20),
            fontWeight: FontWeight.w600,
            color: usedBorder ? ThemeColors.primaryBlueColor : ThemeColors.neutral000,
          ),
        ),
      ),
    );
  }
}
