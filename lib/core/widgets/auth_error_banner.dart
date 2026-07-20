import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/context_extensions.dart';
import '../localization/l10n_lookup.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Inline, dismissible error banner shown at the top of auth forms on failure.
/// Complements (does not replace) the transient [AppSnackbar]. Icon + tone vary
/// by failure category via the failure [l10nKey].
class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({
    super.key,
    required this.failureKey,
    required this.onDismiss,
  });

  /// Stable failure key (e.g. `noConnection`, `serverError`, `somethingWentWrong`).
  final String failureKey;
  final VoidCallback onDismiss;

  IconData get _icon => switch (failureKey) {
        'noConnection' => Icons.wifi_off_rounded,
        'serverError' => Icons.cloud_off_rounded,
        _ => Icons.error_outline_rounded,
      };

  Color get _tone => switch (failureKey) {
        'noConnection' => AppColors.warning,
        _ => AppColors.error,
      };

  @override
  Widget build(BuildContext context) {
    final tone = _tone;
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.vLg),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.vMd,
      ),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.10),
        borderRadius: AppRadius.rMd,
        border: Border.all(color: tone.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(_icon, color: tone, size: 20.r),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              tr(context, failureKey),
              style: context.textTheme.bodyMedium?.copyWith(color: tone),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          InkWell(
            onTap: onDismiss,
            borderRadius: AppRadius.rPill,
            child: Icon(Icons.close_rounded, color: tone, size: 18.r),
          ),
        ],
      ),
    );
  }
}
