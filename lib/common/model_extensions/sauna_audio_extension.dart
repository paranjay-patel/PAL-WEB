import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/utils/sauna_audio_control_utils.dart';

extension SaunaPropertiesExtension on SaunaProperties {
  List<Ambience> get ambientSounds {
    final ambience = audio?.ambience ?? {};
    List<Ambience> result = [];

    for (final key in ambience.keys) {
      final value = ambience[key];

      if (value != null) {
        final saunaSoundsType = enumFromString(key);
        result.add(
          Ambience(
            type: saunaSoundsType,
            path: value,
            index: saunaSoundsType.index,
          ),
        );
      }
    }
    return result;
  }

  List<SystemSound> get systemSounds {
    final system = audio?.system ?? {};
    List<SystemSound> result = [];
    var index = 0; // Initialize the index

    for (final key in system.keys) {
      final value = system[key];

      if (value != null) {
        final type = enumFromSystemSoundText(key);
        result.add(SystemSound(type: type, path: value, index: index));
        index++;
      }
    }
    return result;
  }
}

class Ambience {
  final SaunaSoundsType type;
  final String path;
  final int index;

  Ambience({
    required this.type,
    required this.path,
    required this.index,
  });
}

class SystemSound {
  final SaunaSystemSoundType type;
  final String path;
  final int index;

  SystemSound({
    required this.type,
    required this.path,
    required this.index,
  });
}
