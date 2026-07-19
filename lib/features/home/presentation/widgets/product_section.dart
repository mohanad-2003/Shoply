import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/product_entity.dart';

class ProductSection extends StatelessWidget {
  const ProductSection({
    super.key,
    required this.title,
    required this.products,
    this.onSeeAll,
    required this.onProductTap,
    required this.onFavoriteToggle,
  });

  final String title;
  final List<ProductEntity> products;
  final VoidCallback? onSeeAll;
  final void Function(ProductEntity) onProductTap;
  final void Function(ProductEntity) onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
          child: SectionHeader(
            title: title,
            actionLabel: onSeeAll != null ? context.l10n.seeAll : null,
            onAction: onSeeAll,
          ),
        ),
        SizedBox(height: AppSpacing.vMd),
        SizedBox(
          height: 240.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
            itemCount: products.length,
            separatorBuilder: (_, _) => SizedBox(width: AppSpacing.md),
            itemBuilder: (_, i) {
              final p = products[i];
              return ProductCard(
                width: 150.w,
                imagePath: p.imagePath,
                title: p.name,
                price: p.price,
                originalPrice: p.originalPrice,
                rating: p.rating,
                isFavorite: p.isFavorite,
                onTap: () => onProductTap(p),
                onFavoriteToggle: () => onFavoriteToggle(p),
              );
            },
          ),
        ),
        SizedBox(height: AppSpacing.vXl),
      ],
    );
  }
}
