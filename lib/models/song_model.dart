import 'package:audio_service/audio_service.dart';

enum SongSource { audius, jamendo, local }

class SongModel {
  const SongModel({
    required this.id,
    required this.title,
    required this.artistName,
    required this.streamUrl,
    required this.duration,
    required this.source,
    this.artistId,
    this.albumName,
    this.albumId,
    this.artworkUrl,
    this.localPath,
    this.isLiked      = false,
    this.isDownloaded = false,
    this.playCount    = 0,
  });

  final String     id;
  final String     title;
  final String     artistName;
  final String?    artistId;
  final String?    albumName;
  final String?    albumId;
  final String     streamUrl;
  final String?    artworkUrl;
  final Duration   duration;
  final SongSource source;
  final String?    localPath;
  final bool       isLiked;
  final bool       isDownloaded;
  final int        playCount;

  MediaItem toMediaItem() => MediaItem(
    id:       streamUrl,
    title:    title,
    artist:   artistName,
    album:    albumName,
    artUri:   artworkUrl != null ? Uri.tryParse(artworkUrl!) : null,
    duration: duration,
    extras:   {'songId': id, 'source': source.name, 'artistId': artistId},
  );

  factory SongModel.fromAudiusJson(Map<String, dynamic> j) {
    final user = (j['user'] as Map<String, dynamic>?) ?? {};
    final art  = j['artwork'] as Map<String, dynamic>?;
    final secs = (j['duration'] as num?)?.toInt() ?? 0;
    return SongModel(
      id:         j['id']?.toString() ?? '',
      title:      j['title']?.toString() ?? 'Unknown',
      artistName: user['name']?.toString() ?? 'Unknown Artist',
      artistId:   user['id']?.toString(),
      streamUrl:  'https://api.audius.co/v1/tracks/${j['id']}/stream?app_name=HexTunes',
      artworkUrl: art?['480x480']?.toString(),
      duration:   Duration(seconds: secs),
      source:     SongSource.audius,
    );
  }

  factory SongModel.fromJamendoJson(Map<String, dynamic> j) {
    final secs = (j['duration'] as num?)?.toInt() ?? 0;
    return SongModel(
      id:         j['id']?.toString() ?? '',
      title:      j['name']?.toString() ?? 'Unknown',
      artistName: j['artist_name']?.toString() ?? 'Unknown Artist',
      artistId:   j['artist_id']?.toString(),
      albumName:  j['album_name']?.toString(),
      albumId:    j['album_id']?.toString(),
      streamUrl:  j['audio']?.toString() ?? '',
      artworkUrl: j['album_image']?.toString(),
      duration:   Duration(seconds: secs),
      source:     SongSource.jamendo,
    );
  }

  SongModel copyWith({
    String? id, String? title, String? artistName, String? artistId,
    String? albumName, String? albumId, String? streamUrl, String? artworkUrl,
    Duration? duration, SongSource? source, String? localPath,
    bool? isLiked, bool? isDownloaded, int? playCount,
  }) => SongModel(
    id:           id           ?? this.id,
    title:        title        ?? this.title,
    artistName:   artistName   ?? this.artistName,
    artistId:     artistId     ?? this.artistId,
    albumName:    albumName    ?? this.albumName,
    albumId:      albumId      ?? this.albumId,
    streamUrl:    streamUrl    ?? this.streamUrl,
    artworkUrl:   artworkUrl   ?? this.artworkUrl,
    duration:     duration     ?? this.duration,
    source:       source       ?? this.source,
    localPath:    localPath    ?? this.localPath,
    isLiked:      isLiked      ?? this.isLiked,
    isDownloaded: isDownloaded ?? this.isDownloaded,
    playCount:    playCount    ?? this.playCount,
  );

  @override bool operator ==(Object o) => identical(this, o) || o is SongModel && id == o.id;
  @override int  get hashCode => id.hashCode;
  @override String toString() => 'SongModel(id: $id, title: $title)';
}
