import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/sauna_value_utils.dart';
import 'package:found_space_flutter_web_application/common/store/audio_player.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_bluetooth_store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/common/svg_asset_image.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_font.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/common/utils/extension_function.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/utils/sauna_audio_control_utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_page_common.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:lottie/lottie.dart';

enum SaunaSimpleModeType {
  temperature,
  time,
}

class SaunaSimpleModePage extends StatefulWidget {
  final Function() onTap;
  const SaunaSimpleModePage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<SaunaSimpleModePage> createState() => _SaunaSimpleModePageState();
}

class _SaunaSimpleModePageState extends State<SaunaSimpleModePage> with AutomaticKeepAliveClientMixin {
  final _saunaStore = locator<SaunaStore>();
  late ScreenSize _screenSize;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _screenSize = Utils.getScreenSize(context);

    return Scaffold(
      body: InkWell(
        onTap: widget.onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF000000),
                Color(0xFF181B24),
              ],
            ),
          ),
          child: Observer(
            builder: (context) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  InkWell(
                    onTap: widget.onTap,
                    child: Padding(
                      padding: EdgeInsets.only(top: _screenSize.getHeight(min: 60, max: 80)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const _Tile(type: SaunaSimpleModeType.temperature),
                          SizedBox(width: _screenSize.getWidth(min: 96, max: 130)),
                          const _Tile(type: SaunaSimpleModeType.time),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Observer(
                        builder: (context) {
                          final saunaDeviceState = _saunaStore.saunaState;
                          return Padding(
                            padding: EdgeInsets.only(top: _screenSize.getHeight(min: 110, max: 130)),
                            child: InkWell(
                              onTap: () {},
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Text(
                                key: Key(saunaDeviceState.name),
                                saunaDeviceState.subtitleText,
                                style: TextStyle(
                                  color: ThemeColors.dark20,
                                  fontSize: _screenSize.getFontSize(min: 20, max: 24),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      _AudioUplift(),
                      const _ProgramModifiedSection(),
                      const _FirmwareUpdateInfo(),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final SaunaSimpleModeType type;

  const _Tile({Key? key, required this.type}) : super(key: key);

  bool get isEnabledMinusButton {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final saunaStore = locator<SaunaStore>();
    final _saunaLocalStorageStore = locator<SaunaLocalStorageStore>();
    return Observer(builder: (context) {
      final targetTemperature = SaunaValueUtils.getTargetTemperature(saunaStore.targetTemperature.round(),
          temperatureScale: _saunaLocalStorageStore.temperatureScale);
      final targetTimer = SaunaValueUtils.getTargetTimer(saunaStore.targetTimer);
      final currentAverageTemperature = SaunaValueUtils.getAverageTemperature(
        saunaStore.currentAverageTemperature,
        temperatureScale: _saunaLocalStorageStore.temperatureScale,
        addLeadingZero: true,
      );

      final isEnabledMinusButton =
          type == SaunaSimpleModeType.time ? saunaStore.targetTimer > 1 : saunaStore.targetTemperature > 20;

      final isEnabledPlusButton =
          type == SaunaSimpleModeType.time ? saunaStore.targetTimer < 60 : saunaStore.targetTemperature < 70;

      return InkWell(
        onTap: () {},
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Button(
                    key: Key(type == SaunaSimpleModeType.time ? 'time_minus_button' : 'temperature_minus_button'),
                    assetImage: Assets.minus,
                    isEnabled: isEnabledMinusButton,
                    onTap: () {
                      if (type == SaunaSimpleModeType.time) {
                        if (saunaStore.targetTimer <= 1) return;
                        saunaStore.updateTargetTime(
                          targetTime: saunaStore.targetTimer - 1,
                        );
                      } else {
                        if (saunaStore.targetTemperature <= 20) return;
                        saunaStore.updateTargetTemperature(
                          targetTemperature: saunaStore.targetTemperature - 1,
                        );
                      }
                    },
                  ),
                  SizedBox(width: screenSize.getWidth(min: 24, max: 36)),
                  if (type == SaunaSimpleModeType.time)
                    _TimerText(targetProgramDuration: saunaStore.remainingTime)
                  else
                    Text(
                      currentAverageTemperature,
                      style: TextStyle(
                        color: const Color(0xffF3F5FF),
                        fontSize: screenSize.getFontSize(min: 80, max: 100),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  SizedBox(width: screenSize.getWidth(min: 24, max: 36)),
                  _Button(
                    key: Key(type == SaunaSimpleModeType.time ? 'time_plus_button' : 'temperature_plus_button'),
                    assetImage: Assets.plus,
                    isEnabled: isEnabledPlusButton,
                    onTap: () {
                      if (type == SaunaSimpleModeType.time) {
                        if (saunaStore.targetTimer >= 60) return;
                        saunaStore.updateTargetTime(
                          targetTime: saunaStore.targetTimer + 1,
                        );
                      } else {
                        if (saunaStore.targetTemperature >= 70) return;
                        saunaStore.updateTargetTemperature(
                          targetTemperature: saunaStore.targetTemperature + 1,
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: screenSize.getHeight(min: 4, max: 10)),
              Text(
                key: Key(type == SaunaSimpleModeType.time ? 'target_session_text' : 'target_temperature_text'),
                type == SaunaSimpleModeType.time ? targetTimer : targetTemperature,
                style: TextStyle(
                  color: ThemeColors.dark10,
                  fontSize: screenSize.getFontSize(min: 18, max: 24),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _TimerText extends StatelessWidget {
  final int targetProgramDuration;

  const _TimerText({Key? key, required this.targetProgramDuration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: targetProgramDuration < 10 ? '0${targetProgramDuration}' : '${targetProgramDuration}',
            style: TextStyle(
              color: const Color(0xffF3F5FF),
              fontSize: screenSize.getFontSize(min: 80, max: 100),
              fontWeight: FontWeight.w600,
              fontFamily: ThemeFont.defaultFontFamily,
            ),
          ),
          TextSpan(
            text: targetProgramDuration > 1.0 ? 'mins' : 'min',
            style: TextStyle(
              color: const Color(0xffF3F5FF),
              fontSize: screenSize.getFontSize(min: 40, max: 60),
              fontWeight: FontWeight.w600,
              fontFamily: ThemeFont.defaultFontFamily,
            ),
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final SvgAssetImage assetImage;
  final Function() onTap;
  final bool isEnabled;

  const _Button({
    Key? key,
    required this.assetImage,
    required this.onTap,
    required this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    return FeedbackSoundWrapper(
      shouldPlay: isEnabled,
      onTap: onTap,
      child: Opacity(
        opacity: isEnabled ? 1 : .5,
        child: Container(
          height: screenSize.getHeight(min: 68, max: 80),
          width: screenSize.getWidth(min: 68, max: 80),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: ThemeColors.dark60, width: 1),
          ),
          alignment: Alignment.center,
          child: assetImage.toSvgPicture(
            width: screenSize.getWidth(min: 28, max: 36),
            height: screenSize.getHeight(min: 28, max: 36),
            color: ThemeColors.orange10,
          ),
        ),
      ),
    );
  }
}

class _ProgramModifiedSection extends StatelessWidget {
  const _ProgramModifiedSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final saunaStore = locator<SaunaStore>();
    return Observer(builder: (context) {
      final height = screenSize.getHeight(min: 46, max: 68);

      if (!saunaStore.programChangedIndicatorsAreEnabled) {
        return const SizedBox();
      }

      return Padding(
        padding: EdgeInsets.only(
          bottom: screenSize.getHeight(
            min: saunaStore.showFirmwareUpdateInfo ? 20 : 40,
            max: saunaStore.showFirmwareUpdateInfo ? 30 : 50,
          ),
          left: screenSize.getWidth(min: 100, max: 120),
          right: screenSize.getWidth(min: 100, max: 120),
        ),
        child: InkWell(
          onTap: () {},
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenSize.getHeight(min: 6, max: 12)),
              border: Border.all(color: ThemeColors.dark70, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: screenSize.getHeight(min: 14, max: 24)),
                Text(
                  'Program has been modified',
                  key: const Key('program_modified'),
                  style: TextStyle(
                    fontSize: screenSize.getFontSize(min: 14, max: 20),
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.dark10,
                  ),
                  textAlign: TextAlign.left,
                ),
                const Spacer(),
                _ProgramButton(
                  key: const Key('button_reset_key'),
                  buttonText: 'Reset',
                  height: height,
                  width: height + screenSize.getHeight(min: 6, max: 10),
                  onTap: () async {
                    if (saunaStore.isResettingProgram) return;
                    await saunaStore.resetModifiedProgram();
                  },
                ),
                SizedBox(width: screenSize.getHeight(min: 2, max: 6)),
                _ProgramButton(
                  key: const Key('button_save_key'),
                  buttonText: 'Save',
                  height: height,
                  width: height + screenSize.getHeight(min: 6, max: 10),
                  onTap: () async {
                    if (saunaStore.isResettingProgram) return;
                    await saunaStore.saveModifiedProgram();
                  },
                ),
                SizedBox(width: screenSize.getHeight(min: 14, max: 24)),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class _ProgramButton extends StatelessWidget {
  final String buttonText;
  final double height;
  final double width;
  final Function() onTap;

  const _ProgramButton({
    Key? key,
    required this.buttonText,
    required this.height,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);

    return FeedbackSoundWrapper(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: screenSize.getFontSize(min: 14, max: 20),
            fontWeight: FontWeight.w600,
            color: ThemeColors.blue50,
          ),
        ),
      ),
    );
  }
}

class _AudioUplift extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final saunaStore = locator<SaunaStore>();
    final audioPlayerStore = locator<AudioPlayerStore>();
    final saunaBluetoothStore = locator<SaunaBluetoothStore>();

    return Observer(builder: (context) {
      final isMusicPlaying = saunaBluetoothStore.isMusicPlaying;
      final trackTitle = saunaBluetoothStore.trackTitle.isNotEmpty ? saunaBluetoothStore.trackTitle : 'Unknown Title';
      final trackArtist =
          saunaBluetoothStore.trackArtist.isNotEmpty ? saunaBluetoothStore.trackArtist : 'Unknown Artist';

      final isAmbientSoundPlaying = saunaBluetoothStore.isAmbientSoundPlaying;
      final sounds = audioPlayerStore.selectedSaunaAmbiences.map((ambience) => ambience.type.title).toList();

      return Padding(
        padding: EdgeInsets.only(
          bottom: screenSize.getHeight(
            min: saunaStore.showFirmwareUpdateInfo ? 20 : 40,
            max: saunaStore.showFirmwareUpdateInfo ? 30 : 50,
          ),
        ),
        child: isMusicPlaying
            ? Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (saunaBluetoothStore.trackTitle.isNotEmpty) ...[
                        Lottie.asset(
                          Assets.musicPlay,
                          animate: true,
                          repeat: true,
                          width: screenSize.getHeight(min: 18, max: 24),
                          height: screenSize.getHeight(min: 18, max: 24),
                        ),
                        SizedBox(width: screenSize.getWidth(min: 8, max: 12)),
                      ],
                      _AudioTitle(title: trackTitle),
                    ],
                  ),
                  SizedBox(height: screenSize.getHeight(min: 4, max: 8)),
                  _TrackGenreText(text: trackArtist),
                ],
              )
            : isAmbientSoundPlaying
                ? Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Lottie.asset(
                            Assets.musicPlay,
                            animate: true,
                            repeat: true,
                            width: screenSize.getHeight(min: 18, max: 24),
                            height: screenSize.getHeight(min: 18, max: 24),
                          ),
                        ),
                        SizedBox(width: screenSize.getWidth(min: 8, max: 12)),
                        ...sounds
                            .mapWithIndex(
                              (sound, index) => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _AudioTitle(title: sound),
                                  if (index != sounds.length - 1) _DotText(),
                                ],
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  )
                : const SizedBox(),
      );
    });
  }
}

class _AudioTitle extends StatelessWidget {
  final String title;
  const _AudioTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    return Text(
      title,
      style: TextStyle(
        fontSize: screenSize.getFontSize(min: 14, max: 20),
        fontWeight: FontWeight.w600,
        color: ThemeColors.orange10,
      ),
    );
  }
}

class _TrackGenreText extends StatelessWidget {
  final String text;
  const _TrackGenreText({required this.text});

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    return Text(
      text,
      style: TextStyle(
        fontSize: screenSize.getFontSize(min: 14, max: 20),
        fontWeight: FontWeight.w600,
        color: ThemeColors.dark10,
      ),
    );
  }
}

class _DotText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.getWidth(min: 8, max: 12)),
      child: Text(
        '•',
        style: TextStyle(
          fontSize: screenSize.getFontSize(min: 14, max: 20),
          fontWeight: FontWeight.w600,
          color: ThemeColors.orange10,
        ),
      ),
    );
  }
}

class _FirmwareUpdateInfo extends StatelessWidget {
  const _FirmwareUpdateInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final saunaStore = locator<SaunaStore>();
    return Observer(builder: (context) {
      final height = screenSize.getHeight(min: 46, max: 68);

      if (!saunaStore.showFirmwareUpdateInfo) {
        return const SizedBox();
      }

      return UnconstrainedBox(
        child: Padding(
          padding: EdgeInsets.only(bottom: screenSize.getHeight(min: 40, max: 50)),
          child: InkWell(
            onTap: () {},
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenSize.getHeight(min: 6, max: 12)),
                border: Border.all(color: ThemeColors.dark70, width: 1),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: screenSize.getHeight(min: 14, max: 24)),
                  Assets.saunaUpdateInfo.toSvgPicture(
                    width: screenSize.getHeight(min: 24, max: 32),
                    height: screenSize.getHeight(min: 24, max: 32),
                    color: ThemeColors.dark20,
                  ),
                  SizedBox(width: screenSize.getHeight(min: 6, max: 8)),
                  Text(
                    'The firmware will be updated after the session',
                    style: TextStyle(
                      fontSize: screenSize.getFontSize(min: 12, max: 16),
                      fontWeight: FontWeight.w600,
                      color: ThemeColors.dark20,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(width: screenSize.getHeight(min: 14, max: 24)),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
