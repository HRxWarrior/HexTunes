import 'song_model.dart';

class PlaylistModel {
  PlaylistModel({
    required this.id,
    required this.name,
    this.description,
    this.coverArtUrl,
    this.songs          = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isUserCreated  = true,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  final String  id;
  String        name;
  String?       description;
  String?       coverArtUrl;
  List<SongModel> songs;
  final DateTime  createdAt;
  DateTime        updatedAt;
  final bool      isUserCreated;

  int      get trackCount    => songs.length;
  Duration get totalDuration => songs.fold(Duration.zero, (acc, s) => acc + s.duration);

  Map<String, dynamic> toMap() => {
    'id':           id,
    'name':         name,
    'description':  description,
    'coverArtUrl':  coverArtUrl,
    'createdAt':    createdAt.toIso8601String(),
    'updatedAt':    updatedAt.toIso8601String(),
    'isUserCreated':isUserCreated,
    'songs':        songs.map(_songToMap).toList(),
  };

  factory PlaylistModel.fromMap(Map<dynamic, dynamic> m) {
    final sl = (m['songs'] as List<dynamic>?)
        ?.map((s) => _songFromMap(Map<String, dynamic>.from(s as Map)))
        .toList() ?? [];
    return PlaylistModel(
      id:            m['id']?.toString() ?? '',
      name:          m['name']?.toString() ?? 'Playlist',
      description:   m['description']?.toString(),
      coverArtUrl:   m['coverArtUrl']?.toString(),
      createdAt:     DateTime.tryParse(m['createdAt']?.toString() ?? ''),
      updatedAt:     DateTime.tryParse(m['updatedAt']?.toString() ?? ''),
      isUserCreated: m['isUserCreated'] as bool? ?? true,
      songs:         sl,
    );
  }

  PlaylistModel copyWith({
    String? name, String? description, String? coverArtUrl, List<SongModel>? songs,
  }) => PlaylistModel(
    id:           id,
    name:         name         ?? this.name,
    description:  description  ?? this.description,
    coverArtUrl:  coverArtUrl  ?? this.coverArtUrl,
    songs:        songs        ?? this.songs,
    createdAt:    createdAt,
    updatedAt:    DateTime.now(),
    isUserCreated: isUserCreated,
  );

  @override bool operator ==(Object o) => identical(this, o) || o is PlaylistModel && id == o.id;
  @override int  get hashCode => id.hashCode;
}

Map<String, dynamic> _songToMap(SongModel s) => {
  'id': s.id, 'title': s.title, 'artistName': s.artistName,
  'artistId': s.artistId, 'albumName': s.albumName, 'albumId': s.albumId,
  'streamUrl': s.streamUrl, 'artworkUrl': s.artworkUrl,
  'durationMs': s.duration.inMilliseconds, 'source': s.source.name,
  'localPath': s.localPath, 'isLiked': s.isLiked,
  'isDownloaded': s.isDownloaded, 'playCount': s.playCount,
};

SongModel _songFromMap(Map<String, dynamic> m) => SongModel(
  id:          m['id']?.toString() ?? '',
  title:       m['title']?.toString() ?? 'Unknown',
  artistName:  m['artistName']?.toString() ?? 'Unknown',
  artistId:    m['artistId']?.toString(),
  albumName:   m['albumName']?.toString(),
  albumId:     m['albumId']?.toString(),
  streamUrl:   m['streamUrl']?.toString() ?? '',
  artworkUrl:  m['artworkUrl']?.toString(),
  duration:    Duration(milliseconds: (m['durationMs'] as num?)?.toInt() ?? 0),
  source: SongSource.values.firstWhere(
    (e) => e.name == m['source'], orElse: () => SongSource.audius,
  ),
  localPath:    m['localPath']?.toString(),
  isLiked:      m['isLiked'] as bool? ?? false,
  isDownloaded: m['isDownloaded'] as bool? ?? false,
  playCount:    (m['playCount'] as num?)?.toInt() ?? 0,
);
