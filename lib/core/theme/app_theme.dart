import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTheme {
  static TextTheme get _textTheme => GoogleFonts.outfitTextTheme(
    const TextTheme(
      displayLarge:   TextStyle(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -1),
      displayMedium:  TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -.8),
      displaySmall:   TextStyle(fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: -.5),
      headlineLarge:  TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      headlineSmall:  TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      titleLarge:     TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      titleMedium:    TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      titleSmall:     TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      bodyLarge:      TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
      bodyMedium:     TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall:      TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      labelLarge:     TextStyle(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: .5),
      labelMedium:    TextStyle(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: .4),
      labelSmall:     TextStyle(fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: .3),
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness:   Brightness.dark,
    colorScheme:  const ColorScheme.dark(
      primary:          AppColors.primary,
      onPrimary:        AppColors.textOnPrimary,
      primaryContainer: AppColors.primaryContainer,
      secondary:        AppColors.accent,
      onSecondary:      AppColors.textOnPrimary,
      surface:          AppColors.surface,
      onSurface:        AppColors.textPrimary,
      error:            AppColors.error,
      onError:          AppColors.textOnPrimary,
      outline:          AppColors.divider,
    ),
    scaffoldBackgroundColor: AppColors.background,
    canvasColor:             AppColors.backgroundCard,
    cardColor:               AppColors.backgroundCard,
    dividerColor:            AppColors.divider,
    textTheme: _textTheme.apply(
      bodyColor:    AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 22),
    appBarTheme: AppBarTheme(
      backgroundColor:  AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: GoogleFonts.outfit(
        color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor:      AppColors.backgroundCard,
      selectedItemColor:    AppColors.primary,
      unselectedItemColor:  AppColors.textHint,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor:   AppColors.primary,
      inactiveTrackColor: AppColors.surfaceVariant,
      thumbColor:         AppColors.primaryLight,
      overlayColor:       AppColors.primary.withOpacity(0.2),
      trackHeight:        3,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled:       true,
      fillColor:    AppColors.surface,
      hintStyle:    const TextStyle(color: AppColors.textHint),
      border:          OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.divider)),
      enabledBorder:   OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.divider)),
      focusedBorder:   OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
