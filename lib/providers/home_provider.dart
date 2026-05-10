import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/song.dart';
import '../services/api/audius_service.dart';
import '../services/api/jamendo_service.dart';

final audiusServiceProvider  = Provider((ref) => AudiusService());
final jamendoServiceProvider = Provider((ref) => JamendoService());

final trendingProvider = FutureProvider<List<Song>>((ref) async {
  try {
    final songs = await ref.watch(audiusServiceProvider).getTrending(limit: 20);
    if (songs.isNotEmpty) return songs;
  } catch (_) {}
  return ref.watch(jamendoServiceProvider).getTrending(limit: 20);
});

final newReleasesProvider = FutureProvider<List<Song>>(
    (ref) => ref.watch(jamendoServiceProvider).getTrending(limit: 10));

final recentlyPlayedProvider = FutureProvider<List<Song>>((ref) async {
  try {
    final raw = (Hive.box('recent_songs').get('songs') as List<dynamic>?) ?? [];
    return raw.cast<Map<dynamic, dynamic>>()
        .map((m) => Song.fromMap(m.cast<String, dynamic>()))
        .toList().reversed.take(20).toList();
  } catch (_) { return []; }
});

Future<void> addToRecent(Song song) async {
  final box = Hive.box('recent_songs');
  final raw = List<Map<dynamic, dynamic>>.from(
      (box.get('songs') as List<dynamic>?) ?? []);
  raw.removeWhere((m) => m['id'] == song.id);
  raw.add(song.toMap());
  if (raw.length > 50) raw.removeAt(0);
  await box.put('songs', raw);
}
