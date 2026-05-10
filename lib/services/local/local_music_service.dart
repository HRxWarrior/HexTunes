import 'package:on_audio_query/on_audio_query.dart';
import '../../models/song_model.dart';

class LocalMusicService {
  final OnAudioQuery _query = OnAudioQuery();

  Future<bool> requestPermission() => _query.permissionsRequest();

  Future<List<SongModel>> fetchLocalSongs() async {
    try {
      final songs = await _query.querySongs(
        sortType:   SongSortType.TITLE,
        orderType:  OrderType.ASC_OR_SMALLER,
        uriType:    UriType.EXTERNAL,
        ignoreCase: true,
      );
      return songs
          .where((s) => s.isMusic == true && (s.duration ?? 0) > 10000)
          .map(_mapSong)
          .toList();
    } catch (_) { return []; }
  }

  SongModel _mapSong(SongInfo s) => SongModel(
    id:         's_${s.id}',
    title:      s.title ?? 'Unknown',
    artistName: s.artist ?? 'Unknown Artist',
    albumName:  s.album,
    streamUrl:  s.uri ?? '',
    artworkUrl: null,
    duration:   Duration(milliseconds: s.duration ?? 0),
    source:     SongSource.local,
    localPath:  s.data,
  );
}
