import 'package:found_space_flutter_web_application/models/models.dart';

abstract class SaunaConfigRepository {
  Future<List<SaunaConfigType>?> fetchConfigs({required String saunaId, required String token});

  Future<SaunaConfig?> fetchConfig({
    required String saunaId,
    required String token,
    required SaunaConfigType configType,
  });

  Future<SaunaConfig?> setSaunaConfig({
    required String saunaId,
    required String token,
    required SaunaConfigType configType,
    required SaunaConfig saunaConfig,
  });

  Future<SaunaConfig?> putSaunaConfig({
    required String saunaId,
    required String token,
    required SaunaConfigType configType,
    required SaunaConfig saunaConfig,
  });

  Future<bool> deleteSaunaConfig({
    required String saunaId,
    required String token,
    required SaunaConfigType configType,
  });

  String get host;
}
