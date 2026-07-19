import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/context_extensions.dart';
import '../extensions/num_extensions.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import 'rating_stars.dart';

/// Shared product tile used by Home sections, related products and search.
/// Deliberately decoupled from any feature entity — takes primitives.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    this.originalPrice,
    this.rating = 0,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteToggle,
    this.width,
  });

  final String imagePath;
  final String title;
  final double price;
  final double? originalPrice;
  final double rating;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final hasDiscount = originalPrice != null && originalPrice! > price;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.colors.surfaceContainerHighest,
                        borderRadius: AppRadius.rLg,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(
                          Icons.image_not_supported_outlined,
                          color: context.colors.outline,
                          size: 32.r,
                        ),
                      ),
                    ),
                  ),
                  if (hasDiscount)
                    Positioned(
                      top: 8.r,
                      left: 8.r,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: AppRadius.rSm,
                        ),
                        child: Text(
                          '-${(((originalPrice! - price) / originalPrice!) * 100).round()}%',
                          style: context.textTheme.labelSmall
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 6.r,
                    right: 6.r,
                    child: Material(
                      color: context.colors.surface.withValues(alpha: 0.9),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onFavoriteToggle,
                        child: Padding(
                          padding: EdgeInsets.all(6.r),
                          child: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 18.r,
                            color: isFavorite
                                ? AppColors.accent
                                : context.colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleMedium,
            ),
            SizedBox(height: 4.h),
            if (rating > 0) ...[
              RatingStars(rating: rating, size: 13.r),
              SizedBox(height: 4.h),
            ],
            Row(
              children: [
                Text(
                  price.toPrice(),
                  style: context.textTheme.titleMedium
                      ?.copyWith(color: context.colors.primary),
                ),
                if (hasDiscount) ...[
                  SizedBox(width: 6.w),
                  Text(
                    originalPrice!.toPrice(),
                    style: context.textTheme.bodySmall?.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: context.colors.outline,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
