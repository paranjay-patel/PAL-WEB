import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:found_space_flutter_web_application/assets.dart';
import 'package:found_space_flutter_web_application/common/found_space_constants.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:found_space_flutter_web_application/src/models/timezone.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';

import 'package:found_space_flutter_web_application/common/mobx_provider.dart';

part 'sauna_date_and_time_page.store.g.dart';

enum SaunaDateAndTimeType { date, time, timezone, none }

class SaunaDateAndTimePageStore = _SaunaDateAndTimePageStoreBase with _$SaunaDateAndTimePageStore;

abstract class _SaunaDateAndTimePageStoreBase with Store, Disposable {
  final _saunaStore = locator<SaunaStore>();

  @computed
  bool get isAutomaticDateAndTime => _saunaStore.ntpEnabled;

  @readonly
  SaunaDateAndTimeType _saunaDateAndTimeType = SaunaDateAndTimeType.none;

  @readonly
  DateTime _date = DateTime.now();

  @readonly
  TimeOfDay _time = TimeOfDay.now();

  @readonly
  bool _isLoading = false;

  @readonly
  bool _isDateTimeLoading = false;

  DateTime get currentDateAndTime => DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);

  @readonly
  String _currentTimeZone = '';

  @readonly
  String _currentUTCTimeZone = '';

  @readonly
  List<TimeZone> _timeZones = [];

  void setup() {
    startTimer();
    _date = _saunaStore.currentDateTime ?? DateTime.now();
    _currentUTCTimeZone = _saunaStore.timezone;
    _time = TimeOfDay.fromDateTime(_date);
    _fetchTimeZones();
  }

  @computed
  String get currentDate {
    final formatter = DateFormat('E, MMM d');
    final formatted = formatter.format(_date);
    return formatted;
  }

  @computed
  String get currentYear {
    final formatter = DateFormat('yyyy');
    final formatted = formatter.format(_date);
    return formatted;
  }

  @computed
  String get currentTime {
    final minute = _time.minute;
    final minuteString = minute < 10 ? '0$minute' : '$minute';
    return '${_time.hourOfPeriod}:$minuteString ${_time.period == DayPeriod.am ? 'AM' : 'PM'}';
  }

  @action
  Future<void> setAutomaticDateAndTime(bool value) async {
    if (_isLoading) return;

    _isLoading = true;
    await _saunaStore.setTimeSaunaSystem(isNtpEnabled: value);
    _isLoading = false;
  }

  late Timer _timer;

  @readonly
  int _secondsRemaining = FoundSpaceConstants.timeoutPopupDurationSecs;

  @action
  Future<void> setTimeSaunaSystem() async {
    if (_isDateTimeLoading) return;
    _isDateTimeLoading = true;

    try {
      await _saunaStore.setTimeSaunaSystem(
        isNtpEnabled: isAutomaticDateAndTime,
        localTime: currentDateAndTime.toIso8601String(),
        timezone: _currentUTCTimeZone,
      );
      _date = _saunaStore.currentDateTime ?? DateTime.now();
      _currentUTCTimeZone = _saunaStore.timezone;
      _time = TimeOfDay.fromDateTime(_date);
      _isDateTimeLoading = false;
    } catch (error, stackTrace) {
      _isDateTimeLoading = false;
      Logger().e('Error loading setTimeSaunaSystem', error, stackTrace);
    }
  }

  @action
  Future<void> _fetchTimeZones() async {
    try {
      const path = Assets.timezones;
      final data = await rootBundle.loadString(path);
      Iterable results = json.decode(data);
      _timeZones = results.map((result) => TimeZone.fromJson(result)).toList();
      setTimeZoneSectionName();
    } catch (error, stackTrace) {
      Logger().e('_fetchTimeZones', error, stackTrace);
    }
  }

  void setTimeZoneSectionName() {
    for (final zones in _timeZones) {
      final utc = zones.utc ?? [];
      final result = utc.firstWhereOrNull((element) => element == _currentUTCTimeZone);
      if (result != null) {
        _currentTimeZone = zones.text ?? '';
        return;
      }
    }
  }

  @action
  void setSaunaDateAndTimeType(SaunaDateAndTimeType value) => _saunaDateAndTimeType = value;

  @action
  void setDate(DateTime date) => _date = date;

  @action
  void setTime(TimeOfDay time) => _time = time;

  @action
  void setTimeZone(String timezone) {
    if (timezone == _currentTimeZone) {
      _currentTimeZone = '';
    } else {
      _currentTimeZone = timezone;
    }
  }

  @action
  void setUTCTimeZone(String timezone) => _currentUTCTimeZone = timezone;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
      } else {
        _secondsRemaining == 0;
        cancelTimer();
      }
    });
  }

  void cancelTimer() {
    _timer.cancel();
    _secondsRemaining = FoundSpaceConstants.timeoutPopupDurationSecs;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
