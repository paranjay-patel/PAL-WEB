import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:collection/collection.dart';

enum BluetoothState { enabled, disabled, connected }

extension SaunaSystemExtension on SaunaSystem {
  String get firmwareVersionCode {
    return firmwareVersion ?? '-';
  }

  bool get isCloudConnected {
    return cloudConnected ?? false;
  }

// 3 is the index of the media player that is used for the sauna system
  bool get isMediaPlayerPlaying {
    int currentIndex = 0;
    final player = mediaPlayer?.firstWhereOrNull((player) {
      final isPlaying = player.playing == true && player.paused == false;
      final ignoreIndex = currentIndex == 3;
      currentIndex++;
      return isPlaying && !ignoreIndex;
    });
    return player != null;
  }

  int get brightness {
    return screenBrightness ?? 10;
  }

  int get saunaVolume {
    return volume ?? 0;
  }

  bool get hasBluetoothInfo {
    final bluetooth = this.bluetooth;
    if (bluetooth == null) return false;
    final hasInfo = bluetooth.toJson();
    return hasInfo.isNotEmpty;
  }

  bool get isAttemptToConnectBluetooth {
    // check if bluetooth is connected, if not return false
    if (!isBluetoothEnabled) return false;

    // check if bluetooth device is in pairing mode, if not return false
    final pairRequest = bluetooth?.pairRequest ?? [];
    if (pairRequest.isEmpty) return false;

    // check if bluetooth device has pairing code, if return true
    final paringDevice = pairRequest.first;
    return paringDevice.pairingCode != null;
  }

  bool get isBluetoothConnected {
    // check if bluetooth is enabled, if not return false
    if (!isBluetoothEnabled) return false;
    // check if bluetooth device is connected, if not return false
    final devices = bluetooth?.device ?? [];
    final device = devices.firstWhereOrNull((device) => device.connected == true);
    return device != null;
  }

  BluetoothState get bluetoothState {
    final isEnabled = isBluetoothEnabled;
    final isConnected = isBluetoothConnected;
    if (isEnabled && isConnected) {
      return BluetoothState.connected;
    } else if (isEnabled && !isConnected) {
      return BluetoothState.enabled;
    } else {
      return BluetoothState.disabled;
    }
  }

  PairRequest get deviceParingRequestInfo {
    final pairRequest = bluetooth?.pairRequest ?? [];
    return pairRequest.first;
  }

  String get connectedDeviceName {
    final device = bluetooth?.device?.firstWhereOrNull((device) => device.connected == true);
    return device?.alias ?? "";
  }

  String get advertiserName {
    return bluetooth?.alias ?? '';
  }

  bool get isBluetoothEnabled {
    return bluetooth?.enabled ?? false;
  }

  Bluetooth prepareBluetoothPayload({required String address, required bool accept}) {
    final pairRequest = PairRequest(address: address, accept: accept);
    final devices = bluetooth?.device ?? [];
    final device = devices.firstWhereOrNull((device) => device.address == address);
    List<Device> paringDevice = device == null ? [] : [device];
    return Bluetooth(enabled: bluetooth?.enabled, device: paringDevice, pairRequest: [pairRequest]);
  }

  Bluetooth enabledDisableBluetoothPayload({required bool shouldEnable}) {
    return Bluetooth(enabled: shouldEnable, device: bluetooth?.device, pairRequest: bluetooth?.pairRequest);
  }

  Bluetooth prepareBluetoothMediaPayload({required BluetoothMediaAction action}) {
    final devices = bluetooth?.device ?? [];
    final device = devices.firstWhereOrNull((device) => device.connected == true);
    final media = device?.media;
    final deviceConnected = Device(
      address: device?.address,
      alias: device?.alias,
      connected: device?.connected,
      media: DeviceMedia(
        action: action,
        status: media?.status,
        position: media?.position,
        track: media?.track,
      ),
    );
    devices.removeWhere((device) => device.address == deviceConnected.address);
    devices.add(deviceConnected);
    return Bluetooth(enabled: bluetooth?.enabled, device: devices, pairRequest: bluetooth?.pairRequest);
  }

  String? get pendingFirmwareVersion => firmware?.pendingUpdate?.firmwareVersion;

  bool? get isForceUpdate {
    if (pendingFirmwareVersion == null) return null;
    return firmware?.pendingUpdate?.mandatory;
  }

  SaunaUpdateState? get saunaUpdateState => firmware?.state;

  List<String> get pendingUpdateReleaseNotes => firmware?.pendingUpdate?.releaseNotes ?? [];
}
