import 'package:flutter/material.dart';

/// Central colour palette. All colours flow through [ColorScheme.fromSeed] in
/// `app_theme.dart`; these constants are the raw brand values + a few
/// semantic accents used directly by widgets.
class AppColors {
  AppColors._();

  /// Primary brand seed — a premium deep indigo.
  static const Color seed = Color(0xFF4C5FD5);

  static const Color primary = Color(0xFF4C5FD5);
  static const Color primaryDark = Color(0xFF8B9BFF);

  static const Color accent = Color(0xFFFF6B6B);
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF4B740);
  static const Color error = Color(0xFFE5484D);

  static const Color star = Color(0xFFFFB800);

  // Light surfaces.
  static const Color lightBackground = Color(0xFFF7F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFEFF1F5);
  static const Color lightTextPrimary = Color(0xFF1A1C1E);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  // Dark surfaces.
  static const Color darkBackground = Color(0xFF0F1115);
  static const Color darkSurface = Color(0xFF1A1D23);
  static const Color darkSurfaceVariant = Color(0xFF24272E);
  static const Color darkTextPrimary = Color(0xFFF5F6F8);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  static const Color shadow = Color(0x1A000000);
}
