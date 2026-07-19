import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../domain/entities/category_entity.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key, required this.categories});

  final List<CategoryEntity> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => SizedBox(width: 16.w),
        itemBuilder: (_, i) => _CategoryChip(category: categories[i]),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});

  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
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
              category.iconPath,
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
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
