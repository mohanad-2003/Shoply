import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../models/checkout_models.dart';

/// Renders a shipping address. When [selected] is provided the card gains a
/// primary-tinted border and a trailing radio — used both in the checkout
/// summary and inside the address picker sheet.
class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    required this.address,
    this.selected,
    this.onTap,
  });

  final ShippingAddress address;
  final bool? selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isSelected = selected ?? false;
    final selectable = selected != null;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.rLg,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.rLg,
          border: Border.all(
            color: isSelected ? colors.primary : colors.outlineVariant,
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.10),
                borderRadius: AppRadius.rMd,
              ),
              child: Icon(
                Icons.location_on_rounded,
                color: colors.primary,
                size: 22.r,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(address.recipient, style: context.textTheme.titleSmall),
                      SizedBox(width: AppSpacing.sm),
                      _LabelChip(text: address.label),
                    ],
                  ),
                  SizedBox(height: AppSpacing.vXs),
                  Text(
                    '${address.line}\n${address.city}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: AppSpacing.vXs),
                  Text(
                    address.phone,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (selectable)
              Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isSelected ? colors.primary : colors.outline,
                size: 22.r,
              ),
          ],
        ),
      ),
    );
  }
}

class _LabelChip extends StatelessWidget {
  const _LabelChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2.h),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: AppRadius.rSm,
      ),
      child: Text(
        text,
        style: context.textTheme.labelSmall?.copyWith(
          color: colors.onSecondaryContainer,
        ),
      ),
    );
  }
}
