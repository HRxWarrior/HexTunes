import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';
import '../providers/audio_provider.dart';
import 'hex_mini_player.dart';

class HexShell extends ConsumerWidget {
  final Widget child;
  const HexShell({super.key, required this.child});

  static const _tabs = ['/home', '/search', '/library', '/settings'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasSong = ref.watch(currentSongProvider).valueOrNull != null;
    final loc = GoRouterState.of(context).uri.path;
    final idx = _tabs.indexWhere((t) => loc.startsWith(t));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasSong) const HexMiniPlayer(),
          NavigationBar(
            selectedIndex: idx < 0 ? 0 : idx,
            onDestinationSelected: (i) => context.go(_tabs[i]),
            backgroundColor: AppColors.navBg,
            indicatorColor: AppColors.primaryGlow,
            surfaceTintColor: Colors.transparent,
            height: 60,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(
                icon: Icon(Icons.search), selectedIcon: Icon(Icons.search), label: 'Search'),
              NavigationDestination(
                icon: Icon(Icons.library_music_outlined), selectedIcon: Icon(Icons.library_music), label: 'Library'),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),
        ],
      ),
    );
  }
}
