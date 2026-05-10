import 'package:dio/dio.dart';
import '../../models/song.dart';

class JamendoService {
  static const _base = 'https://api.jamendo.com/v3.0';
  static const _cid  = 'b6747d04'; // Free client_id — replace with yours from developer.jamendo.com

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));

  Future<List<Song>> getTrending({int limit = 20}) async {
    try {
      final res = await _dio.get('\$_base/tracks', queryParameters: {
        'client_id': _cid, 'format': 'json', 'limit': limit,
        'order': 'popularity_week', 'audioformat': 'mp32',
      });
      return (res.data['results'] as List<dynamic>? ?? [])
          .map((j) => _songFromJson(j as Map<String, dynamic>)).toList();
    } catch (_) { return []; }
  }

  Future<List<Song>> searchTracks(String query, {int limit = 20}) async {
    try {
      final res = await _dio.get('\$_base/tracks', queryParameters: {
        'client_id': _cid, 'format': 'json', 'limit': limit,
        'namesearch': query, 'audioformat': 'mp32',
      });
      return (res.data['results'] as List<dynamic>? ?? [])
          .map((j) => _songFromJson(j as Map<String, dynamic>)).toList();
    } catch (_) { return []; }
  }

  Song _songFromJson(Map<String, dynamic> j) => Song(
    id: 'jamendo_\${j['id']}',
    title: j['name'] as String? ?? 'Unknown',
    artist: j['artist_name'] as String? ?? 'Unknown Artist',
    artistId: 'jamendo_\${j['artist_id']}',
    album: j['album_name'] as String?,
    albumId: 'jamendo_\${j['album_id']}',
    artworkUrl: j['album_image'] as String?,
    streamUrl: j['audio'] as String?,
    duration: Duration(seconds: int.tryParse(j['duration']?.toString() ?? '0') ?? 0),
    source: SongSource.jamendo,
  );
}
