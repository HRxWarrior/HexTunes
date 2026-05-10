import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/constants/app_colors.dart';
import '../models/song.dart';

class AlbumCard extends StatelessWidget {
  final Song song; final VoidCallback? onTap; final double width;
  const AlbumCard({super.key, required this.song, this.onTap, this.width = 140});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(width: width, child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: song.artworkUrl != null
                ? CachedNetworkImage(imageUrl: song.artworkUrl!,
                    width: width, height: width, fit: BoxFit.cover,
                    placeholder: (_, __) => _placeholder())
                : _placeholder(),
          ),
          const SizedBox(height: 8),
          Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
          Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      )),
    );
  }

  Widget _placeholder() => Container(
    width: width, height: width,
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [AppColors.card, AppColors.surfaceVar],
          begin: Alignment.topLeft, end: Alignment.bottomRight),
      borderRadius: BorderRadius.circular(12)),
    child: const Icon(Icons.album, color: AppColors.textMuted, size: 40));
}
