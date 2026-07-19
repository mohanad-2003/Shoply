import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/promo_code_entity.dart';

class PromoCodeInput extends StatefulWidget {
  const PromoCodeInput({
    super.key,
    required this.applied,
    required this.isApplying,
    required this.hasError,
    required this.onApply,
    required this.onRemove,
  });

  final PromoCodeEntity? applied;
  final bool isApplying;
  final bool hasError;
  final ValueChanged<String> onApply;
  final VoidCallback onRemove;

  @override
  State<PromoCodeInput> createState() => _PromoCodeInputState();
}

class _PromoCodeInputState extends State<PromoCodeInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (widget.applied != null) {
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.12),
          borderRadius: AppRadius.rMd,
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle_rounded,
                color: AppColors.success, size: 20.r),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                '${widget.applied!.code} (-${widget.applied!.discountPercent.toInt()}%)',
                style: context.textTheme.titleMedium,
              ),
            ),
            TextButton(
              onPressed: widget.onRemove,
              child: Text(l10n.removeItem),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(
              hintText: l10n.promoCode,
              prefixIcon: const Icon(Icons.local_offer_outlined),
              errorText: widget.hasError ? l10n.invalidPromo : null,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.md),
        SizedBox(
          height: 54.h,
          child: ElevatedButton(
            onPressed: widget.isApplying
                ? null
                : () => widget.onApply(_controller.text),
            child: widget.isApplying
                ? SizedBox(
                    width: 18.r,
                    height: 18.r,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.apply),
          ),
        ),
      ],
    );
  }
}
