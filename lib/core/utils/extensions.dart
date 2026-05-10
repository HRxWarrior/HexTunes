import 'package:flutter/material.dart';

extension DurationExt on Duration {
  String toTimeString() {
    final h = inHours;
    final m = inMinutes.remainder(60);
    final s = inSeconds.remainder(60);
    if (h > 0) {
      return '$h:${m.toString().padLeft(2,'0')}:${s.toString().padLeft(2,'0')}';
    }
    return '$m:${s.toString().padLeft(2,'0')}';
  }
}

extension StringExt on String {
  String truncate(int maxLength) =>
      length > maxLength ? '${substring(0, maxLength)}...' : this;
  String get capitalised =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

extension IterableExt<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

extension ColorExt on Color {
  Color darken([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
  Color lighten([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }
}

extension BuildContextExt on BuildContext {
  ThemeData   get theme   => Theme.of(this);
  TextTheme   get text    => Theme.of(this).textTheme;
  ColorScheme get colors  => Theme.of(this).colorScheme;
  double      get width   => MediaQuery.sizeOf(this).width;
  double      get height  => MediaQuery.sizeOf(this).height;
  EdgeInsets  get padding => MediaQuery.paddingOf(this);
}
