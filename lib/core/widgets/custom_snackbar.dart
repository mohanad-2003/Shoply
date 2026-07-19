import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

enum SnackType { success, error, info }

/// Helper for showing consistent, themed snackbars.
class AppSnackbar {
  AppSnackbar._();

  static void show(
    BuildContext context, {
    required String message,
    SnackType type = SnackType.info,
  }) {
    final (color, icon) = switch (type) {
      SnackType.success => (AppColors.success, Icons.check_circle_rounded),
      SnackType.error => (AppColors.error, Icons.error_rounded),
      SnackType.info => (
          Theme.of(context).colorScheme.inverseSurface,
          Icons.info_rounded
        ),
    };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.rMd),
          margin: EdgeInsets.all(16.w),
        ),
      );
  }

  static void success(BuildContext context, String message) =>
      show(context, message: message, type: SnackType.success);

  static void error(BuildContext context, String message) =>
      show(context, message: message, type: SnackType.error);
}
