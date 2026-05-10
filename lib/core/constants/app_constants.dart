abstract class AppConstants {
  static const String appName    = 'HexTunes';
  static const String appTagline = 'Feel Every Beat';
  static const String appVersion = '1.0.0';

  static const String boxSettings    = 'settings';
  static const String boxLikedSongs  = 'liked_songs';
  static const String boxRecentSongs = 'recent_songs';
  static const String boxDownloads   = 'downloads';
  static const String boxPlaylists   = 'playlists';

  static const int trendingLimit    = 20;
  static const int searchLimit      = 20;
  static const int recentSongsLimit = 50;
  static const int maxQueueSize     = 200;

  static const Duration cacheExpiry = Duration(hours: 6);
  static const Duration crossfadeDuration = Duration(milliseconds: 300);

  static const List<int> sleepTimerOptions = [5, 10, 15, 30, 45, 60];

  static const Duration animFast   = Duration(milliseconds: 200);
  static const Duration animMedium = Duration(milliseconds: 350);
  static const Duration animSlow   = Duration(milliseconds: 500);

  static const double radiusSmall  = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge  = 16.0;
  static const double radiusXL     = 24.0;
  static const double radiusFull   = 100.0;

  static const double paddingXS = 4.0;
  static const double paddingS  = 8.0;
  static const double paddingM  = 16.0;
  static const double paddingL  = 24.0;
  static const double paddingXL = 32.0;

  static const double miniPlayerHeight = 72.0;
  static const double bottomNavHeight  = 64.0;
}
