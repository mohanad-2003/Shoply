import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';

/// Compact, read-only summary of a single cart line shown in the checkout
/// order review (image, name, variant, quantity × price).
class OrderItemRow extends StatelessWidget {
  const OrderItemRow({super.key, required this.item});

  final CartItemEntity item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final variant = [item.color, item.size].whereType<String>().join(' · ');

    return Row(
      children: [
        ClipRRect(
          borderRadius: AppRadius.rMd,
          child: Container(
            width: 56.r,
            height: 56.r,
            color: colors.surfaceContainerHighest,
            child: Image.asset(
              item.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Icon(
                Icons.image_not_supported_outlined,
                color: colors.outline,
                size: 22.r,
              ),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleSmall,
              ),
              if (variant.isNotEmpty) ...[
                SizedBox(height: 2.h),
                Text(
                  variant,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
              SizedBox(height: 2.h),
              Text(
                '${item.quantity} × ${item.price.toPrice()}',
                style: context.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Text(
          item.lineTotal.toPrice(),
          style: context.textTheme.titleSmall?.copyWith(
            color: colors.primary,
          ),
        ),
      ],
    );
  }
}
