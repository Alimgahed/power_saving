import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_saving/core/constant/colors.dart';
import 'package:power_saving/core/constant/AppDimensions.dart';
import 'package:power_saving/core/constant/styles.dart';

/// Standardized Enterprise Theme definitions
class AppTheme {
  /// Custom ThemeData for modern corporate styling
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.info,
        surface: Colors.white,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.almaraiTextTheme(
        TextTheme(
          displayLarge: AppTextStyles.h1,
          titleLarge: AppTextStyles.h3,
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodyMedium,
          bodySmall: AppTextStyles.bodySmall,
          labelLarge: AppTextStyles.button,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: AppDimensions.elevationNone,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: AppDimensions.elevationNone, // Flat cards for enterprise
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: AppDimensions.elevationNone, // Flat buttons
          textStyle: AppTextStyles.button,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
            vertical: AppDimensions.paddingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.border),
          textStyle: AppTextStyles.button,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
            vertical: AppDimensions.paddingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.button,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingM,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
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
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.info,
        surface: Color(0xFF1E293B), // Slate 800
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.almaraiTextTheme(
        TextTheme(
          displayLarge: AppTextStyles.h1.copyWith(color: Colors.white),
          titleLarge: AppTextStyles.h3.copyWith(color: Colors.white),
          bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Colors.white70),
          bodyMedium: AppTextStyles.bodyMedium.copyWith(color: Colors.white54),
          bodySmall: AppTextStyles.bodySmall.copyWith(color: Colors.white38),
          labelLarge: AppTextStyles.button.copyWith(color: Colors.white),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: AppDimensions.elevationNone,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E293B), // Slate 800
        elevation: AppDimensions.elevationNone,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          side: const BorderSide(
            color: Color(0xFF334155), // Slate 700
            width: 1,
          ), 
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF334155), // Slate 700
        thickness: 1,
        space: 1,
      ),
    );
  }
}
