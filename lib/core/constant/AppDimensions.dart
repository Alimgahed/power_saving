// // lib/core/theme/app_colors.dart
// import 'package:flutter/material.dart';

// class AppColors {
//   // Primary Colors
//   static const Color primary = Color(0xFF1E40AF);
//   static const Color primaryLight = Color(0xFF3B82F6);
//   static const Color primaryDark = Color(0xFF1E3A8A);

//   // Background Colors
//   static const Color background = Color(0xFFF8FAFC);
//   static const Color cardBackground = Colors.white;
//   static const Color overlayBackground = Color(0x1AFFFFFF);

//   // Text Colors
//   static const Color textPrimary = Color(0xFF1F2937);
//   static const Color textSecondary = Color(0xFF6B7280);
//   static const Color textWhite = Colors.white;

//   // Border Colors
//   static const Color border = Color(0xFFE5E7EB);
//   static const Color borderLight = Color(0xFFF3F4F6);

//   // Status Colors
//   static const Color success = Color(0xFF10B981);
//   static const Color error = Color(0xFFEF4444);
//   static const Color warning = Color(0xFFF59E0B);
//   static const Color info = Color(0xFF3B82F6);

//   // Shadow Colors
//   static Color shadowLight = Colors.black.withOpacity(0.04);
//   static Color shadowMedium = Colors.black.withOpacity(0.08);
// }

// // lib/core/theme/app_text_styles.dart
// class AppTextStyles {
//   // Headings
//   static const TextStyle h1 = TextStyle(
//     fontSize: 24,
//     fontWeight: FontWeight.bold,
//     color: AppColors.textPrimary,
//   );

//   static const TextStyle h2 = TextStyle(
//     fontSize: 20,
//     fontWeight: FontWeight.bold,
//     color: AppColors.textPrimary,
//   );

//   static const TextStyle h3 = TextStyle(
//     fontSize: 18,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textPrimary,
//   );

//   // Body Text
//   static const TextStyle bodyLarge = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.normal,
//     color: AppColors.textPrimary,
//   );

//   static const TextStyle bodyMedium = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.normal,
//     color: AppColors.textPrimary,
//   );

//   static const TextStyle bodySmall = TextStyle(
//     fontSize: 12,
//     fontWeight: FontWeight.normal,
//     color: AppColors.textSecondary,
//   );

//   // Button Text
//   static const TextStyle button = TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textWhite,
//   );

//   // AppBar Text
//   static const TextStyle appBarTitle = TextStyle(
//     fontSize: 18,
//     fontWeight: FontWeight.w600,
//     color: AppColors.textWhite,
//   );
// }

// lib/core/theme/app_dimensions.dart
class AppDimensions {
  // Padding & Margins
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 12.0;
  static const double paddingL = 16.0;
  static const double paddingXL = 20.0;
  static const double paddingXXL = 24.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;

  // Icon Sizes
  static const double iconS = 16.0;
  static const double iconM = 20.0;
  static const double iconL = 24.0;

  // Elevation
  static const double elevationNone = 0.0;
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
}
