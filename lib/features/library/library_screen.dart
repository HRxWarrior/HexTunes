import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/library_provider.dart';
import '../../providers/audio_provider.dart';
import '../../widgets/song_tile.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});
  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }
  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Library'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: AppColors.primary),
              onPressed: () => _create(context),
            ),
          ],
          bottom: TabBar(
            controller: _tabs,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            tabs: const [
              Tab(text: 'Liked'),
              Tab(text: 'Playlists'),
              Tab(text: 'Downloads'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabs,
          children: const [_LikedTab(), _PlaylistsTab(), _DownloadsTab()],
        ),
      );

  Future<void> _create(BuildContext context) async {
    final ctrl = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('New Playlist',
            style: TextStyle(color: AppColors.textPrimary)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Playlist name',
            hintStyle: TextStyle(color: AppColors.textMuted),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, ctrl.text),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (name != null && name.trim().isNotEmpty) {
      ref.read(playlistsProvider.notifier).create(name.trim());
    }
  }
}

// ── Liked Songs ─────────────────────────────────────────────────────────────

class _LikedTab extends ConsumerWidget {
  const _LikedTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songs = ref.watch(likedSongsProvider);
    if (songs.isEmpty) {
      return const _Empty(
        icon:  Icons.favorite_border,
        title: 'No liked songs yet',
        sub:   'Tap the heart on any song',
      );
    }
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Text('${songs.length} songs',
              style: const TextStyle(color: AppColors.textSecondary)),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(audioHandlerProvider).playQueue(songs);
              context.push('/player');
            },
            icon:  const Icon(Icons.play_arrow, size: 18),
            label: const Text('Play All'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ]),
      ),
      Expanded(
        child: ListView.builder(
          physics:   const BouncingScrollPhysics(),
          itemCount: songs.length,
          itemBuilder: (_, i) => SongTile(
            song:  songs[i],
            queue: songs,
            index: i,
          ).animate().fadeIn(delay: (30 * i).ms),
        ),
      ),
    ]);
  }
}

// ── Playlists ────────────────────────────────────────────────────────────────

class _PlaylistsTab extends ConsumerWidget {
  const _PlaylistsTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Unwrap AsyncValue → List
    final pls = ref.watch(playlistsProvider).value ?? [];
    if (pls.isEmpty) {
      return const _Empty(
        icon:  Icons.queue_music,
        title: 'No playlists yet',
        sub:   'Tap + to create one',
      );
    }
    return ListView.builder(
      physics:   const BouncingScrollPhysics(),
      padding:   const EdgeInsets.all(16),
      itemCount: pls.length,
      itemBuilder: (_, i) => Card(
        color:  AppColors.card,
        margin: const EdgeInsets.only(bottom: 12),
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient:     AppColors.neonGrad,
            ),
            child: const Icon(Icons.queue_music, color: Colors.white),
          ),
          title: Text(pls[i].name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              )),
          subtitle: Text('${pls[i].trackCount} tracks',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              )),
          onTap: () => context.push('/playlist/${pls[i].id}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline,
                color: AppColors.error),
            onPressed: () =>
                ref.read(playlistsProvider.notifier)
                    .deletePlaylist(pls[i].id),
          ),
        ),
      ).animate().fadeIn(delay: (50 * i).ms),
    );
  }
}

// ── Downloads ────────────────────────────────────────────────────────────────

class _DownloadsTab extends StatelessWidget {
  const _DownloadsTab();
  @override
  Widget build(BuildContext context) => const _Empty(
        icon:  Icons.download_done,
        title: 'No downloads yet',
        sub:   'Download songs to listen offline',
      );
}

// ── Empty state ──────────────────────────────────────────────────────────────

class _Empty extends StatelessWidget {
  final IconData icon;
  final String   title;
  final String   sub;
  const _Empty({required this.icon, required this.title, required this.sub});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textMuted, size: 64),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                )),
            const SizedBox(height: 8),
            Text(sub,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                )),
          ],
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .scale(begin: const Offset(0.9, 0.9)),
      );
}
