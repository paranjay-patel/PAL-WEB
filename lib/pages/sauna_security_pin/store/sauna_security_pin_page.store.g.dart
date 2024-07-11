// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sauna_security_pin_page.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SaunaSecurityPinPageStore on _SaunaSecurityPinPageStoreBase, Store {
  Computed<List<String>>? _$securityPinsComputed;

  @override
  List<String> get securityPins => (_$securityPinsComputed ??=
          Computed<List<String>>(() => super.securityPins,
              name: '_SaunaSecurityPinPageStoreBase.securityPins'))
      .value;

  late final _$_pageStateAtom =
      Atom(name: '_SaunaSecurityPinPageStoreBase._pageState', context: context);

  SaunaSecurityPinPageState get pageState {
    _$_pageStateAtom.reportRead();
    return super._pageState;
  }

  @override
  SaunaSecurityPinPageState get _pageState => pageState;

  @override
  set _pageState(SaunaSecurityPinPageState value) {
    _$_pageStateAtom.reportWrite(value, super._pageState, () {
      super._pageState = value;
    });
  }

  late final _$_pageActionAtom = Atom(
      name: '_SaunaSecurityPinPageStoreBase._pageAction', context: context);

  SaunaSecurityPinPageAction get pageAction {
    _$_pageActionAtom.reportRead();
    return super._pageAction;
  }

  @override
  SaunaSecurityPinPageAction get _pageAction => pageAction;

  @override
  set _pageAction(SaunaSecurityPinPageAction value) {
    _$_pageActionAtom.reportWrite(value, super._pageAction, () {
      super._pageAction = value;
    });
  }

  late final _$_isSucceedAtom =
      Atom(name: '_SaunaSecurityPinPageStoreBase._isSucceed', context: context);

  bool? get isSucceed {
    _$_isSucceedAtom.reportRead();
    return super._isSucceed;
  }

  @override
  bool? get _isSucceed => isSucceed;

  @override
  set _isSucceed(bool? value) {
    _$_isSucceedAtom.reportWrite(value, super._isSucceed, () {
      super._isSucceed = value;
    });
  }

  late final _$_isDisabledStateAtom = Atom(
      name: '_SaunaSecurityPinPageStoreBase._isDisabledState',
      context: context);

  bool get isDisabledState {
    _$_isDisabledStateAtom.reportRead();
    return super._isDisabledState;
  }

  @override
  bool get _isDisabledState => isDisabledState;

  @override
  set _isDisabledState(bool value) {
    _$_isDisabledStateAtom.reportWrite(value, super._isDisabledState, () {
      super._isDisabledState = value;
    });
  }

  late final _$_dismissPopupSecondsRemainingAtom = Atom(
      name: '_SaunaSecurityPinPageStoreBase._dismissPopupSecondsRemaining',
      context: context);

  int get dismissPopupSecondsRemaining {
    _$_dismissPopupSecondsRemainingAtom.reportRead();
    return super._dismissPopupSecondsRemaining;
  }

  @override
  int get _dismissPopupSecondsRemaining => dismissPopupSecondsRemaining;

  @override
  set _dismissPopupSecondsRemaining(int value) {
    _$_dismissPopupSecondsRemainingAtom
        .reportWrite(value, super._dismissPopupSecondsRemaining, () {
      super._dismissPopupSecondsRemaining = value;
    });
  }

  late final _$_isForgetScreenOpenAtom = Atom(
      name: '_SaunaSecurityPinPageStoreBase._isForgetScreenOpen',
      context: context);

  bool get isForgetScreenOpen {
    _$_isForgetScreenOpenAtom.reportRead();
    return super._isForgetScreenOpen;
  }

  @override
  bool get _isForgetScreenOpen => isForgetScreenOpen;

  @override
  set _isForgetScreenOpen(bool value) {
    _$_isForgetScreenOpenAtom.reportWrite(value, super._isForgetScreenOpen, () {
      super._isForgetScreenOpen = value;
    });
  }

  late final _$_secondsRemainingAtom = Atom(
      name: '_SaunaSecurityPinPageStoreBase._secondsRemaining',
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

  late final _$setSecurityPinAsyncAction = AsyncAction(
      '_SaunaSecurityPinPageStoreBase.setSecurityPin',
      context: context);

  @override
  Future<void> setSecurityPin(String pin) {
    return _$setSecurityPinAsyncAction.run(() => super.setSecurityPin(pin));
  }

  late final _$_SaunaSecurityPinPageStoreBaseActionController =
      ActionController(
          name: '_SaunaSecurityPinPageStoreBase', context: context);

  @override
  void setIsForgetScreenOpen(bool isForgetScreenOpen) {
    final _$actionInfo =
        _$_SaunaSecurityPinPageStoreBaseActionController.startAction(
            name: '_SaunaSecurityPinPageStoreBase.setIsForgetScreenOpen');
    try {
      return super.setIsForgetScreenOpen(isForgetScreenOpen);
    } finally {
      _$_SaunaSecurityPinPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSaunaSecurityPinPageState(SaunaSecurityPinPageState state) {
    final _$actionInfo =
        _$_SaunaSecurityPinPageStoreBaseActionController.startAction(
            name:
                '_SaunaSecurityPinPageStoreBase.setSaunaSecurityPinPageState');
    try {
      return super.setSaunaSecurityPinPageState(state);
    } finally {
      _$_SaunaSecurityPinPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSaunaSecurityPinPageAction(SaunaSecurityPinPageAction action) {
    final _$actionInfo =
        _$_SaunaSecurityPinPageStoreBaseActionController.startAction(
            name:
                '_SaunaSecurityPinPageStoreBase.setSaunaSecurityPinPageAction');
    try {
      return super.setSaunaSecurityPinPageAction(action);
    } finally {
      _$_SaunaSecurityPinPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSucceed(bool? isSucceed) {
    final _$actionInfo = _$_SaunaSecurityPinPageStoreBaseActionController
        .startAction(name: '_SaunaSecurityPinPageStoreBase.setSucceed');
    try {
      return super.setSucceed(isSucceed);
    } finally {
      _$_SaunaSecurityPinPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsDisabledState(bool isDisabledState) {
    final _$actionInfo = _$_SaunaSecurityPinPageStoreBaseActionController
        .startAction(name: '_SaunaSecurityPinPageStoreBase.setIsDisabledState');
    try {
      return super.setIsDisabledState(isDisabledState);
    } finally {
      _$_SaunaSecurityPinPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeSecurityPin() {
    final _$actionInfo = _$_SaunaSecurityPinPageStoreBaseActionController
        .startAction(name: '_SaunaSecurityPinPageStoreBase.removeSecurityPin');
    try {
      return super.removeSecurityPin();
    } finally {
      _$_SaunaSecurityPinPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
securityPins: ${securityPins}
    ''';
  }
}
