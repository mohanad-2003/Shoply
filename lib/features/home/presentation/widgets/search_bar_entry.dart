import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_radius.dart';

/// Tapping opens the full search screen.
class SearchBarEntry extends StatelessWidget {
  const SearchBarEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(RouteNames.nSearch),
      child: Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHighest,
          borderRadius: AppRadius.rMd,
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded,
                color: context.colors.onSurfaceVariant, size: 22.r),
            SizedBox(width: 12.w),
            Text(
              context.l10n.searchHint,
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
