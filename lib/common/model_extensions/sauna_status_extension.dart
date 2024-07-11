import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:collection/collection.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/utils/sauna_audio_control_utils.dart';

extension SaunaStatusExtension on SaunaStatus {
  int get targetProgramTime {
    final activeProgram = program?.active;
    final targetTimer = activeProgram?.targetTimer;
    if (targetTimer == null) return 0;

    int mins = Duration(seconds: targetTimer).inMinutes;
    return mins;
  }

  int get remainingTime {
    final remainingTimer = this.remainingTimer;
    if (remainingTimer == null) return 0;
    return (remainingTimer / 60).toDouble().ceil();
  }

  double get temperature {
    final activeProgram = program?.active;
    if (activeProgram == null) return 0;
    final targetTemperature = activeProgram.targetTemperature;
    if (targetTemperature == null) return 0;
    return targetTemperature;
  }

  int get currentAverageTemperature {
    final temperatures = currentTemperature ?? [];
    if (temperatures.isEmpty) return 0;
    final result = temperatures.reduce((value, element) => value + element);
    final temperaturesTemperature = (result / temperatures.length).toInt();
    if (temperaturesTemperature is int) return temperaturesTemperature;
    return 0;
  }

  List<Light> get activeLights {
    return program?.active?.lights ?? [];
  }

  List<Light> get setLights {
    return program?.set?.lights ?? [];
  }

  Light? get currentActiveRGBLight {
    return activeLights.firstWhereOrNull((element) => element.type == LightType.rgb);
  }

  Light? get currentSetRGBLight {
    return setLights.firstWhereOrNull((element) => element.type == LightType.rgb);
  }

  Light? get currentActiveMonoLight {
    return activeLights.firstWhereOrNull((element) => element.type == LightType.mono);
  }

  List<SaunaSoundsType>? get setAmbientSounds {
    final ambience = program?.set?.ambience ?? [];
    if (ambience.isEmpty) return [];
    return ambience.map((sound) => enumFromString(sound)).toList();
  }

  SaunaStatus copyWith({
    String? saunaIdentifier,
    SaunaState? state,
    String? firmwareVersion,
    String? modelName,
    double? targetTemperature,
    List<dynamic>? currentTemperature,
    int? targetTimer,
    int? remainingTimer,
    List<Light>? lights,
    List<Heater>? heaters,
    Program? program,
    String? modelId,
  }) {
    return SaunaStatus(
      saunaIdentifier: saunaIdentifier ?? this.saunaIdentifier,
      state: state ?? this.state,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      modelName: modelName ?? this.modelName,
      targetTemperature: targetTemperature ?? this.targetTemperature,
      currentTemperature: currentTemperature ?? this.currentTemperature,
      targetTimer: targetTimer ?? this.targetTimer,
      remainingTimer: remainingTimer ?? this.remainingTimer,
      lights: lights ?? this.lights,
      heaters: heaters ?? this.heaters,
      program: program ?? this.program,
      modelId: modelId ?? this.modelId,
    );
  }
}
