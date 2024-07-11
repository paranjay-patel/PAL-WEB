// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_player.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AudioPlayerStore on _AudioPlayerStoreBase, Store {
  Computed<List<Ambience>>? _$ambientSoundsComputed;

  @override
  List<Ambience> get ambientSounds => (_$ambientSoundsComputed ??=
          Computed<List<Ambience>>(() => super.ambientSounds,
              name: '_AudioPlayerStoreBase.ambientSounds'))
      .value;
  Computed<List<SystemSound>>? _$systemSoundsComputed;

  @override
  List<SystemSound> get systemSounds => (_$systemSoundsComputed ??=
          Computed<List<SystemSound>>(() => super.systemSounds,
              name: '_AudioPlayerStoreBase.systemSounds'))
      .value;
  Computed<List<MediaPlayer>>? _$_mediaPlayersComputed;

  @override
  List<MediaPlayer> get _mediaPlayers => (_$_mediaPlayersComputed ??=
          Computed<List<MediaPlayer>>(() => super._mediaPlayers,
              name: '_AudioPlayerStoreBase._mediaPlayers'))
      .value;
  Computed<List<MediaPlayer>>? _$_ambientMediaPlayersComputed;

  @override
  List<MediaPlayer> get _ambientMediaPlayers =>
      (_$_ambientMediaPlayersComputed ??= Computed<List<MediaPlayer>>(
              () => super._ambientMediaPlayers,
              name: '_AudioPlayerStoreBase._ambientMediaPlayers'))
          .value;
  Computed<bool>? _$isAmbientSoundPlayingComputed;

  @override
  bool get isAmbientSoundPlaying => (_$isAmbientSoundPlayingComputed ??=
          Computed<bool>(() => super.isAmbientSoundPlaying,
              name: '_AudioPlayerStoreBase.isAmbientSoundPlaying'))
      .value;

  late final _$_isBootUpFinishedAtom =
      Atom(name: '_AudioPlayerStoreBase._isBootUpFinished', context: context);

  bool get isBootUpFinished {
    _$_isBootUpFinishedAtom.reportRead();
    return super._isBootUpFinished;
  }

  @override
  bool get _isBootUpFinished => isBootUpFinished;

  @override
  set _isBootUpFinished(bool value) {
    _$_isBootUpFinishedAtom.reportWrite(value, super._isBootUpFinished, () {
      super._isBootUpFinished = value;
    });
  }

  late final _$setupAudioPlayersAsyncAction =
      AsyncAction('_AudioPlayerStoreBase.setupAudioPlayers', context: context);

  @override
  Future<void> setupAudioPlayers() {
    return _$setupAudioPlayersAsyncAction.run(() => super.setupAudioPlayers());
  }

  late final _$reloadMediaPlayersAsyncAction =
      AsyncAction('_AudioPlayerStoreBase.reloadMediaPlayers', context: context);

  @override
  Future<void> reloadMediaPlayers() {
    return _$reloadMediaPlayersAsyncAction
        .run(() => super.reloadMediaPlayers());
  }

  late final _$playSystemSoundAsyncAction =
      AsyncAction('_AudioPlayerStoreBase.playSystemSound', context: context);

  @override
  Future<void> playSystemSound(
      {required SaunaSystemSoundType saunaSystemSoundType}) {
    return _$playSystemSoundAsyncAction.run(() =>
        super.playSystemSound(saunaSystemSoundType: saunaSystemSoundType));
  }

  late final _$playSessionStateSoundAsyncAction = AsyncAction(
      '_AudioPlayerStoreBase.playSessionStateSound',
      context: context);

  @override
  Future<void> playSessionStateSound({required SaunaState state}) {
    return _$playSessionStateSoundAsyncAction
        .run(() => super.playSessionStateSound(state: state));
  }

  late final _$_createPlaylistByPlayerAsyncAction = AsyncAction(
      '_AudioPlayerStoreBase._createPlaylistByPlayer',
      context: context);

  @override
  Future<void> _createPlaylistByPlayer() {
    return _$_createPlaylistByPlayerAsyncAction
        .run(() => super._createPlaylistByPlayer());
  }

  late final _$playAllPlayersAsyncAction =
      AsyncAction('_AudioPlayerStoreBase.playAllPlayers', context: context);

  @override
  Future<void> playAllPlayers() {
    return _$playAllPlayersAsyncAction.run(() => super.playAllPlayers());
  }

  late final _$pauseAllPlayersAsyncAction =
      AsyncAction('_AudioPlayerStoreBase.pauseAllPlayers', context: context);

  @override
  Future<void> pauseAllPlayers(
      {MediaPlayerAction actionType = MediaPlayerAction.pause}) {
    return _$pauseAllPlayersAsyncAction
        .run(() => super.pauseAllPlayers(actionType: actionType));
  }

  late final _$setSaunaAmbienceSelectionAsyncAction = AsyncAction(
      '_AudioPlayerStoreBase.setSaunaAmbienceSelection',
      context: context);

  @override
  Future<void> setSaunaAmbienceSelection({required Ambience ambience}) {
    return _$setSaunaAmbienceSelectionAsyncAction
        .run(() => super.setSaunaAmbienceSelection(ambience: ambience));
  }

  late final _$_pauseOnDeselectAsyncAction =
      AsyncAction('_AudioPlayerStoreBase._pauseOnDeselect', context: context);

  @override
  Future<void> _pauseOnDeselect({required Ambience ambience}) {
    return _$_pauseOnDeselectAsyncAction
        .run(() => super._pauseOnDeselect(ambience: ambience));
  }

  @override
  String toString() {
    return '''
ambientSounds: ${ambientSounds},
systemSounds: ${systemSounds},
isAmbientSoundPlaying: ${isAmbientSoundPlaying}
    ''';
  }
}
