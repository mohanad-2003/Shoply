import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../home/domain/entities/product_entity.dart';

class RelatedProductsList extends StatelessWidget {
  const RelatedProductsList({
    super.key,
    required this.products,
    required this.onTap,
  });

  final List<ProductEntity> products;
  final void Function(ProductEntity) onTap;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 230.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
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
            onTap: () => onTap(p),
          );
        },
      ),
    );
  }
}
