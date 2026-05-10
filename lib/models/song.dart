import 'package:equatable/equatable.dart';
enum SongSource { audius, jamendo, local }

class Song extends Equatable {
  final String id; final String title; final String artist; final String artistId;
  final String? album; final String? albumId; final String? artworkUrl;
  final String? streamUrl; final Duration duration; final SongSource source;
  final int? playCount; final String? genre;
  final bool isLiked; final bool isDownloaded; final String? localPath;

  const Song({
    required this.id, required this.title,
    required this.artist, required this.artistId,
    this.album, this.albumId, this.artworkUrl, this.streamUrl,
    required this.duration, required this.source,
    this.playCount, this.genre,
    this.isLiked = false, this.isDownloaded = false, this.localPath,
  });

  Song copyWith({
    String? id, String? title, String? artist, String? artistId,
    String? album, String? albumId, String? artworkUrl, String? streamUrl,
    Duration? duration, SongSource? source, int? playCount, String? genre,
    bool? isLiked, bool? isDownloaded, String? localPath,
  }) => Song(
    id: id ?? this.id, title: title ?? this.title,
    artist: artist ?? this.artist, artistId: artistId ?? this.artistId,
    album: album ?? this.album, albumId: albumId ?? this.albumId,
    artworkUrl: artworkUrl ?? this.artworkUrl, streamUrl: streamUrl ?? this.streamUrl,
    duration: duration ?? this.duration, source: source ?? this.source,
    playCount: playCount ?? this.playCount, genre: genre ?? this.genre,
    isLiked: isLiked ?? this.isLiked, isDownloaded: isDownloaded ?? this.isDownloaded,
    localPath: localPath ?? this.localPath,
  );

  Map<String, dynamic> toMap() => {
    'id': id, 'title': title, 'artist': artist, 'artistId': artistId,
    'album': album, 'albumId': albumId, 'artworkUrl': artworkUrl,
    'streamUrl': streamUrl, 'durationMs': duration.inMilliseconds,
    'source': source.name, 'playCount': playCount, 'genre': genre,
    'isLiked': isLiked, 'isDownloaded': isDownloaded, 'localPath': localPath,
  };

  factory Song.fromMap(Map<String, dynamic> m) => Song(
    id: m['id'] as String, title: m['title'] as String,
    artist: m['artist'] as String, artistId: m['artistId'] as String,
    album: m['album'] as String?, albumId: m['albumId'] as String?,
    artworkUrl: m['artworkUrl'] as String?, streamUrl: m['streamUrl'] as String?,
    duration: Duration(milliseconds: (m['durationMs'] as int?) ?? 0),
    source: SongSource.values.firstWhere(
      (e) => e.name == m['source'], orElse: () => SongSource.audius),
    playCount: m['playCount'] as int?, genre: m['genre'] as String?,
    isLiked: m['isLiked'] as bool? ?? false,
    isDownloaded: m['isDownloaded'] as bool? ?? false,
    localPath: m['localPath'] as String?,
  );

  @override List<Object?> get props => [id, source];
}
