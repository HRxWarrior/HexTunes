import 'package:flutter/material.dart';

class AppColors {
  static const Color background  = Color(0xFF050508);
  static const Color surface     = Color(0xFF0D0D18);
  static const Color surfaceVar  = Color(0xFF13131F);
  static const Color card        = Color(0xFF1A1A2E);

  static const Color primary     = Color(0xFF9B59F5);
  static const Color primaryLt   = Color(0xFFB87EFF);
  static const Color primaryGlow = Color(0x559B59F5);
  static const Color secondary   = Color(0xFF4ECEFF);

  static const LinearGradient neonGrad = LinearGradient(
    colors: [Color(0xFF9B59F5), Color(0xFF4ECEFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3CC);
  static const Color textMuted     = Color(0xFF5A5A7A);

  static const Color glassBg     = Color(0x1A9B59F5);
  static const Color glassBorder = Color(0x33B87EFF);
  static const Color glassWhite  = Color(0x0DFFFFFF);

  static const Color error   = Color(0xFFFF4B6E);
  static const Color success = Color(0xFF00E5CC);
  static const Color navBg   = Color(0xFF080810);
  static const Color divider = Color(0xFF1E1E30);
}
