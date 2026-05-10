import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/duration_ext.dart';
import '../models/song.dart';
import '../providers/audio_provider.dart';
import '../providers/library_provider.dart';

class SongTile extends ConsumerWidget {
  final Song song;
  final List<Song>? queue;
  final int? index;
  final VoidCallback? onTap;
  final bool showMenu;

  const SongTile({super.key, required this.song,
      this.queue, this.index, this.onTap, this.showMenu = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current   = ref.watch(currentSongProvider).valueOrNull;
    final isPlaying = ref.watch(isPlayingProvider);
    final isActive  = current?.id == song.id;
    final liked     = ref.watch(likedSongsProvider.notifier).isLiked(song.id);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () => ref.read(audioHandlerProvider)
            .playSong(song, queue: queue, index: index),
        splashColor: AppColors.primaryGlow,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(children: [
            _ArtworkWidget(url: song.artworkUrl, isActive: isActive, isPlaying: isPlaying),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                      color: isActive ? AppColors.primaryLt : AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text('${song.artist}  •  ${song.duration.mmss}',
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ])),
            if (showMenu) ...[
              IconButton(
                icon: Icon(liked ? Icons.favorite : Icons.favorite_border,
                    color: liked ? AppColors.primary : AppColors.textMuted, size: 20),
                onPressed: () => ref.read(likedSongsProvider.notifier).toggle(song),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: AppColors.textMuted, size: 20),
                onPressed: () => _showMenu(context, ref),
              ),
            ],
          ]),
        ),
      ),
    );
  }

  void _showMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          _item(Icons.queue_music, 'Add to Queue', () {
            ref.read(audioHandlerProvider).addToQueue(song);
            Navigator.pop(context);
          }),
          _item(Icons.playlist_add, 'Add to Playlist', () => Navigator.pop(context)),
          _item(Icons.download_outlined, 'Download', () => Navigator.pop(context)),
          _item(Icons.share_outlined, 'Share', () => Navigator.pop(context)),
        ]),
      ),
    );
  }

  Widget _item(IconData icon, String label, VoidCallback onTap) => ListTile(
    leading: Icon(icon, color: AppColors.textSecondary),
    title: Text(label, style: const TextStyle(color: AppColors.textPrimary)),
    onTap: onTap, dense: true);
}

class _ArtworkWidget extends StatelessWidget {
  final String? url; final bool isActive; final bool isPlaying;
  const _ArtworkWidget({this.url, required this.isActive, required this.isPlaying});
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: url != null
            ? CachedNetworkImage(imageUrl: url!, width: 48, height: 48, fit: BoxFit.cover,
                placeholder: (_, __) => Container(width: 48, height: 48, color: AppColors.card,
                    child: const Icon(Icons.music_note, color: AppColors.textMuted, size: 20)),
                errorWidget: (_, __, ___) => Container(width: 48, height: 48, color: AppColors.card,
                    child: const Icon(Icons.music_note, color: AppColors.textMuted, size: 20)))
            : Container(width: 48, height: 48, color: AppColors.card,
                child: const Icon(Icons.music_note, color: AppColors.textMuted, size: 20)),
      ),
      if (isActive)
        Container(width: 48, height: 48,
            decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
            child: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                color: AppColors.primary, size: 22)),
    ]);
  }
}
