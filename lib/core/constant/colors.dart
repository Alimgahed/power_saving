// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF1E40AF);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1E3A8A);
  static const Color primarySurface = Color(0xFFEFF6FF);

  // Background Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardBackground = Colors.white;
  static const Color cardBackgroundMuted = Color(0xFFF1F5F9);
  static const Color overlayBackground = Color(0x1AFFFFFF);

  // Text Colors (high legibility, easy on the eyes)
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textWhite = Colors.white;

  // Border Colors
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successDark = Color(0xFF059669);
  static const Color green = Colors.green;

  static const Color error = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFDC2626);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFD97706);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoDark = Color(0xFF0891B2);

  static const Color purple = Color(0xFF8B5CF6);
  static const Color purpleDark = Color(0xFF7C3AED);
  static const Color orange = Color(0xFFF97316);
  static const Color orangeDark = Color(0xFFEA580C);
  static const Color teal = Color(0xFF0D9488);
  static const Color tealDark = Color(0xFF0F766E);

  // Shadow Colors
  static Color shadowLight = Colors.black.withOpacity(0.04);
  static Color shadowMedium = Colors.black.withOpacity(0.08);
  static Color primaryShadow = primary.withOpacity(0.08);
}

/// App-wide gradients derived from [AppColors] for consistent, soft visuals.
class AppGradients {
  AppGradients._();

  static const Alignment _begin = Alignment.topLeft;
  static const Alignment _end = Alignment.bottomRight;

  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primaryDark, AppColors.primary, AppColors.primaryLight],
    begin: _begin,
    end: _end,
  );

  static const LinearGradient header = LinearGradient(
    colors: [AppColors.primaryDark, AppColors.primary, Color(0xFF2563EB)],
    begin: _begin,
    end: _end,
  );

  static const LinearGradient success = LinearGradient(
    colors: [AppColors.successDark, AppColors.success],
    begin: _begin,
    end: _end,
  );

  static const LinearGradient warning = LinearGradient(
    colors: [AppColors.warningDark, AppColors.warning],
    begin: _begin,
    end: _end,
  );

  static const LinearGradient danger = LinearGradient(
    colors: [AppColors.errorDark, AppColors.error],
    begin: _begin,
    end: _end,
  );

  static const LinearGradient info = LinearGradient(
    colors: [AppColors.infoDark, Color(0xFF06B6D4)],
    begin: _begin,
    end: _end,
  );

  static const LinearGradient purple = LinearGradient(
    colors: [AppColors.purpleDark, AppColors.purple],
    begin: _begin,
    end: _end,
  );

  static const LinearGradient orange = LinearGradient(
    colors: [AppColors.orangeDark, AppColors.orange],
    begin: _begin,
    end: _end,
  );

  static const LinearGradient teal = LinearGradient(
    colors: [AppColors.tealDark, AppColors.teal],
    begin: _begin,
    end: _end,
  );

  /// Soft tinted header strip for dashboard cards.
  static LinearGradient cardHeaderTint(Color accent) => LinearGradient(
    colors: [accent.withOpacity(0.06), accent.withOpacity(0.02)],
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
  );

  /// Soft surface banner (success / alert).
  static LinearGradient surfaceBanner({required bool isAlert}) => LinearGradient(
    colors: isAlert
        ? [const Color(0xFFFEF2F2), const Color(0xFFFFF5F5)]
        : [const Color(0xFFECFDF5), const Color(0xFFF0FDF4)],
    begin: _begin,
    end: _end,
  );
}

// lib/core/theme/app_text_styles.dart

// lib/core/theme/app_dimensions.dart
