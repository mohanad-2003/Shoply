import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/num_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/quantity_selector.dart';

/// Sticky bottom bar: quantity stepper + total price + Add to Cart.
class ProductActionsBar extends StatelessWidget {
  const ProductActionsBar({
    super.key,
    required this.quantity,
    required this.unitPrice,
    required this.inStock,
    required this.onQuantityChanged,
    required this.onAddToCart,
  });

  final int quantity;
  final double unitPrice;
  final bool inStock;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.md,
        AppSpacing.screenH,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.colors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            QuantitySelector(
              quantity: quantity,
              onChanged: onQuantityChanged,
            ),
            SizedBox(width: AppSpacing.lg),
            Expanded(
              child: AppButton(
                label:
                    '${context.l10n.addToCart}  •  ${(unitPrice * quantity).toPrice()}',
                icon: Icons.shopping_bag_outlined,
                onPressed: inStock ? onAddToCart : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
