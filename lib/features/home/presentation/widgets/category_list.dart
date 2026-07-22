import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/staggered_reveal.dart';
import '../../domain/entities/category_entity.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key, required this.categories, this.onTap});

  final List<CategoryEntity> categories;
  final void Function(CategoryEntity)? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => SizedBox(width: 16.w),
        itemBuilder: (_, i) => StaggeredReveal(
          delay: Duration(milliseconds: i * 60),
          offset: const Offset(0.2, 0),
          child: _CategoryChip(
            category: categories[i],
            onTap: onTap == null ? null : () => onTap!(categories[i]),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatefulWidget {
  const _CategoryChip({required this.category, this.onTap});

  final CategoryEntity category;
  final VoidCallback? onTap;

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (mounted) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1,
        duration: const Duration(milliseconds: 120),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64.r,
                height: 64.r,
                decoration: BoxDecoration(
                  color: context.colors.surfaceContainerHighest,
                  borderRadius: AppRadius.rLg,
                ),
                padding: EdgeInsets.all(14.r),
                child: Image.asset(
                  widget.category.iconPath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => Icon(
                    Icons.category_outlined,
                    color: context.colors.primary,
                    size: 28.r,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                widget.category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
