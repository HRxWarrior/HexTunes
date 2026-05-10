import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/search_provider.dart';
import '../../widgets/song_tile.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _ctrl  = TextEditingController();
  final _focus = FocusNode();
  Timer? _deb;

  @override void dispose() { _ctrl.dispose(); _focus.dispose(); _deb?.cancel(); super.dispose(); }

  void _onChange(String q) {
    _deb?.cancel();
    _deb = Timer(const Duration(milliseconds: 500),
        () => ref.read(searchProvider.notifier).search(q));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 0), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Search', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              TextField(
                controller: _ctrl, focusNode: _focus, onChanged: _onChange,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Songs, artists, genres…',
                  hintStyle: const TextStyle(color: AppColors.textMuted),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                  suffixIcon: state.query.isNotEmpty ? IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.textMuted),
                      onPressed: () { _ctrl.clear(); ref.read(searchProvider.notifier).clear(); }) : null,
                  filled: true, fillColor: AppColors.surfaceVar,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          )),
          Expanded(child: state.isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2))
              : state.query.isEmpty ? _GenreGrid() : _Results(state: state)),
        ]),
      ),
    );
  }
}

class _Results extends ConsumerWidget {
  final SearchState state;
  const _Results({required this.state});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.error != null) return Center(child: Text('Error: \${state.error}',
        style: const TextStyle(color: AppColors.textMuted)));
    if (state.songs.isEmpty && state.artists.isEmpty)
      return const Center(child: Text('No results found',
          style: TextStyle(color: AppColors.textMuted, fontSize: 16)));
    return CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
      if (state.artists.isNotEmpty) ...[
        const SliverPadding(padding: EdgeInsets.fromLTRB(16,20,16,8),
            sliver: SliverToBoxAdapter(child: Text('Artists',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)))),
        SliverToBoxAdapter(child: SizedBox(height: 110,
          child: ListView.separated(scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.artists.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, i) {
              final a = state.artists[i];
              return Column(children: [
                CircleAvatar(radius: 36, backgroundColor: AppColors.card,
                    backgroundImage: a.avatarUrl != null ? NetworkImage(a.avatarUrl!) : null,
                    child: a.avatarUrl == null ? const Icon(Icons.person, color: AppColors.textMuted) : null),
                const SizedBox(height: 4),
                SizedBox(width: 72, child: Text(a.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))),
              ]);
            }),
        )),
      ],
      const SliverPadding(padding: EdgeInsets.fromLTRB(16,20,16,8),
          sliver: SliverToBoxAdapter(child: Text('Songs',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)))),
      SliverList(delegate: SliverChildBuilderDelegate(
        (_, i) => SongTile(song: state.songs[i], queue: state.songs, index: i)
            .animate().fadeIn(delay: (30 * i).ms),
        childCount: state.songs.length)),
      const SliverToBoxAdapter(child: SizedBox(height: 120)),
    ]);
  }
}

class _GenreGrid extends StatelessWidget {
  static const _genres = [
    ('Hip-Hop', Icons.graphic_eq, Color(0xFF7C3AED)),
    ('Electronic', Icons.electric_bolt, Color(0xFF0EA5E9)),
    ('Pop', Icons.star, Color(0xFFEC4899)),
    ('Rock', Icons.music_note, Color(0xFFEF4444)),
    ('Jazz', Icons.piano, Color(0xFFF59E0B)),
    ('Classical', Icons.audiotrack, Color(0xFF10B981)),
    ('R&B', Icons.favorite, Color(0xFF8B5CF6)),
    ('Ambient', Icons.cloud, Color(0xFF06B6D4)),
  ];
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(padding: EdgeInsets.only(top: 8, bottom: 16),
          child: Text('Browse Genres', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
              color: AppColors.textPrimary))),
      Expanded(child: GridView.count(
        crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12,
        childAspectRatio: 2.2, physics: const BouncingScrollPhysics(),
        children: _genres.map((g) => _GenreTile(label: g.\$1, icon: g.\$2, color: g.\$3)).toList(),
      )),
    ]),
  );
}

class _GenreTile extends StatelessWidget {
  final String label; final IconData icon; final Color color;
  const _GenreTile({required this.label, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
            begin: Alignment.topLeft, end: Alignment.bottomRight)),
    child: Material(color: Colors.transparent, borderRadius: BorderRadius.circular(12),
      child: InkWell(borderRadius: BorderRadius.circular(12), onTap: () {},
        child: Padding(padding: const EdgeInsets.all(12),
          child: Row(children: [
            Icon(icon, color: Colors.white, size: 22), const SizedBox(width: 10),
            Text(label, style: const TextStyle(color: Colors.white,
                fontWeight: FontWeight.w600, fontSize: 14)),
          ])))),
  );
}
