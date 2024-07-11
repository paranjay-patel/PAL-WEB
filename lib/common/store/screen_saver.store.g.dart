// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_saver.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ScreenSaverStore on _ScreenSaverStoreBase, Store {
  late final _$_saunaSaverSleepModeTypeAtom = Atom(
      name: '_ScreenSaverStoreBase._saunaSaverSleepModeType', context: context);

  SaunaSaverSleepModeType get saunaSaverSleepModeType {
    _$_saunaSaverSleepModeTypeAtom.reportRead();
    return super._saunaSaverSleepModeType;
  }

  @override
  SaunaSaverSleepModeType get _saunaSaverSleepModeType =>
      saunaSaverSleepModeType;

  @override
  set _saunaSaverSleepModeType(SaunaSaverSleepModeType value) {
    _$_saunaSaverSleepModeTypeAtom
        .reportWrite(value, super._saunaSaverSleepModeType, () {
      super._saunaSaverSleepModeType = value;
    });
  }

  late final _$_saunaSaverSleepDurationAtom = Atom(
      name: '_ScreenSaverStoreBase._saunaSaverSleepDuration', context: context);

  SaunaSaverSleepDuration get saunaSaverSleepDuration {
    _$_saunaSaverSleepDurationAtom.reportRead();
    return super._saunaSaverSleepDuration;
  }

  @override
  SaunaSaverSleepDuration get _saunaSaverSleepDuration =>
      saunaSaverSleepDuration;

  @override
  set _saunaSaverSleepDuration(SaunaSaverSleepDuration value) {
    _$_saunaSaverSleepDurationAtom
        .reportWrite(value, super._saunaSaverSleepDuration, () {
      super._saunaSaverSleepDuration = value;
    });
  }

  late final _$_moveToCorrespondingTabAtom = Atom(
      name: '_ScreenSaverStoreBase._moveToCorrespondingTab', context: context);

  bool get moveToCorrespondingTab {
    _$_moveToCorrespondingTabAtom.reportRead();
    return super._moveToCorrespondingTab;
  }

  @override
  bool get _moveToCorrespondingTab => moveToCorrespondingTab;

  @override
  set _moveToCorrespondingTab(bool value) {
    _$_moveToCorrespondingTabAtom
        .reportWrite(value, super._moveToCorrespondingTab, () {
      super._moveToCorrespondingTab = value;
    });
  }

  late final _$setSaunaSaverSleepModeTypeAsyncAction = AsyncAction(
      '_ScreenSaverStoreBase.setSaunaSaverSleepModeType',
      context: context);

  @override
  Future<void> setSaunaSaverSleepModeType(
      SaunaSaverSleepModeType saunaSaverSleepModeType) {
    return _$setSaunaSaverSleepModeTypeAsyncAction
        .run(() => super.setSaunaSaverSleepModeType(saunaSaverSleepModeType));
  }

  late final _$setSaunaSaverSleepDurationAsyncAction = AsyncAction(
      '_ScreenSaverStoreBase.setSaunaSaverSleepDuration',
      context: context);

  @override
  Future<void> setSaunaSaverSleepDuration(
      SaunaSaverSleepDuration saunaSaverSleepDuration) {
    return _$setSaunaSaverSleepDurationAsyncAction
        .run(() => super.setSaunaSaverSleepDuration(saunaSaverSleepDuration));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
