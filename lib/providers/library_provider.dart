import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/playlist.dart';
import '../models/song.dart';

const _uuid = Uuid();

// ── Playlists ──────────────────────────────────────────────────────────────

class PlaylistsNotifier extends StateNotifier<AsyncValue<List<Playlist>>> {
  PlaylistsNotifier() : super(const AsyncValue.loading()) { _load(); }

  void _load() {
    try {
      final raw = (Hive.box('playlists').get('all') as List<dynamic>?) ?? [];
      state = AsyncValue.data(raw
          .map((m) => Playlist.fromMap(Map<String, dynamic>.from(m as Map)))
          .toList().cast<Playlist>());
    } catch (e, st) { state = AsyncValue.error(e, st); }
  }

  Future<void> _save(List<Playlist> p) async =>
      Hive.box('playlists').put('all', p.map((x) => x.toMap()).toList());

  Future<void> createPlaylist(String name) async {
    final cur = state.value ?? [];
    final p = Playlist(id: _uuid.v4(), name: name,
        songs: [], createdAt: DateTime.now());
    final upd = [...cur, p];
    state = AsyncValue.data(upd);
    await _save(upd);
  }

  Future<void> deletePlaylist(String id) async {
    final upd = (state.value ?? []).where((p) => p.id != id).toList();
    state = AsyncValue.data(upd);
    await _save(upd);
  }

  Future<void> addSong(String playlistId, Song song) async {
    final upd = (state.value ?? []).map((p) {
      if (p.id != playlistId || p.songs.any((s) => s.id == song.id)) return p;
      return p.copyWith(songs: [...p.songs, song]);
    }).toList();
    state = AsyncValue.data(upd);
    await _save(upd);
  }

  Future<void> removeSong(String playlistId, String songId) async {
    final upd = (state.value ?? []).map((p) {
      if (p.id != playlistId) return p;
      return p.copyWith(songs: p.songs.where((s) => s.id != songId).toList());
    }).toList();
    state = AsyncValue.data(upd);
    await _save(upd);
  }
}

final playlistsProvider =
    StateNotifierProvider<PlaylistsNotifier, AsyncValue<List<Playlist>>>(
  (ref) => PlaylistsNotifier());

// ── Liked songs ────────────────────────────────────────────────────────────

class LikedSongsNotifier extends StateNotifier<List<Song>> {
  LikedSongsNotifier() : super([]) { _load(); }

  void _load() {
    try {
      final raw = (Hive.box('liked_songs').get('songs')
          as List<dynamic>?) ?? [];
      state = raw.map((m) => Song.fromMap(
          Map<String, dynamic>.from(m as Map))).toList().cast<Song>();
    } catch (_) {}
  }

  Future<void> toggle(Song song) async {
    state = state.any((s) => s.id == song.id)
        ? state.where((s) => s.id != song.id).toList()
        : [...state, song];
    await Hive.box('liked_songs')
        .put('songs', state.map((s) => s.toMap()).toList());
  }

  bool isLiked(String id) => state.any((s) => s.id == id);
}

final likedSongsProvider =
    StateNotifierProvider<LikedSongsNotifier, List<Song>>(
  (ref) => LikedSongsNotifier());
