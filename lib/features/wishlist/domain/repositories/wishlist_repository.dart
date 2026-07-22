import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/product_entity.dart';

/// Reads the user's favorite product ids and hydrates them into full
/// [ProductEntity] objects from the shared catalog, plus removal.
abstract class WishlistRepository {
  Either<Failure, List<ProductEntity>> getWishlistProducts();
  Future<Either<Failure, bool>> removeFromWishlist(String productId);
}
