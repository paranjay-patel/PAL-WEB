import 'package:found_space_flutter_rest_api/models/models.dart';

extension MediaPlayerExtension on MediaPlayer {
  MediaPlayer copyWith({
    int? id,
    String? loopFile,
    String? loopPlaylist,
    bool? mute,
    bool? paused,
    bool? playing,
    int? playlistCount,
    int? playlistPos,
    bool? shuffle,
    double? volume,
    String? filePath,
    int? cacheBufferingState,
    double? duration,
    double? timePos,
    double? timeRemaining,
  }) {
    return MediaPlayer(
      id: id ?? this.id,
      loopFile: loopFile ?? this.loopFile,
      loopPlaylist: loopPlaylist ?? this.loopPlaylist,
      mute: mute ?? this.mute,
      paused: paused ?? this.paused,
      playing: playing ?? this.playing,
      playlistCount: playlistCount ?? this.playlistCount,
      playlistPos: playlistPos ?? this.playlistPos,
      shuffle: shuffle ?? this.shuffle,
      volume: volume ?? this.volume,
      filePath: filePath ?? this.filePath,
      cacheBufferingState: cacheBufferingState ?? this.cacheBufferingState,
      duration: duration ?? this.duration,
      timePos: timePos ?? this.timePos,
      timeRemaining: timeRemaining ?? this.timeRemaining,
    );
  }
}
