// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sauna_bluetooth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SaunaBluetoothStore on _SaunaBluetoothStoreBase, Store {
  Computed<BluetoothState>? _$bluetoothStateComputed;

  @override
  BluetoothState get bluetoothState => (_$bluetoothStateComputed ??=
          Computed<BluetoothState>(() => super.bluetoothState,
              name: '_SaunaBluetoothStoreBase.bluetoothState'))
      .value;
  Computed<String>? _$bluetoothNameComputed;

  @override
  String get bluetoothName =>
      (_$bluetoothNameComputed ??= Computed<String>(() => super.bluetoothName,
              name: '_SaunaBluetoothStoreBase.bluetoothName'))
          .value;
  Computed<String>? _$bluetoothAdvertiserNameComputed;

  @override
  String get bluetoothAdvertiserName => (_$bluetoothAdvertiserNameComputed ??=
          Computed<String>(() => super.bluetoothAdvertiserName,
              name: '_SaunaBluetoothStoreBase.bluetoothAdvertiserName'))
      .value;
  Computed<Bluetooth?>? _$bluetoothComputed;

  @override
  Bluetooth? get bluetooth =>
      (_$bluetoothComputed ??= Computed<Bluetooth?>(() => super.bluetooth,
              name: '_SaunaBluetoothStoreBase.bluetooth'))
          .value;
  Computed<bool>? _$isBluetoothConnectedComputed;

  @override
  bool get isBluetoothConnected => (_$isBluetoothConnectedComputed ??=
          Computed<bool>(() => super.isBluetoothConnected,
              name: '_SaunaBluetoothStoreBase.isBluetoothConnected'))
      .value;
  Computed<bool>? _$isMusicPlayingComputed;

  @override
  bool get isMusicPlaying =>
      (_$isMusicPlayingComputed ??= Computed<bool>(() => super.isMusicPlaying,
              name: '_SaunaBluetoothStoreBase.isMusicPlaying'))
          .value;
  Computed<bool>? _$isAmbientSoundPlayingComputed;

  @override
  bool get isAmbientSoundPlaying => (_$isAmbientSoundPlayingComputed ??=
          Computed<bool>(() => super.isAmbientSoundPlaying,
              name: '_SaunaBluetoothStoreBase.isAmbientSoundPlaying'))
      .value;
  Computed<bool>? _$isAudioPlayingComputed;

  @override
  bool get isAudioPlaying =>
      (_$isAudioPlayingComputed ??= Computed<bool>(() => super.isAudioPlaying,
              name: '_SaunaBluetoothStoreBase.isAudioPlaying'))
          .value;
  Computed<bool>? _$isBluetoothMediaAvailableComputed;

  @override
  bool get isBluetoothMediaAvailable => (_$isBluetoothMediaAvailableComputed ??=
          Computed<bool>(() => super.isBluetoothMediaAvailable,
              name: '_SaunaBluetoothStoreBase.isBluetoothMediaAvailable'))
      .value;
  Computed<bool>? _$isBluetoothMediaStoppedComputed;

  @override
  bool get isBluetoothMediaStopped => (_$isBluetoothMediaStoppedComputed ??=
          Computed<bool>(() => super.isBluetoothMediaStopped,
              name: '_SaunaBluetoothStoreBase.isBluetoothMediaStopped'))
      .value;
  Computed<BluetoothMediaStatus>? _$bluetoothMediaStatusComputed;

  @override
  BluetoothMediaStatus get bluetoothMediaStatus =>
      (_$bluetoothMediaStatusComputed ??= Computed<BluetoothMediaStatus>(
              () => super.bluetoothMediaStatus,
              name: '_SaunaBluetoothStoreBase.bluetoothMediaStatus'))
          .value;
  Computed<double>? _$positionComputed;

  @override
  double get position =>
      (_$positionComputed ??= Computed<double>(() => super.position,
              name: '_SaunaBluetoothStoreBase.position'))
          .value;
  Computed<double>? _$durationComputed;

  @override
  double get duration =>
      (_$durationComputed ??= Computed<double>(() => super.duration,
              name: '_SaunaBluetoothStoreBase.duration'))
          .value;
  Computed<String>? _$currentDurationComputed;

  @override
  String get currentDuration => (_$currentDurationComputed ??= Computed<String>(
          () => super.currentDuration,
          name: '_SaunaBluetoothStoreBase.currentDuration'))
      .value;
  Computed<String>? _$currentPositionComputed;

  @override
  String get currentPosition => (_$currentPositionComputed ??= Computed<String>(
          () => super.currentPosition,
          name: '_SaunaBluetoothStoreBase.currentPosition'))
      .value;
  Computed<int>? _$trackNumberComputed;

  @override
  int get trackNumber =>
      (_$trackNumberComputed ??= Computed<int>(() => super.trackNumber,
              name: '_SaunaBluetoothStoreBase.trackNumber'))
          .value;
  Computed<int>? _$numberOfTracksComputed;

  @override
  int get numberOfTracks =>
      (_$numberOfTracksComputed ??= Computed<int>(() => super.numberOfTracks,
              name: '_SaunaBluetoothStoreBase.numberOfTracks'))
          .value;
  Computed<String>? _$trackTitleComputed;

  @override
  String get trackTitle =>
      (_$trackTitleComputed ??= Computed<String>(() => super.trackTitle,
              name: '_SaunaBluetoothStoreBase.trackTitle'))
          .value;
  Computed<String>? _$trackArtistComputed;

  @override
  String get trackArtist =>
      (_$trackArtistComputed ??= Computed<String>(() => super.trackArtist,
              name: '_SaunaBluetoothStoreBase.trackArtist'))
          .value;
  Computed<String>? _$trackAlbumComputed;

  @override
  String get trackAlbum =>
      (_$trackAlbumComputed ??= Computed<String>(() => super.trackAlbum,
              name: '_SaunaBluetoothStoreBase.trackAlbum'))
          .value;
  Computed<String>? _$trackGenreComputed;

  @override
  String get trackGenre =>
      (_$trackGenreComputed ??= Computed<String>(() => super.trackGenre,
              name: '_SaunaBluetoothStoreBase.trackGenre'))
          .value;
  Computed<bool>? _$canGoToPreviousTrackComputed;

  @override
  bool get canGoToPreviousTrack => (_$canGoToPreviousTrackComputed ??=
          Computed<bool>(() => super.canGoToPreviousTrack,
              name: '_SaunaBluetoothStoreBase.canGoToPreviousTrack'))
      .value;
  Computed<bool>? _$canGoToNextTrackComputed;

  @override
  bool get canGoToNextTrack => (_$canGoToNextTrackComputed ??= Computed<bool>(
          () => super.canGoToNextTrack,
          name: '_SaunaBluetoothStoreBase.canGoToNextTrack'))
      .value;

  late final _$_isBluetoothEnableDisableLoadingAtom = Atom(
      name: '_SaunaBluetoothStoreBase._isBluetoothEnableDisableLoading',
      context: context);

  bool get isBluetoothEnableDisableLoading {
    _$_isBluetoothEnableDisableLoadingAtom.reportRead();
    return super._isBluetoothEnableDisableLoading;
  }

  @override
  bool get _isBluetoothEnableDisableLoading => isBluetoothEnableDisableLoading;

  @override
  set _isBluetoothEnableDisableLoading(bool value) {
    _$_isBluetoothEnableDisableLoadingAtom
        .reportWrite(value, super._isBluetoothEnableDisableLoading, () {
      super._isBluetoothEnableDisableLoading = value;
    });
  }

  late final _$_bluetoothParingStateAtom = Atom(
      name: '_SaunaBluetoothStoreBase._bluetoothParingState', context: context);

  BluetoothParingState? get bluetoothParingState {
    _$_bluetoothParingStateAtom.reportRead();
    return super._bluetoothParingState;
  }

  @override
  BluetoothParingState? get _bluetoothParingState => bluetoothParingState;

  @override
  set _bluetoothParingState(BluetoothParingState? value) {
    _$_bluetoothParingStateAtom.reportWrite(value, super._bluetoothParingState,
        () {
      super._bluetoothParingState = value;
    });
  }

  late final _$_isAudioBufferingAtom = Atom(
      name: '_SaunaBluetoothStoreBase._isAudioBuffering', context: context);

  bool get isAudioBuffering {
    _$_isAudioBufferingAtom.reportRead();
    return super._isAudioBuffering;
  }

  @override
  bool get _isAudioBuffering => isAudioBuffering;

  @override
  set _isAudioBuffering(bool value) {
    _$_isAudioBufferingAtom.reportWrite(value, super._isAudioBuffering, () {
      super._isAudioBuffering = value;
    });
  }

  late final _$paidOrRejectBluetoothAsyncAction = AsyncAction(
      '_SaunaBluetoothStoreBase.paidOrRejectBluetooth',
      context: context);

  @override
  Future<void> paidOrRejectBluetooth(
      {required bool acceptPairing, required String address}) {
    return _$paidOrRejectBluetoothAsyncAction.run(() => super
        .paidOrRejectBluetooth(acceptPairing: acceptPairing, address: address));
  }

  late final _$enableDisabledBluetoothAsyncAction = AsyncAction(
      '_SaunaBluetoothStoreBase.enableDisabledBluetooth',
      context: context);

  @override
  Future<void> enableDisabledBluetooth() {
    return _$enableDisabledBluetoothAsyncAction
        .run(() => super.enableDisabledBluetooth());
  }

  late final _$setBluetoothMediaStatusAsyncAction = AsyncAction(
      '_SaunaBluetoothStoreBase.setBluetoothMediaStatus',
      context: context);

  @override
  Future<void> setBluetoothMediaStatus({required BluetoothMediaAction action}) {
    return _$setBluetoothMediaStatusAsyncAction
        .run(() => super.setBluetoothMediaStatus(action: action));
  }

  @override
  String toString() {
    return '''
bluetoothState: ${bluetoothState},
bluetoothName: ${bluetoothName},
bluetoothAdvertiserName: ${bluetoothAdvertiserName},
bluetooth: ${bluetooth},
isBluetoothConnected: ${isBluetoothConnected},
isMusicPlaying: ${isMusicPlaying},
isAmbientSoundPlaying: ${isAmbientSoundPlaying},
isAudioPlaying: ${isAudioPlaying},
isBluetoothMediaAvailable: ${isBluetoothMediaAvailable},
isBluetoothMediaStopped: ${isBluetoothMediaStopped},
bluetoothMediaStatus: ${bluetoothMediaStatus},
position: ${position},
duration: ${duration},
currentDuration: ${currentDuration},
currentPosition: ${currentPosition},
trackNumber: ${trackNumber},
numberOfTracks: ${numberOfTracks},
trackTitle: ${trackTitle},
trackArtist: ${trackArtist},
trackAlbum: ${trackAlbum},
trackGenre: ${trackGenre},
canGoToPreviousTrack: ${canGoToPreviousTrack},
canGoToNextTrack: ${canGoToNextTrack}
    ''';
  }
}
