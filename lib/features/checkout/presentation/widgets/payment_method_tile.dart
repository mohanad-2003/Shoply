import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../models/checkout_models.dart';

/// A selectable payment method row with a brand logo (or fallback icon),
/// title/subtitle and a trailing radio indicator.
class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({
    super.key,
    required this.method,
    required this.selected,
    this.onTap,
  });

  final PaymentMethodOption method;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.rLg,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.rLg,
          border: Border.all(
            color: selected ? colors.primary : colors.outlineVariant,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            _Leading(method: method),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(method.title, style: context.textTheme.titleSmall),
                  SizedBox(height: 2.h),
                  Text(
                    method.subtitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? colors.primary : colors.outline,
              size: 22.r,
            ),
          ],
        ),
      ),
    );
  }
}

class _Leading extends StatelessWidget {
  const _Leading({required this.method});

  final PaymentMethodOption method;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 44.r,
      height: 44.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: AppRadius.rMd,
      ),
      child: method.assetPath != null
          ? Padding(
              padding: EdgeInsets.all(AppSpacing.xs),
              child: Image.asset(
                method.assetPath!,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => _fallbackIcon(colors),
              ),
            )
          : _fallbackIcon(colors),
    );
  }

  Widget _fallbackIcon(ColorScheme colors) {
    final icon = switch (method.kind) {
      PaymentKind.cashOnDelivery => Icons.payments_rounded,
      PaymentKind.paypal => Icons.account_balance_wallet_rounded,
      PaymentKind.card => Icons.credit_card_rounded,
    };
    return Icon(icon, color: colors.primary, size: 22.r);
  }
}
