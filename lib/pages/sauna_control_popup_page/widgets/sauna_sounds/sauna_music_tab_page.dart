import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_rest_api/models/models.dart' as model;
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_bluetooth_store.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/widgets/sauna_audio_action_button.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';

class SaunaMusicTabPage extends StatefulWidget {
  const SaunaMusicTabPage({Key? key}) : super(key: key);

  @override
  State<SaunaMusicTabPage> createState() => _SaunaMusicTabPageState();
}

class _SaunaMusicTabPageState extends State<SaunaMusicTabPage> with AutomaticKeepAliveClientMixin {
  late ColorScheme _theme;
  late ScreenSize _screenSize;

  final _saunaBluetoothStore = locator<SaunaBluetoothStore>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _theme = Theme.of(context).colorScheme;
    _screenSize = Utils.getScreenSize(context);

    return Observer(builder: (context) {
      final isBluetoothConnected = _saunaBluetoothStore.isBluetoothConnected;

      if (!isBluetoothConnected) return const _SaunaNoDeviceConnected();

      final isBluetoothMediaStopped = _saunaBluetoothStore.isBluetoothMediaStopped;
      final isBluetoothMediaAvailable = _saunaBluetoothStore.isBluetoothMediaAvailable;

      if (isBluetoothMediaStopped || !isBluetoothMediaAvailable) {
        return const _SaunaNoDeviceConnected(message: 'Music is currently not available');
      }

      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _SaunaAudioPanelInfo(store: _saunaBluetoothStore),
            ),
            Text(
              _saunaBluetoothStore.trackGenre,
              style: TextStyle(
                color: ThemeColors.blue60,
                fontSize: _screenSize.getFontSize(min: 12, max: 16),
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: _screenSize.getHeight(min: 14, max: 20)),
            Container(
              height: 1,
              width: double.infinity,
              color: _theme.isNightMode ? const Color(0xff9F9F9F).withOpacity(.2) : ThemeColors.grey30,
            ),
            const _SaunaAudioPanel(),
          ],
        ),
      );
    });
  }
}

class _SaunaAudioPanelInfo extends StatelessWidget {
  final SaunaBluetoothStore store;
  const _SaunaAudioPanelInfo({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final canGoToPreviousTrack = store.canGoToPreviousTrack;
    final canGoToNextTrack = store.canGoToNextTrack;

    return Observer(
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${store.trackNumber}/${store.numberOfTracks}',
              style: TextStyle(
                color: ThemeColors.blue60,
                fontSize: screenSize.getFontSize(min: 12, max: 16),
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenSize.getHeight(min: 30, max: 40)),
            Row(
              children: [
                SizedBox(width: screenSize.getWidth(min: 8, max: 16)),
                SaunaAudioActionButton(
                  type: ButtonType.musicPrevious,
                  isDisabled: !canGoToPreviousTrack,
                  onTap: () {
                    store.setBluetoothMediaStatus(
                      action: model.BluetoothMediaAction.previous,
                    );
                  },
                ),
                SizedBox(width: screenSize.getWidth(min: 30, max: 40)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        store.trackTitle,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.titleTextColor,
                          fontSize: screenSize.getFontSize(min: 24, max: 36),
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenSize.getHeight(min: 4, max: 8)),
                      Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: store.trackArtist,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.wifiSubTitleTextColor,
                                fontSize: screenSize.getFontSize(min: 12, max: 20),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const TextSpan(text: ' '),
                            TextSpan(
                              text: store.trackAlbum,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.titleTextColor,
                                fontSize: screenSize.getFontSize(min: 12, max: 20),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: screenSize.getWidth(min: 30, max: 40)),
                SaunaAudioActionButton(
                  type: ButtonType.musicNext,
                  isDisabled: !canGoToNextTrack,
                  onTap: () {
                    store.setBluetoothMediaStatus(
                      action: model.BluetoothMediaAction.next,
                    );
                  },
                ),
                SizedBox(width: screenSize.getWidth(min: 8, max: 16)),
              ],
            ),
            SizedBox(height: screenSize.getHeight(min: 40, max: 60)),
          ],
        );
      },
    );
  }
}

