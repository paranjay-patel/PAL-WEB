import 'package:found_space_flutter_rest_api/found_space_flutter_rest_api.dart';
import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/src/models/result.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'dart:async';

import 'package:found_space_flutter_web_application/common/mobx_provider.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';

part 'sauna_program_page.store.g.dart';

class SaunaProgramPageStore = _SaunaProgramPageStoreBase with _$SaunaProgramPageStore;

abstract class _SaunaProgramPageStoreBase with Store, Disposable {
  final _restAPIRepository = locator<RestAPIRepository>();
  final _saunaStore = locator<SaunaStore>();
  final _saunaLocalStorageStore = locator<SaunaLocalStorageStore>();
  final _logger = locator<Logger>();

  @readonly
  Result<List<Program>> _suggestedProgramResult = const Result.none();

  bool get shouldAllowProgramToUpdate =>
      _saunaStore.saunaState == SaunaState.standby || _saunaStore.saunaState == SaunaState.done;

  final suggestedProgram = ObservableList<Program>();

  @action
  Future<void> fetchSuggestedPrograms() async {
    suggestedProgram.clear();
    if (_suggestedProgramResult.isLoading) return;
    _suggestedProgramResult = const Result.loading();

    final credentials = _saunaStore.fetchCredentials;
    if (credentials == null) return;

    try {
      final result = await _restAPIRepository.fetchSystemProperties(
        saunaId: credentials.item2,
      );
      suggestedProgram.addAll(result?.programs ?? []);
      final defaultProgram = _getDefaultProgram();
      suggestedProgram.insert(0, defaultProgram);
      final selectedProgram = _saunaStore.selectedProgram;

      // Add custom program if it exists
      final customProgram = await _saunaLocalStorageStore.fetchCustomProgram();
      if (customProgram != null) {
        suggestedProgram.insert(0, customProgram);
      }

      if (selectedProgram != null) {
        final hasCustomProgram = suggestedProgram.any((element) => element.name == selectedProgram.name);
        if (!hasCustomProgram) {
          suggestedProgram.insert(0, selectedProgram);
        }
      }
      _suggestedProgramResult = Result(suggestedProgram);
    } catch (error, stackTrace) {
      locator<Logger>().e('Error loading fetchSuggestedPrograms', error, stackTrace);
      _suggestedProgramResult = Result.error(error: error, message: error.toString());
    }
  }

  @action
  Future<void> updateSelectedProgram(Program program) async {
    if (_saunaStore.selectedProgram?.name == program.name) return;

    try {
      _saunaStore.setSelectedProgram(program);
    } catch (error, stackTrace) {
      _logger.e('Error loading updateSelectedProgram', error, stackTrace);
    }
  }

  Program _getDefaultProgram() {
    return const Program(
      id: 'default',
      name: "Default",
      targetTemperature: 45,
      timerDuration: 45,
      targetTimer: 1200,
      descriptions: ["A default program to start with"],
      heaters: [
        Heater(name: "A", state: false, level: 0),
        Heater(name: "B", state: false, level: 0),
        Heater(name: "C", state: false, level: 0),
      ],
      lights: [
        Light(
          id: "RGB_1",
          name: "RGB_1",
          type: LightType.rgb,
          state: false,
          color: ColorRGB(r: 255, g: 255, b: 255),
          brightness: 1,
        ),
        Light(
          id: "RGB_2",
          name: "RGB_2",
          type: LightType.rgb,
          state: false,
          color: ColorRGB(r: 255, g: 255, b: 255),
          brightness: 1,
        ),
      ],
    );
  }
}
