import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../models/playlist.dart';
import '../../models/song.dart';
import '../../providers/audio_provider.dart';
import '../../providers/library_provider.dart';
import '../../widgets/song_tile.dart';

class PlaylistScreen extends ConsumerWidget {
  final String playlistId;
  const PlaylistScreen({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlists = ref.watch(playlistsProvider).value ?? [];
    final playlist  = playlists.firstWhere(
      (p) => p.id == playlistId,
      orElse: () => Playlist(id: playlistId, name: 'Playlist',
          songs: [], createdAt: DateTime.now()),
    );
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
        _PlaylistHeader(playlist: playlist),
        _ActionRow(playlist: playlist),
        _SongList(playlist: playlist),
      ]),
    );
  }
}

class _PlaylistHeader extends StatelessWidget {
  final Playlist playlist;
  const _PlaylistHeader({required this.playlist});
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280, pinned: true,
      backgroundColor: AppColors.background,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(fit: StackFit.expand, children: [
          if (playlist.artworkUrl != null)
            CachedNetworkImage(imageUrl: playlist.artworkUrl!, fit: BoxFit.cover,
              errorWidget: (_, __, ___) => _bg())
          else _bg(),
          Container(decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Colors.transparent, AppColors.background],
              stops: const [0.4, 1.0]))),
          Positioned(bottom: 16, left: 16, right: 16,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(playlist.name, style: const TextStyle(
                fontSize: 26, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text('${playlist.trackCount} songs',
                style: const TextStyle(fontSize: 13,
                    color: AppColors.textSecondary)),
            ])),
        ]),
      ),
    );
  }
  Widget _bg() => Container(
    decoration: const BoxDecoration(gradient: AppColors.neonGrad),
    child: const Icon(Icons.queue_music, color: Colors.white, size: 80));
}

class _ActionRow extends ConsumerWidget {
  final Playlist playlist;
  const _ActionRow({required this.playlist});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Padding(padding: const EdgeInsets.fromLTRB(16,8,16,4),
        child: Row(children: [
          Expanded(child: ElevatedButton.icon(
            onPressed: playlist.songs.isEmpty ? null : () =>
                ref.read(audioHandlerProvider).playQueue(playlist.songs),
            icon: const Icon(Icons.play_arrow, size: 20),
            label: const Text('Play All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 14)))),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: playlist.songs.isEmpty ? null : () {
              final shuffled = List<Song>.from(playlist.songs)..shuffle();
              ref.read(audioHandlerProvider).playQueue(shuffled);
            },
            icon: const Icon(Icons.shuffle, size: 18),
            label: const Text('Shuffle'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(
                vertical: 14, horizontal: 16))),
        ])),
    );
  }
}

class _SongList extends ConsumerWidget {
  final Playlist playlist;
  const _SongList({required this.playlist});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (playlist.songs.isEmpty) {
      return SliverFillRemaining(child: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.music_off, size: 64,
            color: AppColors.textMuted.withOpacity(0.5)),
          const SizedBox(height: 12),
          const Text('No songs yet',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
        ])));
    }
    return SliverList(delegate: SliverChildBuilderDelegate(
      (ctx, i) => SongTile(song: playlist.songs[i], index: i + 1,
        onTap: () => ref.read(audioHandlerProvider)
            .playQueue(playlist.songs, start: i))
          .animate(delay: (i * 30).ms).slideX(begin: 0.1).fadeIn(),
      childCount: playlist.songs.length));
  }
}
