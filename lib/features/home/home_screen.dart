import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../models/song.dart';
import '../../providers/home_provider.dart';
import '../../providers/audio_provider.dart';
import '../../widgets/song_tile.dart';
import '../../widgets/album_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trending    = ref.watch(trendingProvider);
    final newReleases = ref.watch(newReleasesProvider);
    final recent      = ref.watch(recentlyPlayedProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.background,
            expandedHeight: 80,
            collapsedHeight: 60,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              title: Row(children: [
                // Hex Logo
                Container(width: 32, height: 32,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                    gradient: AppColors.neonGrad,
                    boxShadow: [BoxShadow(color: AppColors.primaryGlow, blurRadius: 8)]),
                  child: const Icon(Icons.graphic_eq, color: Colors.white, size: 18)),
                const SizedBox(width: 10),
                Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('HexTunes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary, letterSpacing: -0.3)),
                    Text('Feel Every Beat', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  ]),
                const Spacer(),
                IconButton(icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary),
                    onPressed: () {}),
              ]),
            ),
          ),

          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(_greeting(), style: const TextStyle(
              fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary))
                .animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
          )),

          SliverToBoxAdapter(child: _Section(title: '🔥 Trending Now',
            child: trending.when(
              loading: () => _HShimmer(),
              error:   (_, __) => const _Err('Could not load trending'),
              data:    (s) => _HList(songs: s),
            )).animate().fadeIn(delay: 100.ms)),

          SliverToBoxAdapter(child: _Section(title: '✨ New Releases',
            child: newReleases.when(
              loading: () => _HShimmer(),
              error:   (_, __) => const _Err('Could not load releases'),
              data:    (s) => _HList(songs: s),
            )).animate().fadeIn(delay: 200.ms)),

          SliverToBoxAdapter(child: recent.when(
            loading: () => const SizedBox.shrink(),
            error:   (_, __) => const SizedBox.shrink(),
            data: (s) => s.isEmpty ? const SizedBox.shrink()
                : _Section(title: '⏱ Recently Played', child: _HList(songs: s))
                    .animate().fadeIn(delay: 300.ms))),

          const SliverToBoxAdapter(child: Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text('Top Tracks', style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)))),

          trending.when(
            loading: () => SliverList(delegate: SliverChildBuilderDelegate(
                (_, i) => _ListShimmer(), childCount: 8)),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
            data: (songs) => SliverList(delegate: SliverChildBuilderDelegate(
              (_, i) => SongTile(song: songs[i], queue: songs, index: i)
                  .animate().fadeIn(delay: (50 * i).ms),
              childCount: songs.length)),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning ☀️';
    if (h < 17) return 'Good afternoon 🎵';
    return 'Good evening 🌙';
  }
}

class _Section extends StatelessWidget {
  final String title; final Widget child;
  const _Section({required this.title, required this.child});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
        child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
            color: AppColors.textPrimary))),
    child,
  ]);
}

class _HList extends ConsumerWidget {
  final List<Song> songs;
  const _HList({required this.songs});
  @override
  Widget build(BuildContext context, WidgetRef ref) => SizedBox(
    height: 190,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      itemCount: songs.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, i) => AlbumCard(song: songs[i], onTap: () {
        ref.read(audioHandlerProvider).playSong(songs[i], queue: songs, index: i);
        context.push('/player');
      }),
    ),
  );
}

class _HShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 190,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: AppColors.card, highlightColor: AppColors.surfaceVar,
        child: Container(width: 140, height: 180,
            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12)))),
    ),
  );
}

class _ListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Shimmer.fromColors(
      baseColor: AppColors.card, highlightColor: AppColors.surfaceVar,
      child: Row(children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(
            color: AppColors.card, borderRadius: BorderRadius.circular(8))),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(height: 12, width: 160, color: AppColors.card),
          const SizedBox(height: 6),
          Container(height: 10, width: 100, color: AppColors.card),
        ]),
      ]),
    ),
  );
}

class _Err extends StatelessWidget {
  final String msg;
  const _Err(this.msg);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Text(msg, style: const TextStyle(color: AppColors.textMuted)));
}
