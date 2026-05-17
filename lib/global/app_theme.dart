import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';

/// Standardized Enterprise Theme definitions
class AppTheme {
  /// Custom ThemeData for modern corporate styling
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.almaraiTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
          bodyMedium: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: AppDimensions.elevationNone,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: AppDimensions.elevationS,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: AppDimensions.elevationNone,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXL,
            vertical: AppDimensions.paddingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
        ),
      ),
    );
  }

  /// Premium dark mode surface and dashboard theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
      textTheme: GoogleFonts.almaraiTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.white54),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E293B), // Slate 800
        elevation: AppDimensions.elevationS,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          side: const BorderSide(
            color: Color(0xFF334155),
            width: 1,
          ), // Slate 700
        ),
      ),
    );
  }
}
