import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 8pt spacing system. Values are responsive via ScreenUtil (`.w` / `.h`).
/// Use these instead of hardcoded pixel values anywhere in the app.
class AppSpacing {
  AppSpacing._();

  static double get xxs => 2.w;
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 12.w;
  static double get lg => 16.w;
  static double get xl => 20.w;
  static double get xxl => 24.w;
  static double get xxxl => 32.w;
  static double get huge => 48.w;

  // Vertical rhythm helpers.
  static double get vXs => 4.h;
  static double get vSm => 8.h;
  static double get vMd => 12.h;
  static double get vLg => 16.h;
  static double get vXl => 20.h;
  static double get vXxl => 24.h;
  static double get vXxxl => 32.h;

  /// Standard screen edge padding.
  static double get screenH => 20.w;
  static double get screenV => 16.h;
}
