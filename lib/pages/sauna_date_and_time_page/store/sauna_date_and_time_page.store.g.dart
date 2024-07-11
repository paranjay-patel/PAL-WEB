// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sauna_date_and_time_page.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SaunaDateAndTimePageStore on _SaunaDateAndTimePageStoreBase, Store {
  Computed<bool>? _$isAutomaticDateAndTimeComputed;

  @override
  bool get isAutomaticDateAndTime => (_$isAutomaticDateAndTimeComputed ??=
          Computed<bool>(() => super.isAutomaticDateAndTime,
              name: '_SaunaDateAndTimePageStoreBase.isAutomaticDateAndTime'))
      .value;
  Computed<String>? _$currentDateComputed;

  @override
  String get currentDate =>
      (_$currentDateComputed ??= Computed<String>(() => super.currentDate,
              name: '_SaunaDateAndTimePageStoreBase.currentDate'))
          .value;
  Computed<String>? _$currentYearComputed;

  @override
  String get currentYear =>
      (_$currentYearComputed ??= Computed<String>(() => super.currentYear,
              name: '_SaunaDateAndTimePageStoreBase.currentYear'))
          .value;
  Computed<String>? _$currentTimeComputed;

  @override
  String get currentTime =>
      (_$currentTimeComputed ??= Computed<String>(() => super.currentTime,
              name: '_SaunaDateAndTimePageStoreBase.currentTime'))
          .value;

  late final _$_saunaDateAndTimeTypeAtom = Atom(
      name: '_SaunaDateAndTimePageStoreBase._saunaDateAndTimeType',
      context: context);

  SaunaDateAndTimeType get saunaDateAndTimeType {
    _$_saunaDateAndTimeTypeAtom.reportRead();
    return super._saunaDateAndTimeType;
  }

  @override
  SaunaDateAndTimeType get _saunaDateAndTimeType => saunaDateAndTimeType;

  @override
  set _saunaDateAndTimeType(SaunaDateAndTimeType value) {
    _$_saunaDateAndTimeTypeAtom.reportWrite(value, super._saunaDateAndTimeType,
        () {
      super._saunaDateAndTimeType = value;
    });
  }

  late final _$_dateAtom =
      Atom(name: '_SaunaDateAndTimePageStoreBase._date', context: context);

  DateTime get date {
    _$_dateAtom.reportRead();
    return super._date;
  }

  @override
  DateTime get _date => date;

  @override
  set _date(DateTime value) {
    _$_dateAtom.reportWrite(value, super._date, () {
      super._date = value;
    });
  }

  late final _$_timeAtom =
      Atom(name: '_SaunaDateAndTimePageStoreBase._time', context: context);

  TimeOfDay get time {
    _$_timeAtom.reportRead();
    return super._time;
  }

  @override
  TimeOfDay get _time => time;

  @override
  set _time(TimeOfDay value) {
    _$_timeAtom.reportWrite(value, super._time, () {
      super._time = value;
    });
  }

  late final _$_isLoadingAtom =
      Atom(name: '_SaunaDateAndTimePageStoreBase._isLoading', context: context);

  bool get isLoading {
    _$_isLoadingAtom.reportRead();
    return super._isLoading;
  }

  @override
  bool get _isLoading => isLoading;

  @override
  set _isLoading(bool value) {
    _$_isLoadingAtom.reportWrite(value, super._isLoading, () {
      super._isLoading = value;
    });
  }

  late final _$_isDateTimeLoadingAtom = Atom(
      name: '_SaunaDateAndTimePageStoreBase._isDateTimeLoading',
      context: context);

  bool get isDateTimeLoading {
    _$_isDateTimeLoadingAtom.reportRead();
    return super._isDateTimeLoading;
  }

  @override
  bool get _isDateTimeLoading => isDateTimeLoading;

  @override
  set _isDateTimeLoading(bool value) {
    _$_isDateTimeLoadingAtom.reportWrite(value, super._isDateTimeLoading, () {
      super._isDateTimeLoading = value;
    });
  }

  late final _$_currentTimeZoneAtom = Atom(
      name: '_SaunaDateAndTimePageStoreBase._currentTimeZone',
      context: context);

  String get currentTimeZone {
    _$_currentTimeZoneAtom.reportRead();
    return super._currentTimeZone;
  }

  @override
  String get _currentTimeZone => currentTimeZone;

  @override
  set _currentTimeZone(String value) {
    _$_currentTimeZoneAtom.reportWrite(value, super._currentTimeZone, () {
      super._currentTimeZone = value;
    });
  }

  late final _$_currentUTCTimeZoneAtom = Atom(
      name: '_SaunaDateAndTimePageStoreBase._currentUTCTimeZone',
      context: context);

  String get currentUTCTimeZone {
    _$_currentUTCTimeZoneAtom.reportRead();
    return super._currentUTCTimeZone;
  }

  @override
  String get _currentUTCTimeZone => currentUTCTimeZone;

  @override
  set _currentUTCTimeZone(String value) {
    _$_currentUTCTimeZoneAtom.reportWrite(value, super._currentUTCTimeZone, () {
      super._currentUTCTimeZone = value;
    });
  }

  late final _$_timeZonesAtom =
      Atom(name: '_SaunaDateAndTimePageStoreBase._timeZones', context: context);

  List<TimeZone> get timeZones {
    _$_timeZonesAtom.reportRead();
    return super._timeZones;
  }

  @override
  List<TimeZone> get _timeZones => timeZones;

  @override
  set _timeZones(List<TimeZone> value) {
    _$_timeZonesAtom.reportWrite(value, super._timeZones, () {
      super._timeZones = value;
    });
  }

  late final _$_secondsRemainingAtom = Atom(
      name: '_SaunaDateAndTimePageStoreBase._secondsRemaining',
      context: context);

  int get secondsRemaining {
    _$_secondsRemainingAtom.reportRead();
    return super._secondsRemaining;
  }

  @override
  int get _secondsRemaining => secondsRemaining;

  @override
  set _secondsRemaining(int value) {
    _$_secondsRemainingAtom.reportWrite(value, super._secondsRemaining, () {
      super._secondsRemaining = value;
    });
  }

  late final _$setAutomaticDateAndTimeAsyncAction = AsyncAction(
      '_SaunaDateAndTimePageStoreBase.setAutomaticDateAndTime',
      context: context);

  @override
  Future<void> setAutomaticDateAndTime(bool value) {
    return _$setAutomaticDateAndTimeAsyncAction
        .run(() => super.setAutomaticDateAndTime(value));
  }

  late final _$setTimeSaunaSystemAsyncAction = AsyncAction(
      '_SaunaDateAndTimePageStoreBase.setTimeSaunaSystem',
      context: context);

  @override
  Future<void> setTimeSaunaSystem() {
    return _$setTimeSaunaSystemAsyncAction
        .run(() => super.setTimeSaunaSystem());
  }

  late final _$_fetchTimeZonesAsyncAction = AsyncAction(
      '_SaunaDateAndTimePageStoreBase._fetchTimeZones',
      context: context);

  @override
  Future<void> _fetchTimeZones() {
    return _$_fetchTimeZonesAsyncAction.run(() => super._fetchTimeZones());
  }

  late final _$_SaunaDateAndTimePageStoreBaseActionController =
      ActionController(
          name: '_SaunaDateAndTimePageStoreBase', context: context);

  @override
  void setSaunaDateAndTimeType(SaunaDateAndTimeType value) {
    final _$actionInfo =
        _$_SaunaDateAndTimePageStoreBaseActionController.startAction(
            name: '_SaunaDateAndTimePageStoreBase.setSaunaDateAndTimeType');
    try {
      return super.setSaunaDateAndTimeType(value);
    } finally {
      _$_SaunaDateAndTimePageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDate(DateTime date) {
    final _$actionInfo = _$_SaunaDateAndTimePageStoreBaseActionController
        .startAction(name: '_SaunaDateAndTimePageStoreBase.setDate');
    try {
      return super.setDate(date);
    } finally {
      _$_SaunaDateAndTimePageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTime(TimeOfDay time) {
    final _$actionInfo = _$_SaunaDateAndTimePageStoreBaseActionController
        .startAction(name: '_SaunaDateAndTimePageStoreBase.setTime');
    try {
      return super.setTime(time);
    } finally {
      _$_SaunaDateAndTimePageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTimeZone(String timezone) {
    final _$actionInfo = _$_SaunaDateAndTimePageStoreBaseActionController
        .startAction(name: '_SaunaDateAndTimePageStoreBase.setTimeZone');
    try {
      return super.setTimeZone(timezone);
    } finally {
      _$_SaunaDateAndTimePageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUTCTimeZone(String timezone) {
    final _$actionInfo = _$_SaunaDateAndTimePageStoreBaseActionController
        .startAction(name: '_SaunaDateAndTimePageStoreBase.setUTCTimeZone');
    try {
      return super.setUTCTimeZone(timezone);
    } finally {
      _$_SaunaDateAndTimePageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isAutomaticDateAndTime: ${isAutomaticDateAndTime},
currentDate: ${currentDate},
currentYear: ${currentYear},
currentTime: ${currentTime}
    ''';
  }
}
