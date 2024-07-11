import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/widgets/sauna_advance_settings/sauna_system_settings_section.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:found_space_flutter_rest_api/models/models.dart' as model;

class SaunaSoundsAndTemperatureSettingsTabPage extends StatefulWidget {
  const SaunaSoundsAndTemperatureSettingsTabPage({Key? key}) : super(key: key);

  @override
  State<SaunaSoundsAndTemperatureSettingsTabPage> createState() => _SaunaSoundsAndTemperatureSettingsTabPageState();
}

class _SaunaSoundsAndTemperatureSettingsTabPageState extends State<SaunaSoundsAndTemperatureSettingsTabPage> {
  final _saunaLocalStorageStore = locator<SaunaLocalStorageStore>();

  @override
  Widget build(BuildContext context) {
    final screenSize = Utils.getScreenSize(context);

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenSize.getHeight(min: 20, max: 26)),
            Observer(builder: (_) {
              final isOn = _saunaLocalStorageStore.isAllSoundOn;

              return SaunaSystemSettingsSection(
                type: SystemSettingsType.all,
                isOn: isOn,
                onChanged: (bool value) async {
                  await _saunaLocalStorageStore.setSoundOnEnableDisabled(
                    isAllSound: value,
                    isSystemSound: value,
                    isSessionsSound: value,
                  );
                },
              );
            }),
            SizedBox(height: screenSize.getHeight(min: 20, max: 26)),
            Observer(builder: (_) {
              final isOn = _saunaLocalStorageStore.isSystemSoundOn;
              final isAllSoundOn = _saunaLocalStorageStore.isAllSoundOn;

              return SaunaSystemSettingsSection(
                type: SystemSettingsType.system,
                isOn: isOn,
                isDisabled: !isAllSoundOn,
                onChanged: (bool value) async {
                  final isSessionsSoundOn = _saunaLocalStorageStore.isSessionsSoundOn;
                  if (!value && !isSessionsSoundOn) {
                    await _saunaLocalStorageStore.setSoundOnEnableDisabled(
                      isSystemSound: value,
                      isAllSound: false,
                    );
                  } else {
                    await _saunaLocalStorageStore.setSoundOnEnableDisabled(isSystemSound: value);
                  }
                },
              );
            }),
            SizedBox(height: screenSize.getHeight(min: 20, max: 26)),
            Observer(builder: (_) {
              final isOn = _saunaLocalStorageStore.isSessionsSoundOn;
              final isAllSoundOn = _saunaLocalStorageStore.isAllSoundOn;

              return SaunaSystemSettingsSection(
                type: SystemSettingsType.sessions,
                isOn: isOn,
                isDisabled: !isAllSoundOn,
                onChanged: (bool value) async {
                  final isSystemSoundOn = _saunaLocalStorageStore.isSystemSoundOn;
                  if (!value && !isSystemSoundOn) {
                    await _saunaLocalStorageStore.setSoundOnEnableDisabled(
                      isSessionsSound: value,
                      isAllSound: false,
                    );
                  } else {
                    await _saunaLocalStorageStore.setSoundOnEnableDisabled(isSessionsSound: value);
                  }
                },
              );
            }),
            SizedBox(height: screenSize.getHeight(min: 20, max: 26)),
            _Divider(),
            SizedBox(height: screenSize.getHeight(min: 20, max: 26)),
            Observer(builder: (_) {
              final isOn = _saunaLocalStorageStore.temperatureScale == model.TemperatureScale.fahrenheit;

              return SaunaSystemSettingsSection(
                type: SystemSettingsType.useFahrenheit,
                isOn: isOn,
                onChanged: (bool value) async {
                  _saunaLocalStorageStore.setTemperatureScaleSettings(
                    temperatureScale: value ? model.TemperatureScale.fahrenheit : model.TemperatureScale.celsius,
                  );
                },
              );
            }),
            SizedBox(height: screenSize.getHeight(min: 20, max: 26)),
            _Divider(),
            SizedBox(height: screenSize.getHeight(min: 20, max: 26)),
            Observer(builder: (_) {
              final isOn = _saunaLocalStorageStore.defaultConvention == model.TimeConvention.twentyFour;

              return SaunaSystemSettingsSection(
                type: SystemSettingsType.use24HourClock,
                isOn: isOn,
                onChanged: (bool value) async {
                  _saunaLocalStorageStore.setTimeConventionsSettings(
                    timeConvention: value ? model.TimeConvention.twentyFour : model.TimeConvention.twelve,
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      height: 1,
      color: theme.dividerColor,
    );
  }
}
