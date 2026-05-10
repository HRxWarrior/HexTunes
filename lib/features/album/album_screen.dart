import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../models/song.dart';
import '../../providers/audio_provider.dart';
import '../../widgets/song_tile.dart';

class AlbumScreen extends ConsumerWidget {
  final String  albumId;
  final String  albumName;
  final String? artworkUrl;
  final String? artistName;
  final List<Song> songs;

  const AlbumScreen({
    super.key,
    required this.albumId,
    required this.albumName,
    this.artworkUrl,
    this.artistName,
    this.songs = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
        _AlbumHeader(albumName: albumName, artworkUrl: artworkUrl,
            artistName: artistName, trackCount: songs.length),
        SliverToBoxAdapter(
          child: Padding(padding: const EdgeInsets.fromLTRB(16,8,16,4),
            child: Row(children: [
              Expanded(child: ElevatedButton.icon(
                onPressed: songs.isEmpty ? null : () =>
                    ref.read(audioHandlerProvider).playQueue(songs),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play All'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14)))),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: songs.isEmpty ? null : () {
                  final s = List<Song>.from(songs)..shuffle();
                  ref.read(audioHandlerProvider).playQueue(s);
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
            ]))),
        if (songs.isEmpty)
          SliverFillRemaining(child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.music_off, size: 64,
                color: AppColors.textMuted.withOpacity(0.4)),
              const SizedBox(height: 12),
              const Text('No tracks', style: TextStyle(
                color: AppColors.textSecondary)),
            ])))
        else
          SliverList(delegate: SliverChildBuilderDelegate(
            (ctx, i) => SongTile(song: songs[i], index: i + 1,
              onTap: () => ref.read(audioHandlerProvider)
                  .playQueue(songs, start: i))
                .animate(delay: (i * 30).ms).slideX(begin: 0.1).fadeIn(),
            childCount: songs.length)),
      ]),
    );
  }
}

class _AlbumHeader extends StatelessWidget {
  final String  albumName;
  final String? artworkUrl;
  final String? artistName;
  final int     trackCount;
  const _AlbumHeader({required this.albumName, required this.trackCount,
      this.artworkUrl, this.artistName});
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300, pinned: true,
      backgroundColor: AppColors.background,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(fit: StackFit.expand, children: [
          if (artworkUrl != null)
            CachedNetworkImage(imageUrl: artworkUrl!, fit: BoxFit.cover,
              errorWidget: (_, __, ___) => _bg())
          else _bg(),
          Container(decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Colors.transparent, AppColors.background],
            stops: const [0.4, 1.0]))),
          Positioned(bottom: 16, left: 16, right: 16,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(albumName, style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
              if (artistName != null) ...[
                const SizedBox(height: 4),
                Text(artistName!, style: const TextStyle(
                  fontSize: 14, color: AppColors.secondary,
                  fontWeight: FontWeight.w500)),
              ],
              const SizedBox(height: 4),
              Text('$trackCount tracks', style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary)),
            ])),
        ]),
      ),
    );
  }
  Widget _bg() => Container(
    decoration: const BoxDecoration(gradient: AppColors.neonGrad),
    child: const Icon(Icons.album, color: Colors.white54, size: 80));
}
