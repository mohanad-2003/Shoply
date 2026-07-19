import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive typography scale (all sizes in `.sp`). Colours are intentionally
/// omitted so styles inherit the active [ColorScheme] via the theme.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get displayLarge => TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle get headingLarge => TextStyle(
        fontSize: 26.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        height: 1.25,
      );

  static TextStyle get headingMedium => TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  static TextStyle get titleLarge => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        height: 1.35,
      );

  static TextStyle get titleMedium => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get bodyLarge => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get bodySmall => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        height: 1.45,
      );

  static TextStyle get label => TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      );

  static TextStyle get button => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      );

  static TextStyle get caption => TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      );

  /// Builds a Material 3 [TextTheme] from the scale above.
  static TextTheme textTheme(Color primary, Color secondary) => TextTheme(
        displayLarge: displayLarge.copyWith(color: primary),
        headlineLarge: headingLarge.copyWith(color: primary),
        headlineMedium: headingMedium.copyWith(color: primary),
        titleLarge: titleLarge.copyWith(color: primary),
        titleMedium: titleMedium.copyWith(color: primary),
        bodyLarge: bodyLarge.copyWith(color: primary),
        bodyMedium: bodyMedium.copyWith(color: secondary),
        bodySmall: bodySmall.copyWith(color: secondary),
        labelLarge: button.copyWith(color: primary),
        labelMedium: label.copyWith(color: secondary),
        labelSmall: caption.copyWith(color: secondary),
      );
}
