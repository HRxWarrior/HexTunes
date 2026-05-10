class ArtistModel {
  const ArtistModel({
    required this.id,
    required this.name,
    required this.source,
    this.bio,
    this.coverArtUrl,
    this.followerCount = 0,
    this.trackCount    = 0,
  });

  final String  id;
  final String  name;
  final String? bio;
  final String? coverArtUrl;
  final int     followerCount;
  final int     trackCount;
  final String  source;

  factory ArtistModel.fromAudiusJson(Map<String, dynamic> j) {
    final cover = j['cover_photo'] as Map<String, dynamic>?;
    return ArtistModel(
      id:            j['id']?.toString()           ?? '',
      name:          j['name']?.toString()          ?? 'Unknown',
      bio:           j['bio']?.toString(),
      coverArtUrl:   cover?['2000x']?.toString(),
      followerCount: (j['follower_count'] as num?)?.toInt() ?? 0,
      trackCount:    (j['track_count']    as num?)?.toInt() ?? 0,
      source:        'audius',
    );
  }

  factory ArtistModel.fromJamendoJson(Map<String, dynamic> j) {
    return ArtistModel(
      id:          j['id']?.toString()    ?? '',
      name:        j['name']?.toString()  ?? 'Unknown',
      coverArtUrl: j['image']?.toString(),
      source:      'jamendo',
    );
  }

  @override bool operator ==(Object o) => identical(this, o) || o is ArtistModel && id == o.id;
  @override int  get hashCode => id.hashCode;
}
