import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/library/library_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/player/player_screen.dart';
import '../../widgets/hex_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) => GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (ctx, state, child) => HexShell(child: child),
      routes: [
        GoRoute(path: '/home',     pageBuilder: (c,s) => const NoTransitionPage(child: HomeScreen())),
        GoRoute(path: '/search',   pageBuilder: (c,s) => const NoTransitionPage(child: SearchScreen())),
        GoRoute(path: '/library',  pageBuilder: (c,s) => const NoTransitionPage(child: LibraryScreen())),
        GoRoute(path: '/settings', pageBuilder: (c,s) => const NoTransitionPage(child: SettingsScreen())),
      ],
    ),
    GoRoute(
      path: '/player',
      pageBuilder: (ctx, state) => CustomTransitionPage(
        child: const PlayerScreen(),
        transitionsBuilder: (ctx, anim, _, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeOutCubic)).animate(anim),
          child: child),
      ),
    ),
  ],
));
