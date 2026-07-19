import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.textTheme.displayLarge),
        SizedBox(height: AppSpacing.vSm),
        Text(
          subtitle,
          style: context.textTheme.bodyLarge
              ?.copyWith(color: context.colors.onSurfaceVariant),
        ),
        SizedBox(height: 28.h),
      ],
    );
  }
}
