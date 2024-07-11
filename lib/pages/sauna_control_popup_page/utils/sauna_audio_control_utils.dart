import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/svg_asset_image.dart';

enum SaunaSoundsType {
  chime,
  fire,
  ocean,
  rain,
  storm,
  stream,
  distanceBattle,
  whiteNoise,
  wind,
}

enum SaunaSystemSoundType {
  startup,
  sessionReady,
  sessionInsession,
  sessionDone,
  buttonFeedback,
}

extension SaunaSoundsTypeExtension on SaunaSoundsType {
  SvgAssetImage icon({bool isSelected = false}) {
    switch (this) {
      case SaunaSoundsType.chime:
        return isSelected ? Assets.selectedChime : Assets.chime;
      case SaunaSoundsType.fire:
        return isSelected ? Assets.selectedCampfire : Assets.campfire;
      case SaunaSoundsType.ocean:
        return isSelected ? Assets.selectedOcean : Assets.ocean;
      case SaunaSoundsType.rain:
        return isSelected ? Assets.selectedRain : Assets.fallingRain;
      case SaunaSoundsType.storm:
        return isSelected ? Assets.selectedStorm : Assets.storm;
      case SaunaSoundsType.stream:
        return isSelected ? Assets.selectedStream : Assets.stream;
      case SaunaSoundsType.distanceBattle:
        return isSelected ? Assets.selectedDistantBattle : Assets.distantBattle;
      case SaunaSoundsType.whiteNoise:
        return isSelected ? Assets.selectedNoise : Assets.whiteNoise;
      case SaunaSoundsType.wind:
        return isSelected ? Assets.selectedWinds : Assets.winds;
    }
  }

  String get title {
    switch (this) {
      case SaunaSoundsType.chime:
        return 'Chime';
      case SaunaSoundsType.fire:
        return 'Fire';
      case SaunaSoundsType.ocean:
        return 'Ocean';
      case SaunaSoundsType.rain:
        return 'Rain';
      case SaunaSoundsType.storm:
        return 'Storm';
      case SaunaSoundsType.stream:
        return 'Stream';
      case SaunaSoundsType.distanceBattle:
        return 'Distant Battle';
      case SaunaSoundsType.whiteNoise:
        return 'White noise';
      case SaunaSoundsType.wind:
        return 'Wind';
    }
  }

  String get jsonKey {
    switch (this) {
      case SaunaSoundsType.chime:
        return 'chime';
      case SaunaSoundsType.fire:
        return 'fire';
      case SaunaSoundsType.ocean:
        return 'ocean';
      case SaunaSoundsType.rain:
        return 'rain';
      case SaunaSoundsType.storm:
        return 'storm';
      case SaunaSoundsType.stream:
        return 'stream';
      case SaunaSoundsType.distanceBattle:
        return 'war';
      case SaunaSoundsType.whiteNoise:
        return 'white_noise';
      case SaunaSoundsType.wind:
        return 'wind';
    }
  }
}

SaunaSoundsType enumFromString(String name) {
  switch (name) {
    case 'chime':
      return SaunaSoundsType.chime;
    case 'fire':
      return SaunaSoundsType.fire;
    case 'ocean':
      return SaunaSoundsType.ocean;
    case 'rain':
      return SaunaSoundsType.rain;
    case 'storm':
      return SaunaSoundsType.storm;
    case 'stream':
      return SaunaSoundsType.stream;
    case 'war':
      return SaunaSoundsType.distanceBattle;
    case 'white_noise':
      return SaunaSoundsType.whiteNoise;
    case 'wind':
      return SaunaSoundsType.wind;
    default:
      return SaunaSoundsType.chime;
  }
}

extension SaunaSystemSoundTypeExtension on SaunaSystemSoundType {
  String get jsonKey {
    switch (this) {
      case SaunaSystemSoundType.startup:
        return 'startup';
      case SaunaSystemSoundType.sessionReady:
        return 'session_ready';
      case SaunaSystemSoundType.sessionInsession:
        return 'session_insession';
      case SaunaSystemSoundType.sessionDone:
        return 'session_done';
      case SaunaSystemSoundType.buttonFeedback:
        return 'button_feedback';
    }
  }
}

SaunaSystemSoundType enumFromSystemSoundText(String text) {
  switch (text) {
    case 'startup':
      return SaunaSystemSoundType.startup;
    case 'session_ready':
      return SaunaSystemSoundType.sessionReady;
    case 'session_insession':
      return SaunaSystemSoundType.sessionInsession;
    case 'session_done':
      return SaunaSystemSoundType.sessionDone;
    case 'button_feedback':
      return SaunaSystemSoundType.buttonFeedback;
    default:
      return SaunaSystemSoundType.startup;
  }
}
