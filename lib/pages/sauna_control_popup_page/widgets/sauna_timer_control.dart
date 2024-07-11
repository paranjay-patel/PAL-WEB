import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:found_space_flutter_web_application/common/ui/found_space_theme_colors.dart';
import 'package:found_space_flutter_web_application/common/ui/theme_font.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_page/store/sauna_control_popup_page.store.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SaunaTimerControl extends StatelessWidget {
  final SaunaControlPopupPageStore store;
  const SaunaTimerControl({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final screenSize = Utils.getScreenSize(context);

    return Observer(
      builder: (_) {
        final targetDuration = store.targetDuration ?? 20;
        final annotationValue = targetDuration.toInt();
        return Expanded(
          key: const Key('timer_radial_gauge_expanded_key'),
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
                  minimum: 0,
                  maximum: 60,
                  interval: 30,
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
                      value: targetDuration,
                      onValueChanged: handlePointerValueChanged,
                      onValueChangeEnd: onValueChangeEnd,
                      onValueChanging: handlePointerValueChanging,
                      enableDragging: true,
                      width: 0.12,
                      sizeUnit: GaugeSizeUnit.factor,
                      cornerStyle: CornerStyle.startCurve,
                      color: const Color(0xFF316DBD),
                    ),
                    MarkerPointer(
                      value: targetDuration,
                      color: const Color(0xFF316DBD),
                      markerHeight: screenSize.getHeight(min: 45, max: 52),
                      markerWidth: screenSize.getWidth(min: 45, max: 52),
                      markerType: MarkerType.circle,
                      elevation: 10,
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      widget: RichText(
                          key: const Key('display_timer_value'),
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: '$annotationValue',
                                style: TextStyle(
                                  color: theme.titleTextColor,
                                  fontSize: screenSize.getFontSize(min: 50, max: 60),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: ThemeFont.defaultFontFamily,
                                ),
                              ),
                              TextSpan(
                                text: targetDuration > 1.0 ? 'mins' : 'min',
                                style: TextStyle(
                                  color: theme.titleTextColor,
                                  fontSize: screenSize.getFontSize(min: 20, max: 28),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: ThemeFont.defaultFontFamily,
                                ),
                              ),
                            ],
                          )),
                      positionFactor: 0.10,
                      angle: 0,
                    )
                  ],
                ),
                RadialAxis(
                  minimum: 0,
                  maximum: 60,
                  interval: 30,
                  showFirstLabel: true,
                  showLastLabel: true,
                  radiusFactor: .75,
                  labelOffset: 8,
                  minorTicksPerInterval: 30,
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
    if (value.toInt() >= 1) {
      final newValue = value.roundToDouble();
      store.setCurrentTime(newValue);
      store.updateTargetTime();
    }
  }

  /// annotation current value.
  void handlePointerValueChanged(double value) {
    if (value.toInt() >= 1) {
      final newValue = value.roundToDouble();
      store.setCurrentTime(newValue);
    }
  }

  void handlePointerValueChanging(ValueChangingArgs args) {
    if (args.value.toInt() < 1) {
      args.cancel = true;
    }
  }

  void onValueChangeEnd(double value) {
    if (value.toInt() >= 1) {
      store.updateTargetTime();
    }
  }
}
