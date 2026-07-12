import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Açık/Koyu tema. Erişilebilirlik için yüksek kontrast, okunaklı tipografi
/// ve geniş dokunma hedefleri esas alınmıştır.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _base(Brightness.light);
  static ThemeData get dark => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      textTheme: _textTheme(isDark),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(
            AppDimensions.minTouchTarget,
            AppDimensions.minTouchTarget,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      focusColor: AppColors.accent,
    );
  }

  static TextTheme _textTheme(bool isDark) {
    final Color onBg =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    return TextTheme(
      headlineSmall:
          TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: onBg),
      titleLarge:
          TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: onBg),
      titleMedium:
          TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: onBg),
      bodyLarge: TextStyle(fontSize: 17, height: 1.4, color: onBg),
      bodyMedium: TextStyle(fontSize: 15, height: 1.4, color: onBg),
      labelLarge:
          TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: onBg),
    );
  }
}
