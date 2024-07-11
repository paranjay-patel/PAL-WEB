import 'package:found_space_flutter_rest_api/found_space_flutter_rest_api.dart';
import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:found_space_flutter_web_application/common/composite_reaction_disposer.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/sauna_system_extension.dart';
import 'package:found_space_flutter_web_application/common/store/audio_player.store.dart';
import 'package:found_space_flutter_web_application/pages/sauna_bluetooth_page/sauna_bluetooth_page.dart';
import 'package:found_space_flutter_web_application/services/services.dart';
import 'package:found_space_flutter_web_application/common/model_extensions/bluetooth_extension.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'sauna.store.dart';

import 'package:found_space_flutter_web_application/common/mobx_provider.dart';

part 'sauna_bluetooth_store.g.dart';

class SaunaBluetoothStore = _SaunaBluetoothStoreBase with _$SaunaBluetoothStore;

abstract class _SaunaBluetoothStoreBase with Store, Disposable {
  _SaunaBluetoothStoreBase() {
    _setupListener();
  }

  final _compositeReaction = CompositeReactionDisposer();
  final _restAPIRepository = locator<RestAPIRepository>();
  final _saunaStore = locator<SaunaStore>();
  final _logger = locator<Logger>();

  @computed
  BluetoothState get bluetoothState => _saunaStore.saunaSystem?.bluetoothState ?? BluetoothState.disabled;

  @computed
  String get bluetoothName => _saunaStore.saunaSystem?.connectedDeviceName ?? '';

  @computed
  String get bluetoothAdvertiserName => _saunaStore.saunaSystem?.advertiserName ?? '';

  @readonly
  bool _isBluetoothEnableDisableLoading = false;

  @computed
  Bluetooth? get bluetooth => _saunaStore.saunaSystem?.bluetooth;

  @readonly
  BluetoothParingState? _bluetoothParingState = BluetoothParingState.none;

  @computed
  bool get isBluetoothConnected => bluetooth?.isBluetoothConnected ?? false;

  @computed
  bool get isMusicPlaying => isBluetoothMediaAvailable && bluetoothMediaStatus == BluetoothMediaStatus.playing;

  @computed
  bool get isAmbientSoundPlaying => _saunaStore.saunaSystem?.isMediaPlayerPlaying ?? false;

  @computed
  bool get isAudioPlaying => isAmbientSoundPlaying || isMusicPlaying;

  @computed
  bool get isBluetoothMediaAvailable => bluetooth?.isBluetoothMediaAvailable ?? false;

  @computed
  bool get isBluetoothMediaStopped => bluetooth?.isBluetoothMediaStopped ?? false;

  @computed
  BluetoothMediaStatus get bluetoothMediaStatus => bluetooth?.bluetoothMediaStatus ?? BluetoothMediaStatus.unknown;

  @computed
  double get position => bluetooth?.position ?? 0.0;

  @computed
  double get duration => bluetooth?.duration ?? 0.0;

  @computed
  String get currentDuration => bluetooth?.currentDuration ?? '-';

  @computed
  String get currentPosition => bluetooth?.currentPosition ?? '-';

  @computed
  int get trackNumber => bluetooth?.trackNumber ?? 0;

  @computed
  int get numberOfTracks => bluetooth?.numberOfTracks ?? 0;

  @computed
  String get trackTitle => bluetooth?.trackTitle ?? '';

  @computed
  String get trackArtist => bluetooth?.trackArtist ?? '';

  @computed
  String get trackAlbum => bluetooth?.trackAlbum ?? '';

  @computed
  String get trackGenre => bluetooth?.trackGenre ?? '';

  @computed
  bool get canGoToPreviousTrack => trackNumber > 1;

  @computed
  bool get canGoToNextTrack => trackNumber < numberOfTracks;

  @readonly
  bool _isAudioBuffering = false;

  void _setupListener() {
    reaction((_) => isAmbientSoundPlaying, (bool isPlaying) {
      if (isPlaying && isBluetoothConnected) {
        setBluetoothMediaStatus(action: BluetoothMediaAction.pause);
      }
    }).disposeWith(_compositeReaction);

    reaction((_) => isMusicPlaying, (bool isPlaying) {
      if (isPlaying && isBluetoothConnected) {
        locator<AudioPlayerStore>().pauseAllPlayers();
      }
    }).disposeWith(_compositeReaction);

    reaction((_) => _saunaStore.saunaSystem, (SaunaSystem? system) {
      final isAttemptToConnectBluetooth = system?.isAttemptToConnectBluetooth ?? false;
      if (isAttemptToConnectBluetooth && _bluetoothParingState != BluetoothParingState.attemptParing) {
        _bluetoothParingState = BluetoothParingState.attemptParing;
      } else if (!isAttemptToConnectBluetooth && _bluetoothParingState != BluetoothParingState.none) {
        _bluetoothParingState = BluetoothParingState.none;
      }
    }).disposeWith(_compositeReaction);
  }

  @action
  Future<void> paidOrRejectBluetooth({required bool acceptPairing, required String address}) async {
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      if (!acceptPairing) {
        _bluetoothParingState = BluetoothParingState.failed;
      }

      final payload = _saunaStore.saunaSystem?.prepareBluetoothPayload(accept: acceptPairing, address: address);
      if (payload == null) {
        _bluetoothParingState = BluetoothParingState.failed;
        return;
      }

      final bluetooth = await _restAPIRepository.setBluetooth(
        bluetooth: payload,
        saunaId: credentials.item2,
      );

      if (bluetooth == null) {
        _bluetoothParingState = BluetoothParingState.failed;
        return;
      }
      if (acceptPairing) {
        _bluetoothParingState =
            bluetooth.isBluetoothConnected ? BluetoothParingState.paired : BluetoothParingState.failed;
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading paidOrRejectBluetooth', error, stackTrace);
      _bluetoothParingState = BluetoothParingState.failed;
    }
  }

  @action
  Future<void> enableDisabledBluetooth() async {
    try {
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      _isBluetoothEnableDisableLoading = true;

      var enabled = false;
      switch (bluetoothState) {
        case BluetoothState.enabled:
        case BluetoothState.connected:
          enabled = false;
          break;
        case BluetoothState.disabled:
          enabled = true;
          break;
      }

      final payload = _saunaStore.saunaSystem?.enabledDisableBluetoothPayload(shouldEnable: enabled);
      if (payload == null) {
        return;
      }

      await _restAPIRepository.setBluetooth(
        bluetooth: payload,
        saunaId: credentials.item2,
      );
      _isBluetoothEnableDisableLoading = false;
    } catch (error, stackTrace) {
      _isBluetoothEnableDisableLoading = false;
      _logger.e('Error loading enableDisabledBluetooth', error, stackTrace);
    }
  }

  @action
  Future<void> setBluetoothMediaStatus({required BluetoothMediaAction action}) async {
    try {
      if (action == BluetoothMediaAction.play) {
        _isAudioBuffering = true;
      }
      final credentials = _saunaStore.fetchCredentials;
      if (credentials == null) return;

      final payload = _saunaStore.saunaSystem?.prepareBluetoothMediaPayload(action: action);
      if (payload == null) return;

      await _restAPIRepository.setBluetooth(
        bluetooth: payload,
        saunaId: credentials.item2,
      );
      if (_isAudioBuffering) {
        _isAudioBuffering = false;
      }
    } catch (error, stackTrace) {
      _logger.e('Error loading setBluetoothMediaStatus', error, stackTrace);
    }
  }
}
