import 'song_model.dart';

class AlbumModel {
  const AlbumModel({
    required this.id,
    required this.title,
    required this.artistName,
    required this.source,
    this.artistId,
    this.artworkUrl,
    this.releaseDate,
    this.tracks     = const [],
    this.trackCount = 0,
  });

  final String        id;
  final String        title;
  final String        artistName;
  final String?       artistId;
  final String?       artworkUrl;
  final String?       releaseDate;
  final List<SongModel> tracks;
  final int           trackCount;
  final String        source;

  factory AlbumModel.fromAudiusJson(Map<String, dynamic> j) {
    final art = j['artwork'] as Map<String, dynamic>?;
    return AlbumModel(
      id:          j['id']?.toString() ?? '',
      title:       j['playlist_name']?.toString() ?? 'Unknown',
      artistName:  (j['user'] as Map?)? ['name']?.toString() ?? 'Unknown',
      artistId:    (j['user'] as Map?)? ['id']?.toString(),
      artworkUrl:  art?['480x480']?.toString(),
      source:      'audius',
      trackCount:  (j['track_count'] as num?)?.toInt() ?? 0,
    );
  }

  factory AlbumModel.fromJamendoJson(Map<String, dynamic> j) {
    return AlbumModel(
      id:          j['id']?.toString()          ?? '',
      title:       j['name']?.toString()         ?? 'Unknown',
      artistName:  j['artist_name']?.toString()  ?? 'Unknown',
      artistId:    j['artist_id']?.toString(),
      artworkUrl:  j['image']?.toString(),
      releaseDate: j['releasedate']?.toString(),
      source:      'jamendo',
    );
  }

  @override bool operator ==(Object o) => identical(this, o) || o is AlbumModel && id == o.id;
  @override int  get hashCode => id.hashCode;
}
