// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (Deep Blue from logo)
  static const Color primary = Color(0xFF145995);
  static const Color primaryLight = Color(0xFFE6F0FA); // Very light blue for subtle backgrounds
  static const Color primaryDark = Color(0xFF0D3A63);
  static const Color primarySurface = Color(0xFFF0F7FD);
  
  // Background Colors
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color cardBackground = Colors.white;
  static const Color cardBackgroundMuted = Color(0xFFF1F5F9); // Slate 100
  static const Color overlayBackground = Color(0x66000000); // 40% black for dark overlays

  // Text Colors (high legibility, easy on the eyes)
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400
  static const Color textWhite = Colors.white;

  // Border Colors
  static const Color border = Color(0xFFE2E8F0); // Slate 200
  static const Color borderLight = Color(0xFFF1F5F9); // Slate 100

  // Status Colors (Enterprise refined)
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color successDark = Color(0xFF059669); // Emerald 600
  static const Color successLight = Color(0xFFECFDF5); // Emerald 50

  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color errorDark = Color(0xFFDC2626); // Red 600
  static const Color errorLight = Color(0xFFFEF2F2); // Red 50

  // Gold from logo lightning bolt/gear
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color warningDark = Color(0xFFD97706); // Amber 600
  static const Color warningLight = Color(0xFFFFFBEB); // Amber 50

  static const Color info = Color(0xFF3B82F6); // Blue 500
  static const Color infoDark = Color(0xFF2563EB); // Blue 600
  static const Color infoLight = Color(0xFFEFF6FF); // Blue 50

  // Secondary Data Visualisation Colors
  static const Color purple = Color(0xFF8B5CF6);
  static const Color purpleDark = Color(0xFF7C3AED);
  static const Color purpleLight = Color(0xFFF5F3FF);

  static const Color orange = Color(0xFFF97316);
  static const Color orangeDark = Color(0xFFEA580C);
  static const Color orangeLight = Color(0xFFFFF7ED);
  static const Color green = Color(0xFF22C55E);
  static const Color teal = Color(0xFF14B8A6);
  static const Color tealDark = Color(0xFF0D9488);
  static const Color tealLight = Color(0xFFF0FDFA);

  // Shadow Colors - Much softer and cleaner for enterprise UI
  static Color shadowLight = const Color(0xFF0F172A).withOpacity(0.03);
  static Color shadowMedium = const Color(0xFF0F172A).withOpacity(0.06);
  static Color shadowHeavy = const Color(0xFF0F172A).withOpacity(0.09);
  static Color primaryShadow = primary.withOpacity(0.12);
}

/// App-wide gradients derived from [AppColors] for consistent, soft visuals.
/// Gradients are toned down to look more professional and flat.
class AppGradients {
  AppGradients._();

  static const Alignment _begin = Alignment.topLeft;
  static const Alignment _end = Alignment.bottomRight;

  // Very subtle primary gradient for active elements
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primary, Color(0xFF1B6BAE)], // Slight shade difference
    begin: _begin,
    end: _end,
  );

  // Clean flat header gradient
  static const LinearGradient header = LinearGradient(
    colors: [AppColors.primaryDark, AppColors.primary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient success = LinearGradient(
    colors: [AppColors.success, Color(0xFF34D399)],
    begin: _begin,
    end: _end,
  );

  static const LinearGradient warning = LinearGradient(
    colors: [AppColors.warning, Color(0xFFFBBF24)],
    begin: _begin,
    end: _end,
  );

  static const LinearGradient danger = LinearGradient(
    colors: [AppColors.error, Color(0xFFF87171)],
    begin: _begin,
    end: _end,
  );

  static const LinearGradient info = LinearGradient(
    colors: [AppColors.info, Color(0xFF60A5FA)],
    begin: _begin,
    end: _end,
  );

  static const LinearGradient purple = LinearGradient(
    colors: [AppColors.purple, Color(0xFFA78BFA)],
    begin: _begin,
    end: _end,
  );

  static const LinearGradient orange = LinearGradient(
    colors: [AppColors.orange, Color(0xFFFB923C)],
    begin: _begin,
    end: _end,
  );

  static const LinearGradient teal = LinearGradient(
    colors: [AppColors.teal, Color(0xFF2DD4BF)],
    begin: _begin,
    end: _end,
  );

  /// Soft tinted header strip for dashboard cards.
  static LinearGradient cardHeaderTint(Color accent) => LinearGradient(
    colors: [accent.withOpacity(0.04), accent.withOpacity(0.01)],
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
  );

  /// Soft surface banner (success / alert).
  static LinearGradient surfaceBanner({required bool isAlert}) => LinearGradient(
    colors: isAlert
        ? [AppColors.errorLight, Colors.white]
        : [AppColors.successLight, Colors.white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

// lib/core/theme/app_text_styles.dart

// lib/core/theme/app_dimensions.dart

