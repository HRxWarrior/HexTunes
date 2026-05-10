import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/song.dart';
import '../models/playlist.dart';

const _uuid = Uuid();

class LikedSongsNotifier extends StateNotifier<List<Song>> {
  LikedSongsNotifier() : super([]) { _load(); }
  void _load() {
    final raw = (Hive.box('liked_songs').get('songs') as List<dynamic>?) ?? [];
    state = raw.cast<Map<dynamic, dynamic>>()
        .map((m) => Song.fromMap(m.cast<String, dynamic>())).toList();
  }
  Future<void> toggle(Song s) async {
    state = state.any((x) => x.id == s.id)
        ? state.where((x) => x.id != s.id).toList()
        : [...state, s.copyWith(isLiked: true)];
    await Hive.box('liked_songs').put('songs', state.map((x) => x.toMap()).toList());
  }
  bool isLiked(String id) => state.any((s) => s.id == id);
}
final likedSongsProvider = StateNotifierProvider<LikedSongsNotifier, List<Song>>(
    (ref) => LikedSongsNotifier());

class PlaylistsNotifier extends StateNotifier<List<Playlist>> {
  PlaylistsNotifier() : super([]) { _load(); }
  void _load() {
    final raw = (Hive.box('playlists').get('data') as List<dynamic>?) ?? [];
    state = raw.cast<Map<dynamic, dynamic>>()
        .map((m) => Playlist.fromMap(m.cast<String, dynamic>())).toList();
  }
  Future<Playlist> create(String name) async {
    final p = Playlist(id: _uuid.v4(), name: name, createdAt: DateTime.now());
    state = [...state, p]; await _save(); return p;
  }
  Future<void> delete(String id) async {
    state = state.where((p) => p.id != id).toList(); await _save();
  }
  Future<void> addSong(String pid, Song s) async {
    state = state.map((p) => p.id == pid && !p.songs.any((x) => x.id == s.id)
        ? p.copyWith(songs: [...p.songs, s]) : p).toList();
    await _save();
  }
  Future<void> removeSong(String pid, String sid) async {
    state = state.map((p) => p.id == pid
        ? p.copyWith(songs: p.songs.where((s) => s.id != sid).toList()) : p).toList();
    await _save();
  }
  Future<void> _save() async =>
      Hive.box('playlists').put('data', state.map((p) => p.toMap()).toList());
}
final playlistsProvider = StateNotifierProvider<PlaylistsNotifier, List<Playlist>>(
    (ref) => PlaylistsNotifier());
