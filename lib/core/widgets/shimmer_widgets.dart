import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Wraps children in a themed shimmer effect.
class AppShimmer extends StatelessWidget {
  const AppShimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final base = context.isDark
        ? context.colors.surfaceContainerHighest
        : const Color(0xFFE6E8EB);
    final highlight = context.isDark
        ? context.colors.surfaceContainerHigh
        : const Color(0xFFF4F5F7);
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: child,
    );
  }
}

/// A plain shimmer block.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.radius,
  });

  final double? width;
  final double? height;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius ?? AppRadius.rMd,
      ),
    );
  }
}

/// Placeholder grid used while products load.
class ProductGridShimmer extends StatelessWidget {
  const ProductGridShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.68,
        ),
        itemBuilder: (_, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: ShimmerBox(radius: AppRadius.rLg)),
            SizedBox(height: 8.h),
            ShimmerBox(width: 120.w, height: 12.h),
            SizedBox(height: 6.h),
            ShimmerBox(width: 70.w, height: 12.h),
          ],
        ),
      ),
    );
  }
}

/// Horizontal list shimmer for home sections.
class HorizontalListShimmer extends StatelessWidget {
  const HorizontalListShimmer({super.key, this.height = 220});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      child: AppShimmer(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          separatorBuilder: (_, _) => SizedBox(width: AppSpacing.md),
          itemBuilder: (_, _) => ShimmerBox(width: 150.w, radius: AppRadius.rLg),
        ),
      ),
    );
  }
}
