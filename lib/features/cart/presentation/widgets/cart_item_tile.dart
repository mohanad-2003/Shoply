import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/quantity_selector.dart';
import '../../domain/entities/cart_item_entity.dart';

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
          color: context.colors.surface,
          borderRadius: AppRadius.rLg,
          border: Border.all(color: context.colors.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              width: 84.r,
              height: 84.r,
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerHighest,
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
                  Text(item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleMedium),
                  SizedBox(height: 2.h),
                  Text(
                    [item.color, item.size]
                        .where((e) => e != null && e.isNotEmpty)
                        .join(' · '),
                    style: context.textTheme.bodySmall,
                  ),
                  SizedBox(height: AppSpacing.vSm),
                  Row(
                    children: [
                      Text(item.price.toPrice(),
                          style: context.textTheme.titleMedium
                              ?.copyWith(color: context.colors.primary)),
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
