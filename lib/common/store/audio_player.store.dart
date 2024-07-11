import 'dart:async';
import 'package:found_space_flutter_rest_api/found_space_flutter_rest_api.dart';
import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/mobx_provider.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/sauna_audio_extension.dart';
import 'package:found_space_flutter_web_application/common/store/sauna.store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_bluetooth_store.dart';
import 'package:found_space_flutter_web_application/common/store/sauna_local_storage.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_control_popup_page/utils/sauna_audio_control_utils.dart';
import 'package:found_space_flutter_web_application/services/service_locator.dart';
import 'package:collection/collection.dart';

import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';

part 'audio_player.store.g.dart';

class AudioPlayerStore = _AudioPlayerStoreBase with _$AudioPlayerStore;

abstract class _AudioPlayerStoreBase with Store, Disposable {
  final _saunaStore = locator<SaunaStore>();
  final _saunaLocalStorageStore = locator<SaunaLocalStorageStore>();
  final _saunaBluetoothStore = locator<SaunaBluetoothStore>();
  final _logger = locator<Logger>();
  final _restAPIRepository = locator<RestAPIRepository>();
  final _reaction = CompositeReactionDisposer();

  _AudioPlayerStoreBase() {
    _setupReaction();
  }

  @computed
  List<Ambience> get ambientSounds => _saunaStore.saunaProperties?.ambientSounds ?? [];

  @computed
  List<SystemSound> get systemSounds => _saunaStore.saunaProperties?.systemSounds ?? [];

  @computed
  List<MediaPlayer> get _mediaPlayers => _saunaStore.mediaPlayers;

  @computed
  List<MediaPlayer> get _ambientMediaPlayers => _mediaPlayers.take(3).toList();

  @computed
  bool get isAmbientSoundPlaying => _saunaBluetoothStore.isAmbientSoundPlaying;

  final selectedSaunaAmbiences = ObservableList<Ambience>();

  @readonly
  bool _isBootUpFinished = false;

  int? _getSystemSoundPosition(SaunaSystemSoundType saunaSystemSoundType) {
    final systemSound = systemSounds.firstWhereOrNull((element) => element.type == saunaSystemSoundType);
    if (systemSound != null) {
      return systemSound.index;
    }
    return null;
  }

  int get systemPlayerIndex =>
      _mediaPlayers.firstWhereOrNull((element) => _ambientMediaPlayers.length == element.id)?.id ?? 0;

  @action
  Future<void> setupAudioPlayers() async {
    await _fetchSystemProperties();
  }

  Future<void> _fetchSystemProperties() async {
    await _createPlaylistByPlayer();
    _defaultSelectionOfAmbienceSounds();
  }

  @action
  Future<void> reloadMediaPlayers() async {
    final isAudioPlaying = _saunaBluetoothStore.isAudioPlaying;
    if (isAudioPlaying) {
      await pauseAllPlayers(actionType: MediaPlayerAction.stop);
    }

    // System sounds
    await _deletedPlaylist(playerId: systemPlayerIndex);

    // Add ambient sounds
    for (final mediaPlayer in _ambientMediaPlayers) {
      await _deletedPlaylist(playerId: mediaPlayer.id ?? 0);
      await _createPlaylist(playerId: mediaPlayer.id ?? 0, ambiences: ambientSounds);
    }
    selectedSaunaAmbiences.clear();
    _defaultSelectionOfAmbienceSounds();
  }

  void _setupReaction() {
    reaction<List<int>>((_) => _saunaStore.ambienceMediaPlayerPos, (ambienceMediaPlayerPos) {
      selectedSaunaAmbiences.clear();
      for (final playerPos in ambienceMediaPlayerPos) {
        if (playerPos >= 0) {
          final ambience = ambientSounds.firstWhereOrNull((element) => element.index == playerPos);
          if (ambience != null) {
            selectedSaunaAmbiences.add(ambience);
          }
        }
      }
    }).disposeWith(_reaction);
  }

  Future<void> _fetchMediaPlayerById({required String playerId}) async {
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      final result = await _restAPIRepository.fetchMediaPlayerById(
        saunaId: credentials.item2,
        playerId: playerId,
      );
      if (result != null) {
        final playIndex = _ambientMediaPlayers.indexWhere((element) => element.id.toString() == playerId);
        _ambientMediaPlayers[playIndex] = result;
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading fetchMediaPlayers', error, stackTrace);
    }
  }

