import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/staggered_reveal.dart';
import '../../../home/domain/entities/product_entity.dart';

/// Two-column product grid with a staggered entrance animation. Shared by the
/// catalog (category / see-all) and search results screens.
class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onFavoriteToggle,
    this.onAddToCart,
    this.padding,
  });

  final List<ProductEntity> products;
  final void Function(ProductEntity) onProductTap;
  final void Function(ProductEntity) onFavoriteToggle;
  final void Function(ProductEntity)? onAddToCart;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding ?? EdgeInsets.all(AppSpacing.screenH),
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.lg,
        childAspectRatio: 0.62,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) {
        final p = products[i];
        return StaggeredReveal(
          // Stagger within the first rows; later items reveal near-instantly.
          delay: Duration(milliseconds: (i % 8) * 55),
          child: ProductCard(
            imagePath: p.imagePath,
            title: p.name,
            brand: p.brand,
            price: p.price,
            originalPrice: p.originalPrice,
            rating: p.rating,
            reviewCount: p.reviewCount,
            isFavorite: p.isFavorite,
            onTap: () => onProductTap(p),
            onFavoriteToggle: () => onFavoriteToggle(p),
            onAddToCart:
                onAddToCart == null ? null : () => onAddToCart!(p),
          ),
        );
      },
    );
  }
}
