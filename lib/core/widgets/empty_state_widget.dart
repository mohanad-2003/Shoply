import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui_kit/core/extensions/context_extensions.dart';
import 'package:ui_kit/core/theme/app_spacing.dart';

import 'app_button.dart';

/// Friendly empty-state placeholder (e.g. empty cart).
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48.r, color: context.colors.primary),
            ),
            SizedBox(height: AppSpacing.vXl),
            Text(
              title,
              style: context.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              SizedBox(height: AppSpacing.vSm),
              Text(
                message!,
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: AppSpacing.vXl),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                expand: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
