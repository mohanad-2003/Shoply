import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';

abstract class FavoritesRepository {
  Either<Failure, Set<String>> getFavoriteIds();
  Future<Either<Failure, bool>> toggle(String productId);
  Either<Failure, bool> isFavorite(String productId);
}
