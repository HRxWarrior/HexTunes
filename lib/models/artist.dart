import 'package:equatable/equatable.dart';

class Artist extends Equatable {
  final String id; final String name; final String? bio;
  final String? avatarUrl; final String? coverUrl;
  final int? followerCount; final int? trackCount; final String? source;

  const Artist({
    required this.id, required this.name,
    this.bio, this.avatarUrl, this.coverUrl,
    this.followerCount, this.trackCount, this.source,
  });

  factory Artist.fromAudiusJson(Map<String, dynamic> j) => Artist(
    id: j['id'] as String,
    name: j['name'] as String? ?? 'Unknown',
    bio: j['bio'] as String?,
    avatarUrl: (j['profile_picture'] as Map<String, dynamic>?)?['640x640'] as String?,
    coverUrl:  (j['cover_photo'] as Map<String, dynamic>?)?['2000x'] as String?,
    followerCount: j['follower_count'] as int?,
    trackCount:    j['track_count']    as int?,
    source: 'audius',
  );

  @override List<Object?> get props => [id];
}
