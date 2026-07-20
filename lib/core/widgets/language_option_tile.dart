import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Selectable language card used by the Language Select screen. Shows a leading
/// glyph, the language name (+ optional native subtitle) and a check when
/// selected. Height is driven by content, never tied to a `.w` width.
class LanguageOptionTile extends StatelessWidget {
  const LanguageOptionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.glyph,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String glyph;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.rLg,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.vLg,
        ),
        decoration: BoxDecoration(
          color: selected
              ? primary.withValues(alpha: 0.08)
              : context.colors.surface,
          borderRadius: AppRadius.rLg,
          border: Border.all(
            color: selected ? primary : context.colors.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerHighest,
                borderRadius: AppRadius.rMd,
              ),
              child: Text(glyph, style: TextStyle(fontSize: 24.sp)),
            ),
            SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: context.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            AnimatedScale(
              scale: selected ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.check_circle_rounded, color: primary, size: 24.r),
            ),
          ],
        ),
      ),
    );
  }
}
