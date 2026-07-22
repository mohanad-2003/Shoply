import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';

/// Celebratory confirmation shown in a bottom sheet once an order is placed.
class OrderSuccessSheet extends StatefulWidget {
  const OrderSuccessSheet({
    super.key,
    required this.orderNumber,
    required this.onContinue,
  });

  final String orderNumber;
  final VoidCallback onContinue;

  @override
  State<OrderSuccessSheet> createState() => _OrderSuccessSheetState();
}

class _OrderSuccessSheetState extends State<OrderSuccessSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..forward();

  late final Animation<double> _scale = Tween<double>(begin: 0.4, end: 1).animate(
    CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: _scale,
          child: Container(
            width: 96.r,
            height: 96.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success.withValues(alpha: 0.12),
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 60.r,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.vXl),
        Text(l10n.orderPlacedTitle, style: context.textTheme.headlineSmall),
        SizedBox(height: AppSpacing.vSm),
        Text(
          l10n.orderPlacedBody,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        SizedBox(height: AppSpacing.vLg),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerHighest,
            borderRadius: AppRadius.rMd,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${l10n.orderNumber}: ',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              Text(
                widget.orderNumber,
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.vXl),
        AppButton(
          label: l10n.continueShopping,
          icon: Icons.storefront_rounded,
          onPressed: widget.onContinue,
        ),
      ],
    );
  }
}
