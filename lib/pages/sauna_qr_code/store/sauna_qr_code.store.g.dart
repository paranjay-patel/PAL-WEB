// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sauna_qr_code.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SaunaQRCodeStore on _SaunaQRCodeStoreBase, Store {
  late final _$_isInternetConnectedAtom = Atom(
      name: '_SaunaQRCodeStoreBase._isInternetConnected', context: context);

  bool get isInternetConnected {
    _$_isInternetConnectedAtom.reportRead();
    return super._isInternetConnected;
  }

  @override
  bool get _isInternetConnected => isInternetConnected;

  @override
  set _isInternetConnected(bool value) {
    _$_isInternetConnectedAtom.reportWrite(value, super._isInternetConnected,
        () {
      super._isInternetConnected = value;
    });
  }

  late final _$_qrCodeAtom =
      Atom(name: '_SaunaQRCodeStoreBase._qrCode', context: context);

  String get qrCode {
    _$_qrCodeAtom.reportRead();
    return super._qrCode;
  }

  @override
  String get _qrCode => qrCode;

  @override
  set _qrCode(String value) {
    _$_qrCodeAtom.reportWrite(value, super._qrCode, () {
      super._qrCode = value;
    });
  }

  late final _$_isLoadingAtom =
      Atom(name: '_SaunaQRCodeStoreBase._isLoading', context: context);

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

  late final _$_secondsRemainingAtom =
      Atom(name: '_SaunaQRCodeStoreBase._secondsRemaining', context: context);

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

  late final _$retryAsyncAction =
      AsyncAction('_SaunaQRCodeStoreBase.retry', context: context);

  @override
  Future<void> retry() {
    return _$retryAsyncAction.run(() => super.retry());
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
