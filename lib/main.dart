import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:audio_service/audio_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'app.dart';
import 'services/audio/audio_handler.dart';
import 'providers/audio_provider.dart';

late HexAudioHandler audioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF050508),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Hive.initFlutter();
  for (final b in ['settings','liked_songs','recent_songs','downloads','playlists']) {
    await Hive.openBox(b);
  }
  await [Permission.storage, Permission.audio].request();

  audioHandler = await AudioService.init(
    builder: () => HexAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.hextunes.app.audio',
      androidNotificationChannelName: 'HexTunes',
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidShowNotificationBadge: true,
      androidStopForegroundOnPause: true,
      notificationColor: Color(0xFF9B59F5),
    ),
  );

  runApp(ProviderScope(
    overrides: [audioHandlerProvider.overrideWithValue(audioHandler)],
    child: const HexTunesApp(),
  ));
}
