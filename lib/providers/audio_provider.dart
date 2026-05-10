import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';
import '../services/audio/audio_handler.dart';

final audioHandlerProvider =
    Provider<HexAudioHandler>((ref) => throw UnimplementedError());

final currentSongProvider = StreamProvider<Song?>((ref) {
  return ref.watch(audioHandlerProvider).mediaItem.map((item) {
    if (item == null) return null;
    final e = item.extras ?? {};
    return Song(
      id: e['songId'] as String? ?? item.id,
      title: item.title,
      artist: item.artist ?? '',
      artistId: '',
      artworkUrl: item.artUri?.toString(),
      streamUrl: item.id,
      duration: item.duration ?? Duration.zero,
      source: SongSource.values.firstWhere(
        (x) => x.name == e['source'], orElse: () => SongSource.audius),
    );
  });
});

final playbackStateProvider = StreamProvider<PlaybackState>(
    (ref) => ref.watch(audioHandlerProvider).playbackState);

final isPlayingProvider = Provider<bool>((ref) =>
    ref.watch(playbackStateProvider).maybeWhen(
        data: (s) => s.playing, orElse: () => false));

final positionProvider = StreamProvider<Duration>(
    (ref) => ref.watch(audioHandlerProvider).player.positionStream);

final bufferedProvider = StreamProvider<Duration>(
    (ref) => ref.watch(audioHandlerProvider).player.bufferedPositionStream);

final queueProvider = Provider<List<Song>>(
    (ref) => ref.watch(audioHandlerProvider).songQueue);

// Loop Mode
class LoopModeNotifier extends StateNotifier<LoopMode> {
  final HexAudioHandler _h;
  LoopModeNotifier(this._h) : super(LoopMode.off);
  void toggle() {
    switch (state) {
      case LoopMode.off:
        state = LoopMode.all;
        _h.setRepeatMode(AudioServiceRepeatMode.all);
        break;
      case LoopMode.all:
        state = LoopMode.one;
        _h.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case LoopMode.one:
        state = LoopMode.off;
        _h.setRepeatMode(AudioServiceRepeatMode.none);
        break;
    }
  }
}
final loopModeProvider = StateNotifierProvider<LoopModeNotifier, LoopMode>(
    (ref) => LoopModeNotifier(ref.watch(audioHandlerProvider)));

// Shuffle Mode
class ShuffleModeNotifier extends StateNotifier<bool> {
  final HexAudioHandler _h;
  ShuffleModeNotifier(this._h) : super(false);
  void toggle() {
    state = !state;
    _h.setShuffleMode(
        state ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none);
  }
}
final shuffleModeProvider = StateNotifierProvider<ShuffleModeNotifier, bool>(
    (ref) => ShuffleModeNotifier(ref.watch(audioHandlerProvider)));
