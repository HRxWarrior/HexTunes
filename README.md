# 🎵 HexTunes — Feel Every Beat

![HexTunes Banner](https://img.shields.io/badge/HexTunes-Feel%20Every%20Beat-9B59F5?style=for-the-badge&logo=music&logoColor=white)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Build APK](https://github.com/HRxWarrior/HexTunes/actions/workflows/build.yml/badge.svg)](https://github.com/HRxWarrior/HexTunes/actions)

A **futuristic AMOLED music streaming app** built with Flutter. Streams from Audius & Jamendo. Plays local music too.

## ✨ Features
- 🎨 AMOLED black + neon purple/blue glassmorphism UI
- 🎵 Audius API (primary) + Jamendo API (backup) streaming
- 🎛️ ExoPlayer via `audio_service` + `just_audio`
- 🔔 Background playback + lock screen / notification controls
- 🎧 Full player: queue, shuffle, repeat, sleep timer
- 🔍 Search songs & artists
- ❤️ Liked songs, playlists, recently played
- 📱 Local music scanner
- ⚡ Riverpod state management, Go Router navigation

## 🏗️ Architecture
```
lib/
├── core/           # Theme, router, utilities
├── models/         # Song, Artist, Playlist
├── services/       # Audius API, Jamendo API, AudioHandler
├── providers/      # Riverpod providers
├── features/       # Home, Search, Player, Library, Settings
└── widgets/        # Mini player, song tile, glassmorphism card
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.3.0
- Android Studio / VS Code
- Android device or emulator (API 21+)

### Run
```bash
git clone https://github.com/HRxWarrior/HexTunes.git
cd HexTunes
flutter pub get
flutter run
```

### Build Release APK
```bash
flutter build apk --release
# APK at: build/app/outputs/flutter-apk/app-release.apk
```

## 🤖 GitHub Actions
Push to `main` → APK auto-builds → Download from Actions artifacts.

## 🎨 Design
- Background: `#050508` (true AMOLED black)
- Primary: `#9B59F5` (neon purple)
- Accent: `#4ECEFF` (neon blue)
- Font: Inter via Google Fonts

## 📡 APIs
| Source | Usage |
|--------|-------|
| [Audius](https://audius.co) | Primary streaming (no key needed) |
| [Jamendo](https://developer.jamendo.com) | Backup streaming |
| Local scanner | `on_audio_query` for device music |

## 📄 License
MIT — Built with ❤️ using Flutter
