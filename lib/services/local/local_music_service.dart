// Local music scanning is temporarily disabled.
// on_audio_query (^2.9.0) is incompatible with AGP 8.3.0 (missing namespace).
// Audius (primary) and Jamendo (backup) still stream music fully.
// Local scanning will be re-enabled once the package is updated.
//
// To re-enable: add `on_audio_query: ^2.9.0` back to pubspec.yaml once
// the package publishes an AGP 8.x compatible release.

import '../../../models/song.dart';

class LocalMusicService {
  Future<bool> requestPermission() async => false;

  /// Returns an empty list — local scanning is pending package compatibility.
  Future<List<Song>> fetchLocalSongs() async => [];
}
