import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/home_screen.dart';
import '../../features/search/search_screen.dart';
import '../../features/library/library_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/player/player_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/playlist/playlist_screen.dart';
import '../../features/artist/artist_screen.dart';
import '../../features/album/album_screen.dart';
import '../../widgets/hex_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) => GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (ctx, state) =>
          const NoTransitionPage(child: SplashScreen()),
    ),
    ShellRoute(
      builder: (ctx, state, child) => HexShell(child: child),
      routes: [
        GoRoute(path: '/home',
          pageBuilder: (c, s) =>
              const NoTransitionPage(child: HomeScreen())),
        GoRoute(path: '/search',
          pageBuilder: (c, s) =>
              const NoTransitionPage(child: SearchScreen())),
        GoRoute(path: '/library',
          pageBuilder: (c, s) =>
              const NoTransitionPage(child: LibraryScreen())),
        GoRoute(path: '/settings',
          pageBuilder: (c, s) =>
              const NoTransitionPage(child: SettingsScreen())),
      ],
    ),
    GoRoute(
      path: '/player',
      pageBuilder: (ctx, state) => CustomTransitionPage(
        child: const PlayerScreen(),
        transitionsBuilder: (ctx, anim, _, child) => SlideTransition(
          position: Tween<Offset>(
                  begin: const Offset(0, 1), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeOutCubic))
              .animate(anim),
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: '/playlist/:id',
      pageBuilder: (ctx, state) => MaterialPage(
        child: PlaylistScreen(
            playlistId: state.pathParameters['id'] ?? ''),
      ),
    ),
    GoRoute(
      path: '/artist/:id',
      pageBuilder: (ctx, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return MaterialPage(
          child: ArtistScreen(
            artistId:   state.pathParameters['id'] ?? '',
            artistName: extra['artistName'] as String?,
            coverUrl:   extra['coverUrl']   as String?,
          ),
        );
      },
    ),
    GoRoute(
      path: '/album/:id',
      pageBuilder: (ctx, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return MaterialPage(
          child: AlbumScreen(
            albumId:    state.pathParameters['id'] ?? '',
            albumName:  extra['albumName']  as String? ?? 'Album',
            artworkUrl: extra['artworkUrl'] as String?,
            artistName: extra['artistName'] as String?,
          ),
        );
      },
    ),
  ],
));
