import 'package:flutter/material.dart';

/// HexTunes AMOLED Cyberpunk colour palette.
abstract class AppColors {
  static const Color background       = Color(0xFF050508);
  static const Color backgroundCard   = Color(0xFF0D0D14);
  static const Color backgroundModal  = Color(0xFF0A0A10);
  static const Color surface          = Color(0xFF12121C);
  static const Color surfaceVariant   = Color(0xFF1A1A28);

  static const Color primary          = Color(0xFF9B59F5);
  static const Color primaryLight     = Color(0xFFBB82FF);
  static const Color primaryDark      = Color(0xFF7A3FD4);
  static const Color primaryContainer = Color(0xFF1E1030);

  static const Color accent           = Color(0xFF5E9AFF);
  static const Color accentLight      = Color(0xFF8DBAFF);
  static const Color accentDark       = Color(0xFF3B7AE0);

  static const Color textPrimary      = Color(0xFFEEE8FF);
  static const Color textSecondary    = Color(0xFF9B8CC0);
  static const Color textHint         = Color(0xFF5A5070);
  static const Color textOnPrimary    = Color(0xFFFFFFFF);

  static const Color success          = Color(0xFF50DC64);
  static const Color warning          = Color(0xFFFFC852);
  static const Color error            = Color(0xFFFF5C5C);

  static const List<Color> gradientPurpleBlue = [Color(0xFF9B59F5), Color(0xFF5E9AFF)];
  static const List<Color> gradientDarkPurple = [Color(0xFF1E1030), Color(0xFF050508)];
  static const List<Color> gradientNeonGlow   = [Color(0xFF7A3FD4), Color(0xFF3B7AE0)];

  static const Color miniPlayerBg = Color(0xFF0E0E1A);
  static const Color glassWhite   = Color(0x1AFFFFFF);
  static const Color glassBorder  = Color(0x33FFFFFF);
  static const Color divider      = Color(0xFF1E1E2E);

  static BoxShadow get purpleGlow => BoxShadow(
    color: primary.withOpacity(0.4), blurRadius: 20, spreadRadius: 2,
  );
  static BoxShadow get blueGlow => BoxShadow(
    color: accent.withOpacity(0.35), blurRadius: 18, spreadRadius: 1,
  );
}
