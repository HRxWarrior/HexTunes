import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/duration_ext.dart';
import '../../providers/audio_provider.dart';
import '../../providers/library_provider.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key});
  @override ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> with TickerProviderStateMixin {
  late AnimationController _rot;
  @override void initState() { super.initState(); _rot = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat(); }
  @override void dispose() { _rot.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final song = ref.watch(currentSongProvider).valueOrNull;
    if (song == null) { WidgetsBinding.instance.addPostFrameCallback((_) => context.pop()); return const Scaffold(backgroundColor: AppColors.background); }
    final isPlaying = ref.watch(isPlayingProvider);
    final pos       = ref.watch(positionProvider).valueOrNull ?? Duration.zero;
    final handler   = ref.read(audioHandlerProvider);
    final loopMode  = ref.watch(loopModeProvider);
    final shuffle   = ref.watch(shuffleModeProvider);
    final liked     = ref.watch(likedSongsProvider.notifier).isLiked(song.id);

    isPlaying ? _rot.repeat() : _rot.stop();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, size: 32, color: AppColors.textPrimary),
            onPressed: () => context.pop()),
        title: const Text('Now Playing', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.more_vert, color: AppColors.textSecondary), onPressed: () {})],
      ),
      body: Stack(fit: StackFit.expand, children: [
        if (song.artworkUrl != null)
          Positioned.fill(child: CachedNetworkImage(imageUrl: song.artworkUrl!, fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(color: AppColors.background))),
        Positioned.fill(child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
          child: Container(decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [AppColors.background.withOpacity(0.55), AppColors.background.withOpacity(0.9), AppColors.background],
            stops: const [0, 0.4, 1]))),
        )),
        SafeArea(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            const SizedBox(height: 16),
            // Rotating Album Art
            Center(child: AnimatedBuilder(
              animation: _rot,
              builder: (_, child) => Transform.rotate(angle: _rot.value * 6.2832, child: child),
              child: Container(
                width: 260, height: 260,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppColors.primaryGlow, blurRadius: 40, spreadRadius: 4)]),
                child: ClipOval(child: song.artworkUrl != null
                    ? CachedNetworkImage(imageUrl: song.artworkUrl!, width: 260, height: 260, fit: BoxFit.cover)
                    : Container(color: AppColors.card, child: const Icon(Icons.music_note, color: AppColors.textMuted, size: 80))),
              ),
            )).animate().scale(delay: 100.ms, duration: 400.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 32),
            // Song Info
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(song.artist, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
              ])),
              IconButton(
                icon: Icon(liked ? Icons.favorite : Icons.favorite_border,
                    color: liked ? AppColors.primary : AppColors.textMuted, size: 26),
                onPressed: () => ref.read(likedSongsProvider.notifier).toggle(song),
              ),
            ]),

            const SizedBox(height: 24),
            // Progress
            Column(children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(trackHeight: 4, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7)),
                child: Slider(
                  value: song.duration.inMilliseconds > 0
                      ? (pos.inMilliseconds / song.duration.inMilliseconds).clamp(0.0, 1.0) : 0.0,
                  onChanged: (v) => handler.seek(Duration(milliseconds: (v * song.duration.inMilliseconds).round())),
                  activeColor: AppColors.primary, inactiveColor: AppColors.glassBg),
              ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(pos.mmss, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  Text(song.duration.mmss, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ],
              )),
            ]),

            const SizedBox(height: 16),
            // Controls
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              IconButton(icon: Icon(Icons.shuffle, color: shuffle ? AppColors.primary : AppColors.textMuted, size: 24),
                  onPressed: () => ref.read(shuffleModeProvider.notifier).toggle()),
              IconButton(icon: const Icon(Icons.skip_previous, size: 36, color: AppColors.textPrimary),
                  onPressed: handler.skipToPrevious),
              GestureDetector(
                onTap: isPlaying ? handler.pause : handler.play,
                child: Container(width: 68, height: 68,
                  decoration: BoxDecoration(shape: BoxShape.circle, gradient: AppColors.neonGrad,
                      boxShadow: [BoxShadow(color: AppColors.primaryGlow, blurRadius: 20, spreadRadius: 4)]),
                  child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 34, color: Colors.white)),
              ).animate(key: ValueKey(isPlaying)).scale(duration: 150.ms, curve: Curves.easeOutBack),
              IconButton(icon: const Icon(Icons.skip_next, size: 36, color: AppColors.textPrimary),
                  onPressed: handler.skipToNext),
              IconButton(
                icon: Icon(loopMode == LoopMode.one ? Icons.repeat_one : Icons.repeat,
                    color: loopMode != LoopMode.off ? AppColors.primary : AppColors.textMuted, size: 24),
                onPressed: () => ref.read(loopModeProvider.notifier).toggle()),
            ]),

            const SizedBox(height: 20),
            // Extra buttons
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _ExBtn(icon: Icons.queue_music, label: 'Queue', onTap: () => _showQueue(context, ref)),
              _ExBtn(icon: Icons.lyrics_outlined, label: 'Lyrics', onTap: () {}),
              _ExBtn(icon: Icons.equalizer, label: 'EQ', onTap: () {}),
              _ExBtn(icon: Icons.bedtime_outlined, label: 'Sleep', onTap: () => _showSleep(context, ref)),
            ]),
          ]),
        )),
      ]),
    );
  }

  void _showQueue(BuildContext context, WidgetRef ref) {
    final queue = ref.read(audioHandlerProvider).songQueue;
    showModalBottomSheet(context: context, backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(padding: const EdgeInsets.fromLTRB(20,12,20,32), child: Column(children: [
        Container(width:40,height:4,decoration:BoxDecoration(color:AppColors.divider,borderRadius:BorderRadius.circular(2))),
        const SizedBox(height:16),
        Text('Queue (\${queue.length})',style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold,color:AppColors.textPrimary)),
        const SizedBox(height:12),
        Expanded(child:ListView.builder(physics:const BouncingScrollPhysics(),itemCount:queue.length,
          itemBuilder:(_,i)=>ListTile(
            leading:Text('\${i+1}',style:const TextStyle(color:AppColors.textMuted,fontSize:13)),
            title:Text(queue[i].title,maxLines:1,overflow:TextOverflow.ellipsis,
                style:const TextStyle(color:AppColors.textPrimary,fontSize:14)),
            subtitle:Text(queue[i].artist,style:const TextStyle(color:AppColors.textSecondary,fontSize:12)),
            dense:true))),
      ])));
  }

  void _showSleep(BuildContext context, WidgetRef ref) {
    showDialog(context:context, builder:(_)=>AlertDialog(
      backgroundColor:AppColors.surface,
      title:const Text('Sleep Timer',style:TextStyle(color:AppColors.textPrimary)),
      content:Wrap(spacing:8,runSpacing:8,children:[15,30,45,60,90].map((m)=>ActionChip(
        label:Text('\$m min'),backgroundColor:AppColors.glassBg,
        labelStyle:const TextStyle(color:AppColors.textPrimary),
        onPressed:(){ ref.read(audioHandlerProvider).customAction('setSleepTimer',{'minutes':m}); Navigator.pop(context); }
      )).toList()),
    ));
  }
}

class _ExBtn extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _ExBtn({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap:onTap, child:Column(children:[
    Container(width:44,height:44,decoration:BoxDecoration(borderRadius:BorderRadius.circular(12),
        color:AppColors.glassBg,border:Border.all(color:AppColors.glassBorder)),
        child:Icon(icon,color:AppColors.textSecondary,size:20)),
    const SizedBox(height:4),
    Text(label,style:const TextStyle(fontSize:10,color:AppColors.textMuted)),
  ]));
}
