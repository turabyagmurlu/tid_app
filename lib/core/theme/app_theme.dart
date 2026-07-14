import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

/// Açık/Koyu tema. Dost, yuvarlak (claymorphism esintili) tasarım:
/// Nunito tipografi, yumuşak köşeler, kademeli yüzeyler, yüksek kontrast.
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
      surface: isDark ? AppColors.darkSurface : AppColors.lightSurface,
    );

    final Color onBg =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    final Color cardColor =
        isDark ? AppColors.darkSurfaceHigh : AppColors.lightSurface;

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      cardColor: cardColor,
      textTheme: _textTheme(onBg),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 21,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: isDark ? 0 : 1.5,
        shadowColor: AppColors.primary.withOpacity(0.15),
        margin: const EdgeInsets.symmetric(vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isDark
              ? BorderSide(color: Colors.white.withOpacity(0.06))
              : BorderSide.none,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 52),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.nunito(
              fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
          textStyle: GoogleFonts.nunito(
              fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        side: BorderSide(color: AppColors.primary.withOpacity(0.25)),
      ),
      listTileTheme: const ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? AppColors.darkSurfaceHigh
            : AppColors.primary.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: onBg.withOpacity(0.08),
        thickness: 1,
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColors.primary),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryDark,
        contentTextStyle: GoogleFonts.nunito(
            fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      focusColor: AppColors.accent,
    );

    return base;
  }

  static TextTheme _textTheme(Color onBg) {
    return TextTheme(
      headlineSmall: GoogleFonts.nunito(
          fontSize: 24, fontWeight: FontWeight.w800, color: onBg),
      titleLarge: GoogleFonts.nunito(
          fontSize: 20, fontWeight: FontWeight.w800, color: onBg),
      titleMedium: GoogleFonts.nunito(
          fontSize: 18, fontWeight: FontWeight.w700, color: onBg),
      bodyLarge: GoogleFonts.nunito(fontSize: 17, height: 1.45, color: onBg),
      bodyMedium: GoogleFonts.nunito(fontSize: 15, height: 1.45, color: onBg),
      bodySmall: GoogleFonts.nunito(
          fontSize: 13, color: onBg.withOpacity(0.75)),
      labelLarge: GoogleFonts.nunito(
          fontSize: 16, fontWeight: FontWeight.w700, color: onBg),
    );
  }
}
