import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/sauna_audio_extension.dart';
import 'package:found_space_flutter_web_application/common/store/audio_player.store.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/utils/sauna_audio_control_utils.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';

class SaunaSoundsTabPage extends StatefulWidget {
  const SaunaSoundsTabPage({Key? key}) : super(key: key);

  @override
  State<SaunaSoundsTabPage> createState() => _SaunaSoundsTabPageState();
}

class _SaunaSoundsTabPageState extends State<SaunaSoundsTabPage> {
  final _audioPlayerStore = locator<AudioPlayerStore>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final screenSize = Utils.getScreenSize(context);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: screenSize.getHeight(min: 0, max: 8)),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Align(
                    alignment: Alignment.center,
                    child: Observer(builder: (context) {
                      final ambientSounds = _audioPlayerStore.ambientSounds;
                      return AlignedGridView.count(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ambientSounds.length,
                        itemBuilder: (context, index) {
                          return _AudioItem(
                            ambience: ambientSounds[index],
                            screenSize: screenSize,
                            height: (constraints.maxHeight - 30) / 3,
                            store: _audioPlayerStore,
                          );
                        },
                      );
                    }),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: theme.isNightMode ? Colors.transparent : ThemeColors.grey30,
          ),
          const _AudioVolumeSliderControl(),
        ],
      ),
    );
  }
}

class _AudioItem extends StatelessWidget {
  final Ambience ambience;
  final ScreenSize screenSize;
  final double height;
  final AudioPlayerStore store;

  const _AudioItem({
    Key? key,
    required this.ambience,
    required this.screenSize,
    required this.height,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Observer(
      builder: (_) {
        final type = ambience.type;

        final isSelected = (store.selectedSaunaAmbiences.firstWhereOrNull((element) => element.type == type)) != null;
        final border = isSelected ? Border.all(color: ThemeColors.blue50, width: 2) : null;
        final backgroundColor = isSelected ? theme.selectedAudioBackgroundColor : theme.deselectedAudioBackgroundColor;
        final selectedColor = isSelected ? ThemeColors.blue50 : theme.unselectedAudioIcon;
        final iconSize = height * 0.71; // In Figma it's 80 and box height is 112 so 80/112 become 0.71
        final fontSize = height * 0.10; // same as iconSize logic

        return InkWell(
          onTap: () {
            store.setSaunaAmbienceSelection(ambience: ambience);
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            height: height,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: border,
              borderRadius: BorderRadius.circular(12),
              color: backgroundColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                type.icon(isSelected: isSelected).toSvgPicture(
                      fit: BoxFit.contain,
                      width: screenSize.getIconSize(min: 64, max: iconSize),
                      height: screenSize.getIconSize(min: 64, max: iconSize),
                      color: selectedColor,
                    ),
                Text(
                  type.title,
                  style: TextStyle(
                    fontSize: screenSize.getFontSize(min: 12, max: fontSize),
                    fontWeight: FontWeight.normal,
                    color: selectedColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AudioVolumeSliderControl extends StatefulWidget {
  const _AudioVolumeSliderControl({Key? key}) : super(key: key);

  @override
  State<_AudioVolumeSliderControl> createState() => _AudioVolumeSliderControlState();
}

class _AudioVolumeSliderControlState extends State<_AudioVolumeSliderControl> {
  late AudioPlayerStore _store;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final screenSize = Utils.getScreenSize(context);
    _store = context.watch<AudioPlayerStore>();

    return Observer(builder: (context) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.getAllPadding(min: 24, max: 32),
          vertical: screenSize.getAllPadding(min: 12, max: 16),
        ),
        child: SizedBox(
          height: screenSize.getHeight(min: 40, max: 56),
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'You can use a single sound or mix up to 3 to create a unique ambience',
                  style: TextStyle(
                    fontSize: screenSize.getFontSize(min: 13, max: 16),
                    fontWeight: FontWeight.normal,
                    color: theme.iconColor,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              InkWell(
                onTap: () {
                  if (_store.isAmbientSoundPlaying) {
                    _store.pauseAllPlayers();
                  } else {
                    _store.playAllPlayers();
                  }
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  height: screenSize.getHeight(min: 40, max: 56),
                  width: screenSize.getWidth(min: 40, max: 56),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenSize.getWidth(min: 12, max: 16)),
                    color: ThemeColors.blue50,
                  ),
                  alignment: Alignment.center,
                  child: (!_store.isAmbientSoundPlaying ? Assets.play : Assets.pause).toSvgPicture(
                    color: ThemeColors.neutral000,
                    width: screenSize.getWidth(min: 25, max: 32),
                    height: screenSize.getHeight(min: 25, max: 32),
                  ),
                ),
              ),
              SizedBox(width: screenSize.getWidth(min: 16, max: 20)),
            ],
          ),
        ),
      );
    });
  }
}
