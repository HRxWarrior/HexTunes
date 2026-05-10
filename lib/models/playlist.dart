import 'package:equatable/equatable.dart';
import 'song.dart';

class Playlist extends Equatable {
  final String id; final String name; final String? description;
  final String? artworkUrl; final List<Song> songs;
  final DateTime createdAt; final bool isLocal;

  const Playlist({
    required this.id, required this.name,
    this.description, this.artworkUrl,
    this.songs = const [], required this.createdAt, this.isLocal = true,
  });

  Playlist copyWith({
    String? id, String? name, String? description, String? artworkUrl,
    List<Song>? songs, DateTime? createdAt, bool? isLocal,
  }) => Playlist(
    id: id ?? this.id, name: name ?? this.name,
    description: description ?? this.description,
    artworkUrl: artworkUrl ?? this.artworkUrl,
    songs: songs ?? this.songs, createdAt: createdAt ?? this.createdAt,
    isLocal: isLocal ?? this.isLocal,
  );

  int get trackCount => songs.length;

  Map<String, dynamic> toMap() => {
    'id': id, 'name': name, 'description': description, 'artworkUrl': artworkUrl,
    'songs': songs.map((s) => s.toMap()).toList(),
    'createdAt': createdAt.toIso8601String(), 'isLocal': isLocal,
  };

  factory Playlist.fromMap(Map<String, dynamic> m) => Playlist(
    id: m['id'] as String, name: m['name'] as String,
    description: m['description'] as String?,
    artworkUrl:  m['artworkUrl']  as String?,
    songs: (m['songs'] as List<dynamic>? ?? [])
        .map((s) => Song.fromMap(s as Map<String, dynamic>)).toList(),
    createdAt: DateTime.parse(m['createdAt'] as String),
    isLocal: m['isLocal'] as bool? ?? true,
  );

  @override List<Object?> get props => [id];
}
