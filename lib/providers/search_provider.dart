import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/song.dart';
import '../models/artist.dart';
import '../services/api/audius_service.dart';
import 'home_provider.dart';

class SearchState {
  final String       query;
  final List<Song>   songs;
  final List<Artist> artists;
  final bool         isLoading;
  final String?      error;

  const SearchState({
    this.query     = '',
    this.songs     = const [],
    this.artists   = const [],
    this.isLoading = false,
    this.error,
  });

  SearchState copyWith({
    String?       query,
    List<Song>?   songs,
    List<Artist>? artists,
    bool?         isLoading,
    String?       error,
  }) =>
      SearchState(
        query:     query     ?? this.query,
        songs:     songs     ?? this.songs,
        artists:   artists   ?? this.artists,
        isLoading: isLoading ?? this.isLoading,
        error:     error,
      );
}

class SearchNotifier extends StateNotifier<SearchState> {
  final AudiusService _audius;
  SearchNotifier(this._audius) : super(const SearchState());

  Future<void> search(String q) async {
    if (q.trim().isEmpty) { state = const SearchState(); return; }
    state = state.copyWith(query: q, isLoading: true);
    try {
      final songs   = await _audius.searchTracks(q, limit: 20);
      final artists = await _audius.searchArtists(q, limit: 5);
      state = state.copyWith(
          songs: songs, artists: artists, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clear() => state = const SearchState();
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>(
  (ref) => SearchNotifier(ref.watch(audiusServiceProvider)));
