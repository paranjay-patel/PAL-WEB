import 'package:found_space_flutter_web_application/pages/sauna_control_page/widgets/sauna_control_page_common.dart';

class WidgetKeys {
  static final String startHeatingButton = SaunaStateButtonType.heatSauna.name;
  static final String stopHeatingButton = SaunaStateButtonType.stopHeating.name;
  static final String startSessionButton = SaunaStateButtonType.startSession.name;
  static final String finishSessionButton = SaunaStateButtonType.finishSession.name;
  static final String pauseSessionButton = SaunaStateButtonType.pauseSession.name;
  static final String resumeSessionButton = SaunaStateButtonType.continueSession.name;
  static final String cancleSessionButton = SaunaStateButtonType.cancelSession.name;
  static final String temperatureTile = SaunaBottomButton.temperature.name;
  static final String timerTile = SaunaBottomButton.programTime.name;
  static final String targetSubTitleTemperatureText = 'subtitle_${SaunaBottomButton.temperature.name}';
  static final String targetSubTitleTimerText = 'subtitle_${SaunaBottomButton.programTime.name}';
  static final String simpleScreenTab = SaunaMode.simple.toString();
  static final String turnOffScreenTab = SaunaMode.turnOffScreen.toString();
  static final String dashboardScreenTab = SaunaMode.dashboard.toString();

  static const String temperaturePopupTitle = 'Temperature';
  static const String timerPopupTitle = 'Time';
  static const String temperatureValue = 'display_temperature_value';
  static const String timerValue = 'display_timer_value';
  static const String startSessionEarlyButton = 'start_session_early_button';
  static const String minusButton = 'minus_button';
  static const String plusButton = 'plus_button';
  static const String closeButtonPopup = 'close_button';
  static const String heatingLabel = 'Sauna is heating';
  static const String standByLabel = 'Sauna is in standby';
  static const String newsd = 'Sauna is in standby';
  static const String inSessionLabel = 'Sauna is in session';
  static const String pausedLabel = 'Sauna is paused';
  static const String buttonResetProgram = 'button_reset_key';
  static const String buttonSaveProgram = 'button_save_key';
  static const String programModifiedText = 'program_modified';
  static const String temperatureGaugeIndicator = 'tempreature_radial_gauge_expanded_key';
  static const String timerGaugeIndicator = 'timer_radial_gauge_expanded_key';
  static const String minusTemperatureButton = 'temperature_minus_button';
  static const String plusTemperatureButton = 'temperature_plus_button';
  static const String minusTimeButton = 'time_minus_button';
  static const String plusTimeButton = 'time_plus_button';
  static const String temperatureValueSleep = 'target_temperature_text';
  static const String timeValueSleep = 'target_session_text';
}
