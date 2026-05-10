import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    final tt   = GoogleFonts.interTextTheme(base.textTheme);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary:     AppColors.primary,
        secondary:   AppColors.secondary,
        surface:     AppColors.surface,
        background:  AppColors.background,
        onPrimary:   Colors.white,
        onSecondary: Colors.white,
        onSurface:   AppColors.textPrimary,
        onBackground:AppColors.textPrimary,
        error:       AppColors.error,
      ),
      textTheme: tt.copyWith(
        displayLarge: tt.displayLarge?.copyWith(
          color: AppColors.textPrimary, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        titleLarge: tt.titleLarge?.copyWith(
          color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        bodyLarge:  tt.bodyLarge?.copyWith(color: AppColors.textPrimary),
        bodyMedium: tt.bodyMedium?.copyWith(color: AppColors.textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent, elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary, inactiveTrackColor: AppColors.glassBg,
        thumbColor: AppColors.primaryLt, overlayColor: AppColors.primaryGlow,
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      dividerColor: AppColors.divider, cardColor: AppColors.card,
    );
  }
}
