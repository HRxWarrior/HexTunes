import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_colors.dart';

final audioQualityProvider = StateProvider<String>(
    (ref) => Hive.box('settings').get('audioQuality', defaultValue: 'High (256kbps)') as String);
final cacheEnabledProvider  = StateProvider<bool>(
    (ref) => Hive.box('settings').get('cacheEnabled', defaultValue: true) as bool);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioQ  = ref.watch(audioQualityProvider);
    final cacheOn = ref.watch(cacheEnabledProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(physics: const BouncingScrollPhysics(), padding: const EdgeInsets.all(16), children: [
        // Profile
        _glass([ListTile(
          leading: CircleAvatar(backgroundColor: AppColors.primaryGlow,
              child: const Icon(Icons.person, color: AppColors.primary)),
          title: const Text('Guest User', style: TextStyle(color: AppColors.textPrimary)),
          subtitle: const Text('Sign in for sync & playlists',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted), onTap: () {},
        )]),
        const SizedBox(height: 20),
        _hdr('Playback'),
        _glass([
          _tile(Icons.high_quality, 'Audio Quality', audioQ,
              onTap: () => _qualityPicker(context, ref)),
          _tile(Icons.cached, 'Audio Caching', 'Cache for faster replay',
              trailing: Switch(value: cacheOn, onChanged: (v) {
                ref.read(cacheEnabledProvider.notifier).state = v;
                Hive.box('settings').put('cacheEnabled', v);
              }, activeColor: AppColors.primary)),
          const _S(icon: Icons.skip_next, title: 'Crossfade', sub: 'Off'),
        ]),
        const SizedBox(height: 20),
        _hdr('Appearance'),
        _glass([
          const _S(icon: Icons.palette_outlined, title: 'Theme', sub: 'AMOLED Dark'),
          const _S(icon: Icons.color_lens_outlined, title: 'Accent Color', sub: 'Neon Purple'),
        ]),
        const SizedBox(height: 20),
        _hdr('Storage'),
        _glass([
          _tile(Icons.delete_sweep_outlined, 'Clear Cache', 'Free up storage',
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Cache cleared'), backgroundColor: AppColors.surface))),
          const _S(icon: Icons.folder_outlined, title: 'Download Location', sub: 'Internal / Music'),
        ]),
        const SizedBox(height: 20),
        _hdr('About'),
        _glass([
          const _S(icon: Icons.info_outline, title: 'Version', sub: '1.0.0'),
          const _S(icon: Icons.music_note, title: 'Powered by', sub: 'Audius & Jamendo APIs'),
        ]),
        const SizedBox(height: 80),
      ]),
    );
  }

  Widget _hdr(String t) => Padding(padding: const EdgeInsets.only(bottom: 8),
      child: Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
          color: AppColors.textMuted, letterSpacing: 0.8)));

  Widget _glass(List<Widget> children) => Container(
      decoration: BoxDecoration(color: AppColors.surfaceVar, borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider)),
      child: Column(children: children));

  ListTile _tile(IconData icon, String title, String sub, {Widget? trailing, VoidCallback? onTap}) =>
      ListTile(
        leading: Container(width:36,height:36,
            decoration:BoxDecoration(color:AppColors.glassBg,borderRadius:BorderRadius.circular(8)),
            child:Icon(icon,color:AppColors.primary,size:18)),
        title: Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
        subtitle: Text(sub, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
        trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right, color: AppColors.textMuted) : null),
        onTap: onTap, dense: true);

  void _qualityPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(context: context, backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Column(mainAxisSize: MainAxisSize.min, children: [
        const Padding(padding: EdgeInsets.all(16),
            child: Text('Audio Quality', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
        ...['Low (64kbps)', 'Normal (128kbps)', 'High (256kbps)', 'Very High (320kbps)'].map((q) =>
            ListTile(title: Text(q, style: const TextStyle(color: AppColors.textPrimary)),
                leading: const Icon(Icons.headphones, color: AppColors.textMuted),
                onTap: () { ref.read(audioQualityProvider.notifier).state = q;
                  Hive.box('settings').put('audioQuality', q); Navigator.pop(context); })),
        const SizedBox(height: 16),
      ]));
  }
}

class _S extends StatelessWidget {
  final IconData icon; final String title; final String? sub;
  const _S({required this.icon, required this.title, this.sub});
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Container(width:36,height:36,decoration:BoxDecoration(color:AppColors.glassBg,borderRadius:BorderRadius.circular(8)),
        child:Icon(icon,color:AppColors.primary,size:18)),
    title: Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
    subtitle: sub != null ? Text(sub!, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)) : null,
    dense: true);
}
