abstract class ApiConstants {
  static const String audiusBaseUrl    = 'https://api.audius.co';
  static const String audiusApiVersion = '/v1';

  static const String audiusTrending       = '/tracks/trending';
  static const String audiusSearch         = '/tracks/search';
  static const String audiusStream         = '/tracks/{id}/stream';
  static const String audiusArtist         = '/users/{id}';
  static const String audiusArtistTracks   = '/users/{id}/tracks';

  static const String jamendoBaseUrl = 'https://api.jamendo.com/v3.0';
  static const String jamendoClientId = 'b6747d04';

  static const String jamendoTracks  = '/tracks/';
  static const String jamendoSearch  = '/tracks/';
  static const String jamendoArtists = '/artists/';
  static const String jamendoAlbums  = '/albums/';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 20);
}
