import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/song.dart';

class HexAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  List<Song> _queue = [];
  int _idx = 0;
  bool _shuffle = false;
  LoopMode _loop = LoopMode.off;

  HexAudioHandler() { _listen(); }

  AudioPlayer get player       => _player;
  List<Song>  get songQueue    => List.unmodifiable(_queue);
  int         get currentIndex => _idx;
  bool        get isShuffled   => _shuffle;
  LoopMode    get loopMode     => _loop;

  Future<void> playSong(Song song, {List<Song>? queue, int? index}) async {
    if (queue != null) {
      _queue = List.from(queue);
      _idx = index ?? _queue.indexWhere((s) => s.id == song.id);
      if (_idx < 0) _idx = 0;
    } else if (!_queue.any((s) => s.id == song.id)) {
      _queue.insert(_idx + 1, song);
      _idx = _queue.indexWhere((s) => s.id == song.id);
    } else {
      _idx = _queue.indexWhere((s) => s.id == song.id);
    }

    final url = song.localPath ?? song.streamUrl;
    if (url == null || url.isEmpty) return;
    try {
      if (url.startsWith('/')) {
        await _player.setFilePath(url);
      } else {
        await _player.setAudioSource(AudioSource.uri(Uri.parse(url)), preload: true);
      }
      await _player.play();
      _updateMeta(song);
    } catch (_) {}
  }

  Future<void> playQueue(List<Song> songs, {int start = 0}) async {
    if (songs.isEmpty) return;
    await playSong(songs[start], queue: songs, index: start);
  }

  void addToQueue(Song s) => _queue.add(s);
  void addNext(Song s)    => _queue.insert(_idx + 1, s);

  @override Future<void> play()           => _player.play();
  @override Future<void> pause()          => _player.pause();
  @override Future<void> seek(Duration p) => _player.seek(p);
  @override Future<void> stop() async {
    await _player.stop();
    playbackState.add(playbackState.value.copyWith(
        processingState: AudioProcessingState.idle));
  }

  @override Future<void> skipToNext() async {
    if (_queue.isEmpty) return;
    if (_shuffle) {
      _idx = DateTime.now().millisecondsSinceEpoch % _queue.length;
    } else if (_idx < _queue.length - 1) {
      _idx++;
    } else if (_loop == LoopMode.all) {
      _idx = 0;
    } else { return; }
    await playSong(_queue[_idx]);
  }

  @override Future<void> skipToPrevious() async {
    if (_queue.isEmpty) return;
    if (_player.position.inSeconds > 3) {
      await seek(Duration.zero);
    } else if (_idx > 0) {
      _idx--;
      await playSong(_queue[_idx]);
    }
  }

  @override Future<void> setShuffleMode(AudioServiceShuffleMode m) async {
    _shuffle = m == AudioServiceShuffleMode.all;
    playbackState.add(playbackState.value.copyWith(shuffleMode: m));
  }

  @override Future<void> setRepeatMode(AudioServiceRepeatMode m) async {
    _loop = {
      AudioServiceRepeatMode.none: LoopMode.off,
      AudioServiceRepeatMode.one:  LoopMode.one,
      AudioServiceRepeatMode.all:  LoopMode.all,
    }[m] ?? LoopMode.off;
    await _player.setLoopMode(_loop);
    playbackState.add(playbackState.value.copyWith(repeatMode: m));
  }

  @override Future<void> customAction(String name, [Map<String, dynamic>? e]) async {
    if (name == 'setSleepTimer') {
      Future.delayed(Duration(minutes: e?['minutes'] as int? ?? 30), stop);
    }
  }

  void _listen() {
    _player.playbackEventStream.listen((_) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          playing ? MediaControl.pause : MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {MediaAction.seek, MediaAction.seekForward, MediaAction.seekBackward},
        androidCompactActionIndices: const [0, 1, 2],
        processingState: const {
          ProcessingState.idle:      AudioProcessingState.idle,
          ProcessingState.loading:   AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready:     AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      ));
    });
    _player.processingStateStream.listen((s) {
      if (s == ProcessingState.completed) skipToNext();
    });
  }

  void _updateMeta(Song s) {
    mediaItem.add(MediaItem(
      id: s.streamUrl ?? s.id, title: s.title,
      artist: s.artist, album: s.album, duration: s.duration,
      artUri: s.artworkUrl != null ? Uri.parse(s.artworkUrl!) : null,
      extras: {'songId': s.id, 'source': s.source.name},
    ));
  }
}
