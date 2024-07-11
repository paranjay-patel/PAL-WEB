import 'dart:convert';

import 'package:found_space_flutter_rest_api/exceptions/src/network_exception.dart';
import 'package:found_space_flutter_rest_api/exceptions/src/sauna_exception.dart';
import 'package:found_space_flutter_rest_api/found_space_flutter_rest_api.dart';
import 'package:found_space_flutter_web_application/models/src/model_common.dart';
import 'package:found_space_flutter_web_application/models/src/sauna_config.dart';
import 'package:found_space_flutter_web_application/services/repository/sauna_config_repository.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:logger/logger.dart';

class SaunaConfigRepositoryImpl implements SaunaConfigRepository {
  final SaunaClient client;
  SaunaConfigRepositoryImpl(this.client);

  @override
  Future<List<SaunaConfigType>?> fetchConfigs({required String saunaId, required String token}) async {
    try {
      final requestUrl = "${host}/sauna/$saunaId/config";
      Logger().i('fetchConfigs', requestUrl);

      final response = await client.get(
        requestUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Device $token',
        },
      );

      Logger().i('fetchConfigs_status_code', response.statusCode.toString());
      if (!isSuccessful(response.statusCode)) {
        throw SaunaException.make(HttpException(response.statusCode, response.body));
      } else {
        Iterable results = json.decode(utf8.decode(response.bodyBytes));
        final types = results.map((result) => result as String).toList();
        return types.map((type) => fromConfigTypeString(type)).toList();
      }
    } on SaunaException catch (_) {
      rethrow;
    } catch (error, stackTrace) {
      Logger().e("fetchConfigs", error, stackTrace);
      throw SaunaException.make(NetworkException(
        NonHttpNetworkError.ConnectionError,
        "Network error while posting fetchConfigs network service",
      ));
    }
  }

  @override
  Future<SaunaConfig?> fetchConfig({
    required String saunaId,
    required String token,
    required SaunaConfigType configType,
  }) async {
    try {
      final requestUrl = "${host}/sauna/$saunaId/config/${configType.apiKey}";
      Logger().i('fetchConfig', requestUrl);

      final response = await client.get(
        requestUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Device $token',
        },
      );

      Logger().i('fetchConfig_status_code', response.statusCode.toString());
      if (!isSuccessful(response.statusCode)) {
        throw SaunaException.make(HttpException(response.statusCode, response.body));
      } else {
        final jsonResult = json.decode(utf8.decode(response.bodyBytes));
        return SaunaConfig.fromJson(jsonResult);
      }
    } on SaunaException catch (_) {
      rethrow;
    } catch (error, stackTrace) {
      Logger().e("fetchConfig", error, stackTrace);
      throw SaunaException.make(NetworkException(
        NonHttpNetworkError.ConnectionError,
        "Network error while posting fetchConfig network service",
      ));
    }
  }

  @override
  Future<SaunaConfig?> setSaunaConfig({
    required String saunaId,
    required String token,
    required SaunaConfigType configType,
    required SaunaConfig saunaConfig,
  }) async {
    try {
      final requestUrl = "${host}/sauna/$saunaId/config/${configType.apiKey}";
      Logger().i('setSaunaConfig', requestUrl);

      final response = await client.post(
        requestUrl,
        body: saunaConfig.toJson(),
        encodeJson: true,
        headers: <String, String>{
          'Authorization': 'Device $token',
        },
      );

      if (!isSuccessful(response.statusCode)) {
        throw SaunaException.make(HttpException(response.statusCode, response.body));
      } else {
        final jsonResult = json.decode(utf8.decode(response.bodyBytes));
        return SaunaConfig.fromJson(jsonResult);
      }
    } on SaunaException catch (_) {
      rethrow;
    } catch (error, stackTrace) {
      Logger().e("setSaunaConfig", error, stackTrace);
      throw SaunaException.make(NetworkException(
        NonHttpNetworkError.ConnectionError,
        "Network error while posting setSaunaConfig network service",
      ));
    }
  }

  @override
  Future<SaunaConfig?> putSaunaConfig({
    required String saunaId,
    required String token,
    required SaunaConfigType configType,
    required SaunaConfig saunaConfig,
  }) async {
    try {
      final requestUrl = "${host}/sauna/$saunaId/config/${configType.apiKey}";
      Logger().i('putSaunaConfig', requestUrl);

      final response = await client.put(
        requestUrl,
        body: saunaConfig.toJson(),
        encodeJson: true,
        headers: <String, String>{
          'Authorization': 'Device $token',
        },
      );

      if (!isSuccessful(response.statusCode)) {
        throw SaunaException.make(HttpException(response.statusCode, response.body));
      } else {
        final jsonResult = json.decode(utf8.decode(response.bodyBytes));
        return SaunaConfig.fromJson(jsonResult);
      }
    } on SaunaException catch (_) {
      rethrow;
    } catch (error, stackTrace) {
      Logger().e("putSaunaConfig", error, stackTrace);
      throw SaunaException.make(NetworkException(
        NonHttpNetworkError.ConnectionError,
        "Network error while posting putSaunaConfig network service",
      ));
    }
  }

  @override
  Future<bool> deleteSaunaConfig({
    required String saunaId,
    required String token,
    required SaunaConfigType configType,
  }) async {
    try {
      final requestUrl = "${host}/sauna/$saunaId/config/${configType.apiKey}";
      Logger().i('deleteSaunaConfig', requestUrl);

      final response = await client.delete(
        requestUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Device $token',
        },
      );

      Logger().i('deleteSaunaConfig_status_code', response.statusCode.toString());
      if (!isSuccessful(response.statusCode)) {
        throw SaunaException.make(HttpException(response.statusCode, response.body));
      } else {
        return Future.value(true);
      }
    } on SaunaException catch (_) {
      rethrow;
    } catch (error, stackTrace) {
      Logger().e('deleteSaunaConfig', error, stackTrace);
      throw SaunaException.make(NetworkException(
        NonHttpNetworkError.ConnectionError,
        'Network error while posting deleteSaunaConfig network service',
      ));
    }
  }

  bool isSuccessful(int responseCode) => responseCode ~/ 100 == 2;

  @override
  String get host => locator<AppConfigBase>().host;
}
