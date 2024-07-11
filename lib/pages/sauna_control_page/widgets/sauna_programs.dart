import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_rest_api/models/models.dart' as model;
import 'package:found_space_flutter_web_application/common/alert_dialog.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/common/themed_activity_indicator.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_colors.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/store/sauna_program_page.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_menu_button.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';

class SaunaPrograms extends StatefulWidget {
  @override
  _SaunaProgramsState createState() => _SaunaProgramsState();
}

class _SaunaProgramsState extends State<SaunaPrograms> with SingleTickerProviderStateMixin {
  late ScreenSize _screenSize;
  final _saunaProgramPageStore = locator<SaunaProgramPageStore>();
  final _saunaStore = locator<SaunaStore>();
  final _saunaLocalStorageStore = locator<SaunaLocalStorageStore>();

  @override
  Widget build(BuildContext context) {
    _screenSize = Utils.getScreenSize(context);
    final theme = Theme.of(context).colorScheme;
    return Observer(
      builder: (_) {
        final selectedSaunaProgram = _saunaStore.selectedProgram;
        return Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: _screenSize.getWidth(min: 20, max: 24)),
                child: Text(
                  'Sauna Programs:',
                  style: TextStyle(
                    color: theme.titleTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: _screenSize.getFontSize(min: 20, max: 28),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: _screenSize.getHeight(min: 18, max: 24)),
              Expanded(
                child: _saunaProgramPageStore.suggestedProgramResult.maybeWhen(
                  (items) {
                    return NotificationListener<ScrollNotification>(
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse,
                          },
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: items.length,
                          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 20);
                          },
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (_saunaStore.selectedProgram?.name == items[index].name) return;

                                _saunaStore.setPopupType(type: PopupType.none);
                                final shouldAllowProgramToUpdate = _saunaProgramPageStore.shouldAllowProgramToUpdate;
                                if (shouldAllowProgramToUpdate) {
                                  _saunaProgramPageStore.updateSelectedProgram(items[index]);
                                  _saunaStore.setSelectedMenuType(SaunaMenuType.saunaControl);
                                } else {
                                  AlertDialogs.show(context, "Sauna Program update!!",
                                      "A different program is already running. To change the program, finish or stop the current program",
                                      onTap: () {
                                    Navigator.pop(context);
                                  });
                                }
                              },
                              child: _buildProgram(items[index], selectedSaunaProgram),
                            );
                          },
                        ),
                      ),
                      onNotification: (ScrollNotification scrollInfo) {
                        _saunaStore.setPopupType(type: PopupType.none);
                        return false;
                      },
                    );
                  },
                  loading: () => Center(
                    child: SizedBox(
                      height: _screenSize.getHeight(min: 460, max: 598),
                      child: const ThemedActivityIndicator(),
                    ),
                  ),
                  orElse: () {
                    return SizedBox(
                      height: _screenSize.getHeight(min: 460, max: 598),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgram(model.Program suggestedProgram, model.Program? selectedSuggestedProgram) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_screenSize.getHeight(min: 14, max: 20)),
        color: theme.buttonBackgroundColor,
        boxShadow: theme.saunaControlPageButtonShadow,
        border: selectedSuggestedProgram?.name == suggestedProgram.name
            ? Border.all(width: 2, color: ThemeColors.blue50)
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _screenSize.getHeight(min: 14, max: 24),
          vertical: _screenSize.getHeight(min: 24, max: 34),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleText(suggestedProgram: suggestedProgram),
                  SizedBox(height: _screenSize.getHeight(min: 10, max: 16)),
                  _buildDescriptionText(
                    suggestedProgram: suggestedProgram,
                    selectedSuggestedProgram: selectedSuggestedProgram,
                  ),
                ],
              ),
            ),
            SizedBox(width: _screenSize.getHeight(min: 40, max: 50)),
            _buildDurationText(suggestedProgram: suggestedProgram),
            SizedBox(width: _screenSize.getHeight(min: 40, max: 50)),
            _buildTemperatureText(suggestedProgram: suggestedProgram),
            SizedBox(width: _screenSize.getHeight(min: 40, max: 50)),
            _buildColorTile(suggestedProgram: suggestedProgram),
            SizedBox(width: _screenSize.getHeight(min: 20, max: 36)),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleText({required model.Program suggestedProgram}) {
    return Text(
      suggestedProgram.name ?? '',
      style: TextStyle(
        color: ThemeColors.blue50,
        fontWeight: FontWeight.w600,
        fontSize: _screenSize.getFontSize(min: 18, max: 24),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,
    );
  }

  Widget _buildDurationText({required model.Program suggestedProgram}) {
    final theme = Theme.of(context).colorScheme;
    final targetTimer = (suggestedProgram.targetTimer?.toInt() ?? 0) ~/ 60;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Duration',
          style: TextStyle(
            color: theme.unselectedAudioIcon,
            fontWeight: FontWeight.w600,
            fontSize: _screenSize.getFontSize(min: 12, max: 16),
          ),
        ),
        SizedBox(height: _screenSize.getHeight(min: 10, max: 16)),
        Text(
          '${targetTimer}mins',
          style: TextStyle(
            color: theme.titleTextColor,
            fontWeight: FontWeight.bold,
            fontSize: _screenSize.getFontSize(min: 30, max: 40),
          ),
        ),
      ],
    );
  }

  Widget _buildTemperatureText({required model.Program suggestedProgram}) {
    final theme = Theme.of(context).colorScheme;
    final isFahrenheitScale = _saunaLocalStorageStore.temperatureScale == model.TemperatureScale.fahrenheit;
    var temperatureText = '${suggestedProgram.targetTemperature ?? 0}°C';
    if (isFahrenheitScale) {
      final fahrenheitValue = Utils.convertToFahrenheit(suggestedProgram.targetTemperature?.toInt() ?? 0);
      temperatureText = '$fahrenheitValue°F';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Temperature',
          style: TextStyle(
            color: theme.unselectedAudioIcon,
            fontWeight: FontWeight.w600,
            fontSize: _screenSize.getFontSize(min: 12, max: 16),
          ),
        ),
        SizedBox(height: _screenSize.getHeight(min: 10, max: 16)),
        Text(
          temperatureText,
          style: TextStyle(
            color: theme.titleTextColor,
            fontWeight: FontWeight.bold,
            fontSize: _screenSize.getFontSize(min: 30, max: 40),
          ),
        ),
      ],
    );
  }

  Widget _buildColorTile({required model.Program suggestedProgram}) {
    final theme = Theme.of(context).colorScheme;

    final lights = suggestedProgram.lights ?? [];
    final rgbLights = lights.where((light) => light.type == model.LightType.rgb).toList();

    Color lightColor = Colors.transparent;
    var title = 'All Lights: Off';

    if (rgbLights.isNotEmpty) {
      final rgbLight = rgbLights.first;
      title = 'All Lights: ${(rgbLight.state ?? false) ? 'On' : 'Off'}';
      lightColor = Color.fromRGBO(
        rgbLight.color?.r ?? 0,
        rgbLight.color?.g ?? 0,
        rgbLight.color?.b ?? 0,
        rgbLight.brightness ?? 0,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            color: theme.unselectedAudioIcon,
            fontWeight: FontWeight.w600,
            fontSize: _screenSize.getFontSize(min: 12, max: 16),
          ),
        ),
        SizedBox(height: _screenSize.getHeight(min: 10, max: 16)),
        if (rgbLights.isNotEmpty && rgbLights.first.state == false)
          _buildNoColor()
        else
          Container(
            width: 102,
            height: 48,
            decoration: BoxDecoration(
              color: lightColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 1, color: ThemeColors.grey40),
            ),
          ),
      ],
    );
  }

  Widget _buildNoColor() {
    final theme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 102,
        height: 48,
        decoration: BoxDecoration(
          color: theme.noColorBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 2, color: theme.noColorBorderColor),
        ),
        child: CustomPaint(
          painter: CrossLinePainter(color: theme.noColorBorderColor),
        ),
      ),
    );
  }

  Widget _buildDescriptionText({
    required model.Program suggestedProgram,
    model.Program? selectedSuggestedProgram,
  }) {
    final theme = Theme.of(context).colorScheme;
    return Text(
      suggestedProgram.descriptions?.join(', ') ?? '',
      style: TextStyle(
        color: selectedSuggestedProgram?.id == suggestedProgram.id ? theme.titleTextColor : theme.subTitleTextColor,
        fontWeight: FontWeight.normal,
        fontSize: _screenSize.getFontSize(min: 14, max: 20),
        height: 1.8,
      ),
      textAlign: TextAlign.left,
    );
  }
}

class CrossLinePainter extends CustomPainter {
  final Color color;
  CrossLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0;

    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, 0),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
