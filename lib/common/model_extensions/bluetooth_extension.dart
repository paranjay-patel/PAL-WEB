import 'package:found_space_flutter_rest_api/models/models.dart';
import 'package:collection/collection.dart';
import 'package:found_space_flutter_web_application/common/utils.dart';

extension BluetoothExtension on Bluetooth {
  PairRequest? get deviceParingRequestInfo {
    final pairRequest = this.pairRequest ?? [];
    return pairRequest.isNotEmpty ? pairRequest.first : null;
  }

  String get deviceName {
    return deviceParingRequestInfo?.alias ?? "";
  }

  String get deviceParingCode {
    return deviceParingRequestInfo?.pairingCode ?? "";
  }

  String get deviceAddress {
    return deviceParingRequestInfo?.address ?? '';
  }

  bool get isBluetoothConnected {
    // check if bluetooth is enabled, if not return false
    if (!isBluetoothEnabled) return false;
    // check if bluetooth device is connected, if not return false
    final devices = this.device ?? [];
    final device = devices.firstWhereOrNull((device) => device.connected == true);
    return device != null;
  }

  bool get isBluetoothEnabled {
    return enabled ?? false;
  }

  Device? get connectedDevice {
    final devices = device ?? [];
    return devices.firstWhereOrNull((device) => device.connected == true);
  }

  bool get isBluetoothMediaAvailable {
    final data = connectedDevice?.media;
    return data != null && data.toJson().isNotEmpty;
  }

  bool get isBluetoothMediaStopped {
    return isBluetoothMediaAvailable && bluetoothMediaStatus == BluetoothMediaStatus.stopped;
  }

  DeviceMedia? get deviceMedia {
    return connectedDevice?.media;
  }

  BluetoothMediaStatus? get bluetoothMediaStatus {
    return deviceMedia?.status;
  }

  int get trackNumber {
    return deviceMedia?.track?.trackNumber ?? 0;
  }

  int get numberOfTracks {
    return deviceMedia?.track?.numberOfTracks ?? 0;
  }

  String get currentPosition {
    final position = deviceMedia?.position;
    if (position == null) return '0:00';

    final duration = Duration(milliseconds: position);
    return Utils.instance.durationFormatForPlayer(duration.inSeconds.toDouble());
  }

  String get currentDuration {
    final duration = deviceMedia?.track?.duration;
    if (duration == null) return '0:00';

    final totalDuration = Duration(milliseconds: duration);
    return Utils.instance.durationFormatForPlayer(totalDuration.inSeconds.toDouble());
  }

  double get position {
    return deviceMedia?.position?.toDouble() ?? 0;
  }

  double get duration {
    return deviceMedia?.track?.duration?.toDouble() ?? 0;
  }

  String get trackTitle {
    return deviceMedia?.track?.title ?? '';
  }

  String get trackArtist {
    return deviceMedia?.track?.artist ?? '';
  }

  String get trackAlbum {
    return deviceMedia?.track?.album ?? '';
  }

  String get trackGenre {
    return deviceMedia?.track?.genre ?? '';
  }
}
