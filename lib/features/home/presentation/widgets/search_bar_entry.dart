import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/custom_snackbar.dart';

/// Non-editable search field. `/search` is reserved for a later phase, so this
/// surfaces a "coming soon" hint for now.
class SearchBarEntry extends StatelessWidget {
  const SearchBarEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppSnackbar.show(context, message: context.l10n.comingSoon),
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
