import 'package:dio/dio.dart';
import '../../models/song.dart';
import '../../models/artist.dart';

class AudiusService {
  late final Dio _dio;
  String _host = 'https://discoveryprovider.audius.co';
  static const _hosts = [
    'https://discoveryprovider.audius.co',
    'https://discoveryprovider2.audius.co',
    'https://discoveryprovider3.audius.co',
  ];

  AudiusService() {
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'User-Agent': 'HexTunes/1.0.0'},
    ));
  }

  String get _base => '\$_host/v1';

  Future<List<Song>> getTrending({int limit = 20}) async {
    for (final host in _hosts) {
      try {
        _host = host;
        final res = await _dio.get('\$_base/tracks/trending',
            queryParameters: {'limit': limit, 'app_name': 'HexTunes'});
        final data = res.data['data'] as List<dynamic>? ?? [];
        return data.map((j) => _songFromJson(j as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    return [];
  }

  Future<List<Song>> searchTracks(String query, {int limit = 20}) async {
    try {
      final res = await _dio.get('\$_base/tracks/search',
          queryParameters: {'query': query, 'limit': limit, 'app_name': 'HexTunes'});
      final data = res.data['data'] as List<dynamic>? ?? [];
      return data.map((j) => _songFromJson(j as Map<String, dynamic>)).toList();
    } catch (_) { return []; }
  }

  Future<List<Artist>> searchArtists(String query, {int limit = 8}) async {
    try {
      final res = await _dio.get('\$_base/users/search',
          queryParameters: {'query': query, 'limit': limit, 'app_name': 'HexTunes'});
      final data = res.data['data'] as List<dynamic>? ?? [];
      return data.map((j) => Artist.fromAudiusJson(j as Map<String, dynamic>)).toList();
    } catch (_) { return []; }
  }

  Future<List<Song>> getArtistTracks(String uid, {int limit = 20}) async {
    try {
      final res = await _dio.get('\$_base/users/\$uid/tracks',
          queryParameters: {'limit': limit, 'app_name': 'HexTunes'});
      final data = res.data['data'] as List<dynamic>? ?? [];
      return data.map((j) => _songFromJson(j as Map<String, dynamic>)).toList();
    } catch (_) { return []; }
  }

  String getStreamUrl(String id) =>
      '\$_base/tracks/\$id/stream?app_name=HexTunes';

  Song _songFromJson(Map<String, dynamic> j) {
    final user = (j['user'] as Map<String, dynamic>?) ?? {};
    final art  = (j['artwork'] as Map<String, dynamic>?) ?? {};
    final id   = j['id'] as String? ?? '';
    return Song(
      id: id,
      title: j['title'] as String? ?? 'Unknown',
      artist: user['name'] as String? ?? 'Unknown Artist',
      artistId: user['id'] as String? ?? '',
      album: (j['album'] as Map<String, dynamic>?)?['playlist_name'] as String?,
      albumId: (j['album'] as Map<String, dynamic>?)?['id'] as String?,
      artworkUrl: art['480x480'] as String?,
      streamUrl: '\$_base/tracks/\$id/stream?app_name=HexTunes',
      duration: Duration(seconds: (j['duration'] as num?)?.toInt() ?? 0),
      source: SongSource.audius,
      playCount: j['play_count'] as int?,
      genre: j['genre'] as String?,
    );
  }
}
