import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../models/artist.dart';
import '../../models/song.dart';
import '../../providers/audio_provider.dart';
import '../../providers/home_provider.dart';
import '../../widgets/song_tile.dart';

final _artistTracksProvider = FutureProvider.family<List<Song>, String>(
  (ref, id) => ref.watch(audiusServiceProvider).getArtistTracks(id),
);

class ArtistScreen extends ConsumerWidget {
  final String  artistId;
  final String? artistName;
  final String? coverUrl;
  const ArtistScreen({
    super.key, required this.artistId,
    this.artistName, this.coverUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksAsync = ref.watch(_artistTracksProvider(artistId));
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
        _ArtistHeader(artistName: artistName, coverUrl: coverUrl),
        SliverToBoxAdapter(
          child: Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: const Text('Popular Tracks', style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600,
              color: AppColors.textPrimary)))),
        tracksAsync.when(
          data: (tracks) => SliverList(delegate: SliverChildBuilderDelegate(
            (ctx, i) => SongTile(song: tracks[i], index: i + 1,
              onTap: () => ref.read(audioHandlerProvider)
                  .playQueue(tracks, start: i))
                .animate(delay: (i * 30).ms).slideX(begin: 0.1).fadeIn(),
            childCount: tracks.length)),
          loading: () => const SliverToBoxAdapter(child: Center(
            child: Padding(padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(color: AppColors.primary)))),
          error: (_, __) => const SliverToBoxAdapter(child: Center(
            child: Text('Could not load tracks',
              style: TextStyle(color: AppColors.textSecondary))))),
      ]),
    );
  }
}

class _ArtistHeader extends StatelessWidget {
  final String? artistName;
  final String? coverUrl;
  const _ArtistHeader({this.artistName, this.coverUrl});
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 260, pinned: true,
      backgroundColor: AppColors.background,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(fit: StackFit.expand, children: [
          if (coverUrl != null)
            CachedNetworkImage(imageUrl: coverUrl!, fit: BoxFit.cover,
              errorWidget: (_, __, ___) => _bg())
          else _bg(),
          Container(decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Colors.transparent, AppColors.background],
            stops: const [0.35, 1.0]))),
          Positioned(bottom: 16, left: 16, right: 16,
            child: Text(artistName ?? 'Artist', style: const TextStyle(
              fontSize: 26, fontWeight: FontWeight.w700,
              color: AppColors.textPrimary))),
        ]),
      ),
    );
  }
  Widget _bg() => Container(
    decoration: const BoxDecoration(gradient: AppColors.neonGrad),
    child: const Icon(Icons.person, color: Colors.white54, size: 80));
}
