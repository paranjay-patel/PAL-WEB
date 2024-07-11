import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:intl/intl.dart';

extension SaunaPropertiesExtension on SaunaProperties {
  List<TemperatureScale>? get supportedTemperatureScales {
    return measurements?.temperature?.supportedScales;
  }

  List<TimeConvention>? get supportedConventions {
    return measurements?.time?.supportedConventions;
  }

  TemperatureScale? get defaultTemperatureScale {
    return measurements?.temperature?.defaultScale;
  }

  TimeConvention? get defaultTimeConvention {
    return measurements?.time?.defaultConvention;
  }
}

extension TimeConventionExtension on TimeConvention {
  String get displayValue {
    switch (this) {
      case TimeConvention.twelve:
        return '12-Hour Clock';
      case TimeConvention.twentyFour:
        return '24-Hour Clock';
      default:
        return '';
    }
  }

  DateFormat get dateFormat {
    switch (this) {
      case TimeConvention.twelve:
        return DateFormat('EE d MMM, hh:mm aa');
      case TimeConvention.twentyFour:
        return DateFormat('EE d MMM, HH:mm');
      default:
        return DateFormat('EE d MMM, hh:mm aa');
    }
  }
}

extension TemperatureScaleExtension on TemperatureScale {
  String get displayValue {
    switch (this) {
      case TemperatureScale.celsius:
        return 'Celsius';
      case TemperatureScale.fahrenheit:
        return 'Fahrenheit';
      default:
        return '';
    }
  }
}
