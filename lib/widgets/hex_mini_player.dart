import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';
import '../core/utils/duration_ext.dart';
import '../providers/audio_provider.dart';

class HexMiniPlayer extends ConsumerWidget {
  const HexMiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final song = ref.watch(currentSongProvider).valueOrNull;
    if (song == null) return const SizedBox.shrink();
    final isPlaying = ref.watch(isPlayingProvider);
    final handler   = ref.read(audioHandlerProvider);
    final pos = ref.watch(positionProvider).valueOrNull ?? Duration.zero;
    final dur = song.duration;
    final progress = dur.inMilliseconds > 0
        ? (pos.inMilliseconds / dur.inMilliseconds).clamp(0.0, 1.0) : 0.0;

    return GestureDetector(
      onTap: () => context.push('/player'),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.surface.withOpacity(0.95), AppColors.navBg.withOpacity(0.98)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              border: const Border(top: BorderSide(color: AppColors.glassBorder, width: 1)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                  value: progress.toDouble(),
                  backgroundColor: AppColors.divider,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 2,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: song.artworkUrl != null
                            ? CachedNetworkImage(
                                imageUrl: song.artworkUrl!, width: 44, height: 44, fit: BoxFit.cover)
                            : Container(width: 44, height: 44, color: AppColors.card,
                                child: const Icon(Icons.music_note, color: AppColors.textMuted)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary)),
                          Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ]),
                      ),
                      IconButton(icon: const Icon(Icons.skip_previous, size: 24, color: AppColors.textSecondary),
                          onPressed: handler.skipToPrevious),
                      GestureDetector(
                        onTap: isPlaying ? handler.pause : handler.play,
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, gradient: AppColors.neonGrad,
                            boxShadow: [BoxShadow(color: AppColors.primaryGlow, blurRadius: 8)]),
                          child: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white, size: 20),
                        ),
                      ),
                      IconButton(icon: const Icon(Icons.skip_next, size: 24, color: AppColors.textSecondary),
                          onPressed: handler.skipToNext),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
