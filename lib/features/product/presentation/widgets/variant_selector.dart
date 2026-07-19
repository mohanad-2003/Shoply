import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class VariantSelector extends StatelessWidget {
  const VariantSelector({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.textTheme.titleMedium),
        SizedBox(height: AppSpacing.vMd),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: options.map((option) {
            final isSelected = option == selected;
            return GestureDetector(
              onTap: () => onSelected(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(
                    horizontal: 18.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.colors.primary
                      : context.colors.surfaceContainerHighest,
                  borderRadius: AppRadius.rMd,
                  border: Border.all(
                    color: isSelected
                        ? context.colors.primary
                        : context.colors.outlineVariant,
                  ),
                ),
                child: Text(
                  option,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: isSelected
                        ? context.colors.onPrimary
                        : context.colors.onSurface,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
