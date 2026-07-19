import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/exception_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_datasource.dart';

@LazySingleton(as: FavoritesRepository)
class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._local);

  final FavoritesLocalDataSource _local;

  @override
  Either<Failure, Set<String>> getFavoriteIds() {
    try {
      return Right(_local.getFavoriteIds());
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> toggle(String productId) async {
    try {
      return Right(await _local.toggle(productId));
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Either<Failure, bool> isFavorite(String productId) {
    try {
      return Right(_local.isFavorite(productId));
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
