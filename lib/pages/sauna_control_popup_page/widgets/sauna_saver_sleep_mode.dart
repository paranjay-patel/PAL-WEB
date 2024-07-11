import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_rest_api/models/models.dart' as model;
import 'package:found_space_flutter_web_application/common/store/screen_saver.store.dart';
import 'package:found_space_flutter_web_application/common/ui/feedback_sound_wrapper.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/utils/sauna_saver_sleep_mode_utils.dart';
import 'package:provider/provider.dart';

class SaunaSavedSleepMode extends StatefulWidget {
  const SaunaSavedSleepMode({Key? key}) : super(key: key);

  @override
  State<SaunaSavedSleepMode> createState() => _SaunaSavedSleepModeState();
}

class _SaunaSavedSleepModeState extends State<SaunaSavedSleepMode> {
  late ScreenSaverStore _store;
  final _saunaSaverSleepModeTypes = model.SaunaSaverSleepModeType.values.toList();

  @override
  void initState() {
    super.initState();
    _saunaSaverSleepModeTypes.remove(model.SaunaSaverSleepModeType.unknown);
    _store = context.read<ScreenSaverStore>();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);

    return Observer(
      builder: (context) {
        final hasKeepScreenOn = _store.saunaSaverSleepModeType == model.SaunaSaverSleepModeType.keepScreenOn;
        return Expanded(
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTitle(context, 'In case of inactivity turn on:'),
                  SizedBox(height: screenSize.getHeight(min: 12, max: 20)),
                  Row(
                    children: _saunaSaverSleepModeTypes.map((type) => _buildSaverMode(context, type)).toList(),
                  ),
                  Opacity(
                    opacity: hasKeepScreenOn ? 0.0 : 1.0,
                    child: IgnorePointer(
                      ignoring: hasKeepScreenOn,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenSize.getHeight(min: 30, max: 44)),
                          _buildTitle(context, 'Turn on after:'),
                          SizedBox(height: screenSize.getHeight(min: 8, max: 16)),
                          _DurationList(store: _store),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context, String text) {
    final screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(
        color: theme.wifiHeaderTitleTextColor,
        fontWeight: FontWeight.w500,
        fontSize: screenSize.getFontSize(min: 16, max: 20),
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildSaverMode(BuildContext context, model.SaunaSaverSleepModeType type) {
    final theme = Theme.of(context).colorScheme;
    final screenSize = Utils.getScreenSize(context);
    return Expanded(
      child: Observer(
        builder: (context) {
          final isSelected = type == _store.saunaSaverSleepModeType;
          return FeedbackSoundWrapper(
            onTap: () {
              _store.setSaunaSaverSleepModeType(type);
            },
            child: Container(
              height: screenSize.getHeight(min: 180, max: 220),
              margin: EdgeInsets.only(right: type == model.SaunaSaverSleepModeType.keepScreenOn ? 0 : 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? ThemeColors.blue50 : theme.deactivateSwitchBackgroundColor,
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.asset(
                        type.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: screenSize.getHeight(min: 6, max: 12)),
                    Text(
                      type.title,
                      style: TextStyle(
                        color: theme.iconColor,
                        fontWeight: FontWeight.w600,
                        fontSize: screenSize.getFontSize(min: 10, max: 16),
                      ),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DurationList extends StatelessWidget {
  final ScreenSaverStore store;
  const _DurationList({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);
    final saunaSaverSleepDurations = model.SaunaSaverSleepDuration.values.toList();
    saunaSaverSleepDurations.remove(model.SaunaSaverSleepDuration.unknown);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: screenSize.getHeight(min: 60, max: 72),
          width: double.infinity,
          child: ListView.separated(
            shrinkWrap: true,
            clipBehavior: Clip.none,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: saunaSaverSleepDurations.length,
            itemBuilder: (context, index) {
              final type = saunaSaverSleepDurations[index];
              return _buildButton(context, type, constraints.maxWidth);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(width: 16);
            },
          ),
        );
      },
    );
  }

  Widget _buildButton(BuildContext context, model.SaunaSaverSleepDuration type, double width) {
    final screenSize = Utils.getScreenSize(context);
    final saunaSaverSleepDurations = model.SaunaSaverSleepDuration.values.toList();
    saunaSaverSleepDurations.remove(model.SaunaSaverSleepDuration.unknown);

    final paddingToMinus = 16 * (saunaSaverSleepDurations.length - 1);
    final theme = Theme.of(context).colorScheme;
    final buttonWidth = (width - paddingToMinus) / saunaSaverSleepDurations.length;

    return Observer(
      builder: (context) {
        final isSelected = type == store.saunaSaverSleepDuration;
        return FeedbackSoundWrapper(
          onTap: () {
            store.setSaunaSaverSleepDuration(type);
          },
          child: Container(
            height: screenSize.getHeight(min: 76, max: 72),
            width: buttonWidth,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: isSelected ? ThemeColors.blue50 : theme.tickMarkColor),
              color: theme.buttonColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                type.title,
                style: TextStyle(
                  fontSize: screenSize.getFontSize(min: 17, max: 20),
                  color: theme.iconColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
