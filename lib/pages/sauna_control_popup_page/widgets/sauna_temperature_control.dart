import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_font.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/store/sauna_control_popup_page.store.dart';

import 'package:syncfusion_flutter_gauges/gauges.dart';

class SaunaTemperatureControl extends StatelessWidget {
  final SaunaControlPopupPageStore store;
  const SaunaTemperatureControl({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final screenSize = Utils.getScreenSize(context);

    return Observer(
      builder: (_) {
        final maxTemperature = store.maxTemperature.toDouble();
        final minTemperature = store.minTemperature.toDouble();
        final intervalAt = store.temperatureInterval.toDouble();
        final targetTemperature = store.targetTemperature ?? 20;
        final rangePointerTemperature = store.rangePointerTemperature.toDouble();
        final displayableTemperatureValue = store.displayableTemperatureValue(targetTemperature.toInt());

        return Expanded(
          key: const Key('tempreature_radial_gauge_expanded_key'),
          child: Padding(
            padding: EdgeInsets.only(bottom: screenSize.getHeight(min: 8, max: 12)),
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  axisLineStyle: AxisLineStyle(
                    thickness: 0.12,
                    thicknessUnit: GaugeSizeUnit.factor,
                    cornerStyle: CornerStyle.bothCurve,
                    color: theme.axisLineColor,
                  ),
                  minimum: minTemperature,
                  maximum: maxTemperature,
                  interval: intervalAt,
                  showTicks: false,
                  showLabels: false,
                  axisLabelStyle: GaugeTextStyle(
                    color: theme.subTitleTextColor,
                    fontSize: screenSize.getFontSize(min: 16, max: 20),
                    fontWeight: FontWeight.normal,
                    fontFamily: ThemeFont.defaultFontFamily,
                  ),
                  onAxisTapped: onAxisTapped,
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: rangePointerTemperature,
                      onValueChanged: handlePointerValueChanged,
                      onValueChangeEnd: onValueChangeEnd,
                      onValueChanging: handlePointerValueChanging,
                      enableDragging: true,
                      width: 0.12,
                      sizeUnit: GaugeSizeUnit.factor,
                      cornerStyle: CornerStyle.startCurve,
                      color: const Color(0xFFE0992E),
                    ),
                    MarkerPointer(
                      value: rangePointerTemperature,
                      color: const Color(0xFFE0992E),
                      markerHeight: screenSize.getHeight(min: 45, max: 52),
                      markerWidth: screenSize.getWidth(min: 45, max: 52),
                      markerType: MarkerType.circle,
                      elevation: 10,
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            displayableTemperatureValue,
                            key: const Key('display_temperature_value'),
                            style: TextStyle(
                              color: theme.titleTextColor,
                              fontSize: screenSize.getFontSize(min: 50, max: 60),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                      positionFactor: 0.10,
                      angle: 0,
                    )
                  ],
                ),
                RadialAxis(
                  minimum: minTemperature,
                  maximum: maxTemperature,
                  interval: intervalAt,
                  showFirstLabel: true,
                  showLastLabel: true,
                  radiusFactor: .75,
                  labelOffset: 8,
                  minorTicksPerInterval: 25,
                  canRotateLabels: false,
                  showAxisLine: false,
                  minorTickStyle: MinorTickStyle(
                    color: theme.tickColor,
                    thickness: .75,
                    lengthUnit: GaugeSizeUnit.factor,
                    length: 0.06,
                  ),
                  majorTickStyle: MajorTickStyle(
                    color: theme.tickColor,
                    thickness: 1.0,
                    lengthUnit: GaugeSizeUnit.factor,
                    length: 0.12,
                  ),
                  axisLabelStyle: GaugeTextStyle(
                    color: theme.subTitleTextColor,
                    fontSize: screenSize.getFontSize(min: 16, max: 20),
                    fontWeight: FontWeight.normal,
                    fontFamily: ThemeFont.defaultFontFamily,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onAxisTapped(double value) {
    if (value.toInt() > 6) {
      final newValue = value.roundToDouble();
      store.setCurrentTemperature(newValue);
      store.updateTargetTemperature();
    }
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handlePointerValueChanged(double value) {
    if (value.toInt() > 6) {
      final newValue = value.roundToDouble();
      store.setCurrentTemperature(newValue);
    }
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handlePointerValueChanging(ValueChangingArgs args) {
    if (args.value.toInt() <= 6) {
      args.cancel = true;
    }
  }

  void onValueChangeEnd(double value) {
    if (value.toInt() > 6) {
      store.updateTargetTemperature();
    }
  }
}
