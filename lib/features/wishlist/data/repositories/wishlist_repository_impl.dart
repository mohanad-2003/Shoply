import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/mock/mock_catalog.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../../product/domain/repositories/favorites_repository.dart';
import '../../domain/repositories/wishlist_repository.dart';

@LazySingleton(as: WishlistRepository)
class WishlistRepositoryImpl implements WishlistRepository {
  WishlistRepositoryImpl(this._favorites);

  final FavoritesRepository _favorites;

  @override
  Either<Failure, List<ProductEntity>> getWishlistProducts() {
    return _favorites.getFavoriteIds().map(
          (ids) => ids
              .map((id) => MockCatalog.byId[id])
              .whereType<ProductEntity>()
              .map((p) => p.copyWith(isFavorite: true))
              .toList(),
        );
  }

  @override
  Future<Either<Failure, bool>> removeFromWishlist(String productId) =>
      _favorites.toggle(productId);
}
