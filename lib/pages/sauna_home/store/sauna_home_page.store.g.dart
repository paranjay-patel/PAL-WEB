// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sauna_home_page.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SaunaHomePageStore on _SaunaHomePageStoreBase, Store {
  late final _$_selectedSaunaModeAtom = Atom(
      name: '_SaunaHomePageStoreBase._selectedSaunaMode', context: context);

  SaunaMode get selectedSaunaMode {
    _$_selectedSaunaModeAtom.reportRead();
    return super._selectedSaunaMode;
  }

  @override
  SaunaMode get _selectedSaunaMode => selectedSaunaMode;

  @override
  set _selectedSaunaMode(SaunaMode value) {
    _$_selectedSaunaModeAtom.reportWrite(value, super._selectedSaunaMode, () {
      super._selectedSaunaMode = value;
    });
  }

  late final _$isExpandedBrightnessBarAtom = Atom(
      name: '_SaunaHomePageStoreBase.isExpandedBrightnessBar',
      context: context);

  @override
  bool get isExpandedBrightnessBar {
    _$isExpandedBrightnessBarAtom.reportRead();
    return super.isExpandedBrightnessBar;
  }

  @override
  set isExpandedBrightnessBar(bool value) {
    _$isExpandedBrightnessBarAtom
        .reportWrite(value, super.isExpandedBrightnessBar, () {
      super.isExpandedBrightnessBar = value;
    });
  }

  late final _$isExpandedMenuButtonAtom = Atom(
      name: '_SaunaHomePageStoreBase.isExpandedMenuButton', context: context);

  @override
  bool get isExpandedMenuButton {
    _$isExpandedMenuButtonAtom.reportRead();
    return super.isExpandedMenuButton;
  }

  @override
  set isExpandedMenuButton(bool value) {
    _$isExpandedMenuButtonAtom.reportWrite(value, super.isExpandedMenuButton,
        () {
      super.isExpandedMenuButton = value;
    });
  }

  late final _$_isSettingTappedAtom =
      Atom(name: '_SaunaHomePageStoreBase._isSettingTapped', context: context);

  bool get isSettingTapped {
    _$_isSettingTappedAtom.reportRead();
    return super._isSettingTapped;
  }

  @override
  bool get _isSettingTapped => isSettingTapped;

  @override
  set _isSettingTapped(bool value) {
    _$_isSettingTappedAtom.reportWrite(value, super._isSettingTapped, () {
      super._isSettingTapped = value;
    });
  }

  late final _$shouldShowProgramsAtom = Atom(
      name: '_SaunaHomePageStoreBase.shouldShowPrograms', context: context);

  @override
  bool get shouldShowPrograms {
    _$shouldShowProgramsAtom.reportRead();
    return super.shouldShowPrograms;
  }

  @override
  set shouldShowPrograms(bool value) {
    _$shouldShowProgramsAtom.reportWrite(value, super.shouldShowPrograms, () {
      super.shouldShowPrograms = value;
    });
  }

  late final _$_isExpandedVolumeBarAtom = Atom(
      name: '_SaunaHomePageStoreBase._isExpandedVolumeBar', context: context);

  bool get isExpandedVolumeBar {
    _$_isExpandedVolumeBarAtom.reportRead();
    return super._isExpandedVolumeBar;
  }

  @override
  bool get _isExpandedVolumeBar => isExpandedVolumeBar;

  @override
  set _isExpandedVolumeBar(bool value) {
    _$_isExpandedVolumeBarAtom.reportWrite(value, super._isExpandedVolumeBar,
        () {
      super._isExpandedVolumeBar = value;
    });
  }

  late final _$setSelectedSaunaModeAsyncAction = AsyncAction(
      '_SaunaHomePageStoreBase.setSelectedSaunaMode',
      context: context);

  @override
  Future<void> setSelectedSaunaMode(SaunaMode saunaMode) {
    return _$setSelectedSaunaModeAsyncAction
        .run(() => super.setSelectedSaunaMode(saunaMode));
  }

  late final _$settingButtonTappedAsyncAction = AsyncAction(
      '_SaunaHomePageStoreBase.settingButtonTapped',
      context: context);

  @override
  Future<void> settingButtonTapped() {
    return _$settingButtonTappedAsyncAction
        .run(() => super.settingButtonTapped());
  }

  late final _$_SaunaHomePageStoreBaseActionController =
      ActionController(name: '_SaunaHomePageStoreBase', context: context);

  @override
  void setExpandedVolumeBar(bool isExpanded) {
    final _$actionInfo = _$_SaunaHomePageStoreBaseActionController.startAction(
        name: '_SaunaHomePageStoreBase.setExpandedVolumeBar');
    try {
      return super.setExpandedVolumeBar(isExpanded);
    } finally {
      _$_SaunaHomePageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isExpandedBrightnessBar: ${isExpandedBrightnessBar},
isExpandedMenuButton: ${isExpandedMenuButton},
shouldShowPrograms: ${shouldShowPrograms}
    ''';
  }
}
