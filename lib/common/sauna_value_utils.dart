import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';

class SaunaValueUtils {
  static final SaunaValueUtils instance = SaunaValueUtils();

  static String getTargetTemperature(int targetTemperature, {required TemperatureScale temperatureScale}) {
    if (targetTemperature == 0) return "Target Temp: -";
    if (temperatureScale == TemperatureScale.fahrenheit) {
      final targetTemperatureInFahrenheit = Utils.convertToFahrenheit(targetTemperature);
      return 'Target Temp: ${targetTemperatureInFahrenheit}°F';
    }
    return 'Target Temp: $targetTemperature°C';
  }

  static String getTargetTimer(int targetTimer) {
    if (targetTimer == 0) return 'Session Length: -';
    return 'Session Length: ${targetTimer}m';
  }

  static String getAverageTemperature(
    int averageTemperature, {
    required TemperatureScale temperatureScale,
    bool addLeadingZero = false,
  }) {
    var temperature = averageTemperature;
    if (temperature == 0) return '-';

    final temperatureSymbol = _getTemperatureSymbol(temperatureScale);
    if (temperatureScale == TemperatureScale.fahrenheit) {
      temperature = Utils.convertToFahrenheit(temperature);
    }

    return (addLeadingZero && averageTemperature < 10)
        ? '0$temperature$temperatureSymbol'
        : '$temperature$temperatureSymbol';
  }

  static String _getTemperatureSymbol(TemperatureScale temperatureScale) {
    return temperatureScale == TemperatureScale.fahrenheit ? '°F' : '°C';
  }

  static String getRemainingTime(int remainingTime) {
    if (remainingTime == 0) {
      return "-";
    } else if (remainingTime > 1) {
      return '${remainingTime}mins';
    } else {
      return '${remainingTime}min';
    }
  }
}
