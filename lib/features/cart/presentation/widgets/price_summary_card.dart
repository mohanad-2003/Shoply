import 'package:flutter/material.dart';
import 'package:ui_kit/core/extensions/context_extensions.dart';
import 'package:ui_kit/core/extensions/num_extensions.dart';
import 'package:ui_kit/core/theme/app_spacing.dart';
import 'package:ui_kit/features/cart/domain/entities/cart_summary_entity.dart';

class PriceSummaryCard extends StatelessWidget {
  const PriceSummaryCard({super.key, required this.summary});

  final CartSummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        _row(context, l10n.subtotal, summary.subtotal.toPrice()),
        if (summary.discount > 0)
          _row(context, l10n.discount, '-${summary.discount.toPrice()}',
              highlight: true),
        _row(
          context,
          l10n.shipping,
          summary.shipping == 0 ? l10n.free : summary.shipping.toPrice(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.vMd),
          child: const Divider(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.total, style: context.textTheme.titleLarge),
            Text(summary.total.toPrice(),
                style: context.textTheme.headlineMedium
                    ?.copyWith(color: context.colors.primary)),
          ],
        ),
      ],
    );
  }

  Widget _row(BuildContext context, String label, String value,
      {bool highlight = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.vXs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.textTheme.bodyMedium),
          Text(
            value,
            style: context.textTheme.titleMedium?.copyWith(
              color: highlight ? context.colors.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}
