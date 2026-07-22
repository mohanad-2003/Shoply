import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/context_extensions.dart';
import '../extensions/num_extensions.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import 'rating_stars.dart';

/// Shared product tile used by Home sections, catalog, search, related
/// products and the wishlist. Deliberately decoupled from any feature entity —
/// takes primitives.
class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    this.brand,
    this.originalPrice,
    this.rating = 0,
    this.reviewCount = 0,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteToggle,
    this.onAddToCart,
    this.width,
  });

  final String imagePath;
  final String title;
  final double price;
  final String? brand;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  /// When provided, a compact "+" quick-add button is shown next to the price.
  final VoidCallback? onAddToCart;
  final double? width;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (mounted) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasDiscount =
        widget.originalPrice != null && widget.originalPrice! > widget.price;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: widget.width,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: AppRadius.rLg,
            border: Border.all(color: colors.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildImage(context, hasDiscount)),
              Padding(
                padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
                child: _buildInfo(context, hasDiscount),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, bool hasDiscount) {
    final colors = context.colors;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: colors.surfaceContainerHighest,
          child: Image.asset(
            widget.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Icon(
              Icons.image_not_supported_outlined,
              color: colors.outline,
              size: 32.r,
            ),
          ),
        ),
        if (hasDiscount)
          Positioned(
            top: 8.r,
            left: 8.r,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: AppRadius.rSm,
              ),
              child: Text(
                '-${(((widget.originalPrice! - widget.price) / widget.originalPrice!) * 100).round()}%',
                style: context.textTheme.labelSmall
                    ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        Positioned(
          top: 6.r,
          right: 6.r,
          child: Material(
            color: colors.surface.withValues(alpha: 0.9),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: widget.onFavoriteToggle,
              child: Padding(
                padding: EdgeInsets.all(6.r),
                child: Icon(
                  widget.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 18.r,
                  color: widget.isFavorite
                      ? AppColors.accent
                      : colors.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfo(BuildContext context, bool hasDiscount) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.brand != null && widget.brand!.isNotEmpty) ...[
          Text(
            widget.brand!.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 2.h),
        ],
        Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.titleSmall,
        ),
        if (widget.rating > 0) ...[
          SizedBox(height: 4.h),
          Row(
            children: [
              RatingStars(rating: widget.rating, size: 13.r),
              if (widget.reviewCount > 0) ...[
                SizedBox(width: 4.w),
                Text(
                  '(${widget.reviewCount})',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ],
        SizedBox(height: 6.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.price.toPrice(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (hasDiscount)
                    Text(
                      widget.originalPrice!.toPrice(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelSmall?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: colors.outline,
                      ),
                    ),
                ],
              ),
            ),
            if (widget.onAddToCart != null) _AddButton(onTap: widget.onAddToCart!),
          ],
        ),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.primary,
      borderRadius: AppRadius.rMd,
      child: InkWell(
        borderRadius: AppRadius.rMd,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(6.r),
          child: Icon(
            Icons.add_rounded,
            size: 18.r,
            color: context.colors.onPrimary,
          ),
        ),
      ),
    );
  }
}
