import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/asset_paths.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/mock/mock_catalog.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../domain/entities/product_detail_entity.dart';
import '../../domain/entities/product_variant_entity.dart';
import '../../domain/entities/review_entity.dart';

/// Mocked product backend keyed by id. Throws [NotFoundException] on an unknown
/// id (or the reserved [AppConstants.unknownProductId]) so the error/retry UI
/// is reachable.
abstract class ProductRemoteDataSource {
  Future<ProductDetailEntity> getProductDetails(String id);
  Future<List<ProductEntity>> getRelatedProducts(String id);
}

@LazySingleton(as: ProductRemoteDataSource)
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  @override
  Future<ProductDetailEntity> getProductDetails(String id) async {
    await Future<void>.delayed(AppConstants.mockDelay);

    final base = MockCatalog.byId[id];
    if (base == null || id == AppConstants.unknownProductId) {
      throw const NotFoundException('Product not found');
    }

    return ProductDetailEntity(
      product: base,
      gallery: _galleryFor(base),
      description:
          '${base.brand} presents the ${base.name} — crafted from premium '
          'materials with meticulous attention to detail. Designed for '
          'everyday comfort and a timeless, versatile look that pairs with '
          'anything in your wardrobe.',
      variant: _variantFor(base),
      reviews: _reviewsFor(base),
      inStock: true,
    );
  }

  @override
  Future<List<ProductEntity>> getRelatedProducts(String id) async {
    await Future<void>.delayed(AppConstants.mockShortDelay);
    final base = MockCatalog.byId[id];
    if (base == null) return const [];
    return MockCatalog.products
        .where((p) => p.category == base.category && p.id != id)
        .take(6)
        .toList();
  }

  List<String> _galleryFor(ProductEntity p) {
    // Base image + a couple of complementary shots for the gallery.
    final extras = AssetPaths.shoes.take(2).toList();
    return [p.imagePath, ...extras];
  }

  ProductVariantEntity _variantFor(ProductEntity p) {
    final isFootwear = p.id.startsWith('sh') || p.id.startsWith('nike');
    return ProductVariantEntity(
      colors: const ['Black', 'Sand', 'Navy', 'Olive'],
      sizes: isFootwear
          ? const ['39', '40', '41', '42', '43', '44']
          : const ['XS', 'S', 'M', 'L', 'XL'],
    );
  }

  List<ReviewEntity> _reviewsFor(ProductEntity p) {
    return [
      ReviewEntity(
        author: 'Sarah M.',
        rating: 5,
        comment: 'Absolutely love it — exactly as pictured and great quality.',
        timeAgo: '2 days ago',
      ),
      ReviewEntity(
        author: 'James K.',
        rating: 4,
        comment: 'Solid value for the price. Fits true to size.',
        timeAgo: '1 week ago',
      ),
      ReviewEntity(
        author: 'Aisha R.',
        rating: p.rating >= 4.5 ? 5 : 4,
        comment: 'Shipped fast and looks premium. Would buy again.',
        timeAgo: '3 weeks ago',
      ),
    ];
  }
}
