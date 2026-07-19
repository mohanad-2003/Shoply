import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_radius.dart';

/// A compact "- n +" stepper used in product details and the cart.
class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
  });

  final int quantity;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: AppRadius.rPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(context, Icons.remove_rounded,
              quantity > min ? () => onChanged(quantity - 1) : null),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text('$quantity', style: context.textTheme.titleMedium),
          ),
          _btn(context, Icons.add_rounded,
              quantity < max ? () => onChanged(quantity + 1) : null),
        ],
      ),
    );
  }

  Widget _btn(BuildContext context, IconData icon, VoidCallback? onTap) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.rPill,
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: Icon(
          icon,
          size: 18.r,
          color: enabled
              ? context.colors.onSurface
              : context.colors.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