class _SaunaAudioPanel extends StatefulWidget {
  const _SaunaAudioPanel({Key? key}) : super(key: key);

  @override
  State<_SaunaAudioPanel> createState() => _SaunaAudioPanelState();
}

class _SaunaAudioPanelState extends State<_SaunaAudioPanel> {
  late ColorScheme _theme;
  late ScreenSize _screenSize;

  final _saunaBluetoothStore = locator<SaunaBluetoothStore>();

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context).colorScheme;
    _screenSize = Utils.getScreenSize(context);

    return Observer(
      builder: (context) {
        final isBluetoothConnected = _saunaBluetoothStore.isBluetoothConnected;

        final isBluetoothMediaStopped = _saunaBluetoothStore.isBluetoothMediaStopped;
        final isBluetoothMediaAvailable = _saunaBluetoothStore.isBluetoothMediaAvailable;

        if (!isBluetoothConnected || isBluetoothMediaStopped || !isBluetoothMediaAvailable) return const SizedBox();

        final position = _saunaBluetoothStore.position;
        final duration = _saunaBluetoothStore.duration;
        final currentPosition = _saunaBluetoothStore.currentPosition;
        final currentDuration = _saunaBluetoothStore.currentDuration;
        final isMusicPlaying = _saunaBluetoothStore.isMusicPlaying;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Padding(
            padding: EdgeInsets.only(
              right: _screenSize.getHeight(min: 24, max: 32),
              top: _screenSize.getHeight(min: 8, max: 16),
              bottom: _screenSize.getHeight(min: 8, max: 16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Row(
                          children: [
                            const SizedBox(width: 24),
                            Text(
                              currentPosition,
                              style: TextStyle(
                                color: _theme.tickColor,
                                fontWeight: FontWeight.w500,
                                fontSize: _screenSize.getFontSize(min: 10, max: 12),
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const Spacer(),
                            Text(
                              currentDuration,
                              style: TextStyle(
                                color: _theme.tickColor,
                                fontWeight: FontWeight.w500,
                                fontSize: _screenSize.getFontSize(min: 10, max: 12),
                              ),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(width: 24)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: RotatedBox(
                          quarterTurns: 0,
                          child: IgnorePointer(
                            ignoring: true,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: ThemeColors.blue50,
                                inactiveTrackColor: _theme.buttonBorderColor,
                                thumbColor: ThemeColors.blue50,
                                thumbSelector: (textDirection, values, tapValue, thumbSize, trackSize, dx) =>
                                    Thumb.start,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                                minThumbSeparation: 2,
                                trackHeight: 8,
                              ),
                              child: Slider(
                                onChanged: (value) {},
                                min: 0.0,
                                max: (duration >= 0) ? duration : 0,
                                value: position,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Observer(builder: (context) {
                  final isAudioBuffering = _saunaBluetoothStore.isAudioBuffering;
                  return SaunaAudioActionButton(
                    type: isMusicPlaying ? ButtonType.pause : ButtonType.play,
                    isLoading: isAudioBuffering,
                    onTap: () {
                      _saunaBluetoothStore.setBluetoothMediaStatus(
                        action: isMusicPlaying ? model.BluetoothMediaAction.pause : model.BluetoothMediaAction.play,
                      );
                    },
                  );
                }),
                SizedBox(width: _screenSize.getWidth(min: 10, max: 16)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SaunaNoDeviceConnected extends StatelessWidget {
  final String? message;
  const _SaunaNoDeviceConnected({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.noMusic.toSvgPicture(
            width: screenSize.getHeight(min: 64, max: 80),
            height: screenSize.getHeight(min: 64, max: 80),
            color: Theme.of(context).colorScheme.iconColor,
          ),
          SizedBox(height: screenSize.getHeight(min: 8, max: 12)),
          Text(
            message ?? 'Bluetooth device is not connected',
            style: TextStyle(
              color: Theme.of(context).colorScheme.titleTextColor,
              fontSize: screenSize.getFontSize(min: 18, max: 24),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenSize.getHeight(min: 34, max: 44)),
        ],
      ),
    );
  }
}