  Future<void> _createPlaylist({required int playerId, required List<Ambience> ambiences}) async {
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      await _restAPIRepository.putPlaylistsById(
        saunaId: credentials.item2,
        playerId: playerId.toString(),
        mediaPlayers: ambiences.map((ambience) => MediaPlayer(filePath: ambience.path)).toList(),
      );
    } catch (error, stackTrace) {
      _logger.e('Error loading putMediaPath', error, stackTrace);
    }
  }

  Future<void> _deletedPlaylist({required int playerId}) async {
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      await _restAPIRepository.deletePlaylistsById(
        saunaId: credentials.item2,
        playerId: playerId.toString(),
      );
    } catch (error, stackTrace) {
      _logger.e('Error loading _deletedPlaylist', error, stackTrace);
    }
  }

  @action
  Future<void> playSystemSound({required SaunaSystemSoundType saunaSystemSoundType}) async {
    final credentials = _saunaStore.fetchCredentials;
    if (credentials == null) return;

    final path = systemSounds.firstWhereOrNull((element) => element.type == saunaSystemSoundType)?.path;

    final payload = MediaPlayer(
      id: systemPlayerIndex,
      playing: true,
      paused: false,
      filePath: path,
    );
    try {
      await _restAPIRepository.setMediaPlayerById(
        saunaId: credentials.item2,
        playerId: systemPlayerIndex.toString(),
        mediaPlayer: payload,
      );
      setBootUpFinished();
    } catch (error, stackTrace) {
      _logger.e('Error loading playSystemSound', error, stackTrace);
      setBootUpFinished();
    }
  }

  void setBootUpFinished() {
    if (_isBootUpFinished) return;
    _isBootUpFinished = true;
  }

  @action
  Future<void> playSessionStateSound({required SaunaState state}) async {
    final isSessionsSoundOn = _saunaLocalStorageStore.isSessionsSoundOn;

    switch (state) {
      case SaunaState.ready:
        if (isSessionsSoundOn) playSystemSound(saunaSystemSoundType: SaunaSystemSoundType.sessionReady);
        break;
      case SaunaState.insession:
        if (isSessionsSoundOn) playSystemSound(saunaSystemSoundType: SaunaSystemSoundType.sessionInsession);
        if (selectedSaunaAmbiences.isNotEmpty && !isAmbientSoundPlaying) {
          // TODO: SAUNA-625 (https://lx-group.atlassian.net/browse/SAUNA-625)
          Future.delayed(Duration(seconds: isSessionsSoundOn ? 5 : 1), () => playAllPlayers());
        }
        break;
      case SaunaState.done:
        if (isSessionsSoundOn) playSystemSound(saunaSystemSoundType: SaunaSystemSoundType.sessionDone);
        if (selectedSaunaAmbiences.isNotEmpty && isAmbientSoundPlaying) {
          Future.delayed(Duration(seconds: isSessionsSoundOn ? 5 : 1), () => pauseAllPlayers());
        }
        break;
      default:
    }
  }

  @action
  Future<void> _createPlaylistByPlayer() async {
    // System sounds
    await _deletedPlaylist(playerId: systemPlayerIndex);
    await playSystemSound(saunaSystemSoundType: SaunaSystemSoundType.startup);

    // Add ambient sounds
    for (final mediaPlayer in _ambientMediaPlayers) {
      await _deletedPlaylist(playerId: mediaPlayer.id ?? 0);
      await _createPlaylist(playerId: mediaPlayer.id ?? 0, ambiences: ambientSounds);
    }
  }

  @action
  Future<void> playAllPlayers() async {
    if (_ambientMediaPlayers.isEmpty || selectedSaunaAmbiences.isEmpty) return;
    if (isAmbientSoundPlaying) return;

    final maxIndex = _ambientMediaPlayers.length;

    for (var index = 0; index < selectedSaunaAmbiences.length; index++) {
      if (index > maxIndex) break; // Check if index exceeds the maximum available media players

      final ambience = selectedSaunaAmbiences[index];
      final mediaPlayer = _ambientMediaPlayers.firstWhereOrNull((element) => element.playlistPos == ambience.index);

      await setMediaPlayerById(
        playerId: mediaPlayer != null ? mediaPlayer.id ?? 0 : index,
        mediaPlayer: mediaPlayer ?? _ambientMediaPlayers[index],
        ambience: ambience,
        actionType: MediaPlayerAction.play,
      );
    }
  }

  @action
  Future<void> pauseAllPlayers({MediaPlayerAction actionType = MediaPlayerAction.pause}) async {
    if (_ambientMediaPlayers.isEmpty || selectedSaunaAmbiences.isEmpty) return;
    if (!isAmbientSoundPlaying) return;

    final maxIndex = _ambientMediaPlayers.length;

    for (var index = 0; index < selectedSaunaAmbiences.length; index++) {
      if (index > maxIndex) break; // Check if index exceeds the maximum available media players

      final ambience = selectedSaunaAmbiences[index];
      final mediaPlayer = _ambientMediaPlayers.firstWhereOrNull((element) => element.playlistPos == ambience.index);
      if (mediaPlayer != null) {
        await setMediaPlayerById(
          playerId: mediaPlayer.id ?? 0,
          mediaPlayer: mediaPlayer,
          ambience: ambience,
          actionType: actionType,
        );
      }
    }
  }

  Future<void> setMediaPlayerById({
    required int playerId,
    required MediaPlayer mediaPlayer,
    required Ambience ambience,
    required MediaPlayerAction actionType,
  }) async {
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      MediaPlayer payload;
      switch (actionType) {
        case MediaPlayerAction.play:
          payload = MediaPlayer(
            id: mediaPlayer.id,
            playing: true,
            paused: false,
            playlistPos: ambience.index,
            loopFile: 'inf',
          );
          break;
        case MediaPlayerAction.pause:
          payload = MediaPlayer(
            id: mediaPlayer.id,
            paused: true,
            playlistPos: ambience.index,
          );
          break;
        case MediaPlayerAction.volume:
          payload = MediaPlayer(
            id: mediaPlayer.id,
            playlistPos: ambience.index,
          );
          break;
        case MediaPlayerAction.stop:
          payload = MediaPlayer(
            id: mediaPlayer.id,
            playing: false,
            paused: false,
          );
          break;
      }

      final result = await _restAPIRepository.setMediaPlayerById(
        saunaId: credentials.item2,
        playerId: playerId.toString(),
        mediaPlayer: payload,
      );
      if (result != null) {
        _ambientMediaPlayers[playerId] = result;

        if (actionType == MediaPlayerAction.stop) {
          await _createPlaylist(playerId: mediaPlayer.id ?? 0, ambiences: ambientSounds);
        }
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading setMediaPlayerById', error, stackTrace);
    }
  }

  void _defaultSelectionOfAmbienceSounds() {
    final ambiences = _saunaStore.defaultSelectedAmbiences;
    if (ambiences == null || ambiences.isEmpty) return;

    for (final ambience in ambiences) {
      final selectedAmbience = ambientSounds.firstWhereOrNull((element) => element.type == ambience);
      if (selectedAmbience != null) {
        setSaunaAmbienceSelection(ambience: selectedAmbience);
      }
    }
  }

  @action
  Future<void> setSaunaAmbienceSelection({required Ambience ambience}) async {
    final selectedSaunaAmbienceTypes = selectedSaunaAmbiences.map((e) => e.type).toList();
    if (!selectedSaunaAmbienceTypes.contains(ambience.type) && selectedSaunaAmbiences.length >= 3) {
      return;
    }
    if (selectedSaunaAmbienceTypes.contains(ambience.type)) {
      selectedSaunaAmbiences.removeWhere((element) => element.type == ambience.type);
      _pauseOnDeselect(ambience: ambience);
    } else {
      selectedSaunaAmbiences.add(ambience);
      if (isAmbientSoundPlaying) {
        final player =
            _ambientMediaPlayers.firstWhereOrNull((player) => (player.paused == false && player.playing == false));
        if (player == null) return;
        final playerId = player.id ?? 0;
        await setMediaPlayerById(
          playerId: playerId,
          mediaPlayer: player,
          ambience: ambience,
          actionType: MediaPlayerAction.play,
        );
      }
    }
  }

  @action
  Future<void> _pauseOnDeselect({required Ambience ambience}) async {
    final selectedAmbienceIndex = ambience.index;
    final player = _ambientMediaPlayers.firstWhereOrNull((element) => element.playlistPos == selectedAmbienceIndex);
    if (player == null) return;
    final playerId = player.id ?? 0;
    await setMediaPlayerById(
      playerId: playerId,
      mediaPlayer: player,
      ambience: ambience,
      actionType: MediaPlayerAction.stop,
    );
  }

  void playButtonFeedbackSound() {
    final isSystemSoundOn = _saunaLocalStorageStore.isSystemSoundOn;
    if (!isSystemSoundOn) return;
    playSystemSound(saunaSystemSoundType: SaunaSystemSoundType.buttonFeedback);
  }
}

enum MediaPlayerAction { play, pause, volume, stop }
