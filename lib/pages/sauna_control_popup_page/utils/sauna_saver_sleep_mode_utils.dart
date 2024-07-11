import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:found_space_flutter_web_application/assets.dart';

extension SaunaSaverSleepModeTypeExtension on SaunaSaverSleepModeType {
  String get title {
    switch (this) {
      case SaunaSaverSleepModeType.saverMode:
        return 'Focus Mode';
      case SaunaSaverSleepModeType.sleepMode:
        return 'Sleep Mode';
      case SaunaSaverSleepModeType.keepScreenOn:
        return 'Keep Screen On';
      case SaunaSaverSleepModeType.unknown:
        return '';
    }
  }

  String get image {
    switch (this) {
      case SaunaSaverSleepModeType.saverMode:
        return Images.saverMode.assetName;
      case SaunaSaverSleepModeType.sleepMode:
        return Images.sleepMode.assetName;
      case SaunaSaverSleepModeType.keepScreenOn:
        return Images.keepScreenOn.assetName;
      case SaunaSaverSleepModeType.unknown:
        return '';
    }
  }
}

extension SaunaSaverSleepDurationExtension on SaunaSaverSleepDuration {
  String get title {
    switch (this) {
      case SaunaSaverSleepDuration.oneMin:
        return '1 min';
      case SaunaSaverSleepDuration.threeMin:
        return '3 min';
      case SaunaSaverSleepDuration.fiveMin:
        return '5 min';
      case SaunaSaverSleepDuration.fifteenMin:
        return '15 min';
      case SaunaSaverSleepDuration.thirtyMin:
        return '30 min';
      case SaunaSaverSleepDuration.unknown:
        return '';
    }
  }

  int get timeDuration {
    switch (this) {
      case SaunaSaverSleepDuration.oneMin:
        return 1;
      case SaunaSaverSleepDuration.threeMin:
        return 3;
      case SaunaSaverSleepDuration.fiveMin:
        return 5;
      case SaunaSaverSleepDuration.fifteenMin:
        return 15;
      case SaunaSaverSleepDuration.thirtyMin:
        return 30;
      case SaunaSaverSleepDuration.unknown:
        return 0;
    }
  }
}
