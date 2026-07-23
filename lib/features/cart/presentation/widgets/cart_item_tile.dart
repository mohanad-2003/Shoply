import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui_kit/core/extensions/context_extensions.dart';
import 'package:ui_kit/core/extensions/num_extensions.dart';
import 'package:ui_kit/core/theme/app_colors.dart';
import 'package:ui_kit/core/theme/app_radius.dart';
import 'package:ui_kit/core/theme/app_spacing.dart';
import 'package:ui_kit/core/widgets/quantity_selector.dart';
import 'package:ui_kit/features/cart/domain/entities/cart_item_entity.dart';


class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemoved,
  });

  final CartItemEntity item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemoved;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final variants =
        [item.color, item.size].where((e) => e != null && e.isNotEmpty);

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemoved(),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: AppRadius.rLg,
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.rLg,
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 88.r,
              height: 88.r,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: AppRadius.rMd,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.image_not_supported_outlined),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.titleSmall,
                        ),
                      ),
                      _RemoveButton(onTap: onRemoved),
                    ],
                  ),
                  if (variants.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.vSm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      children: [
                        for (final v in variants) _VariantChip(label: v!),
                      ],
                    ),
                  ],
                  SizedBox(height: AppSpacing.vMd),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.lineTotal.toPrice(),
                            style: context.textTheme.titleMedium?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (item.quantity > 1)
                            Text(
                              '${item.price.toPrice()} ${context.l10n.each}',
                              style: context.textTheme.labelSmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      QuantitySelector(
                        quantity: item.quantity,
                        min: 1,
                        onChanged: onQuantityChanged,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.rPill,
      child: Padding(
        padding: EdgeInsets.all(4.r),
        child: Icon(
          Icons.close_rounded,
          size: 18.r,
          color: context.colors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _VariantChip extends StatelessWidget {
  const _VariantChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3.h),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: AppRadius.rSm,
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
