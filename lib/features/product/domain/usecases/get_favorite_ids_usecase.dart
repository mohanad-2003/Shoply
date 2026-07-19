import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/favorites_repository.dart';

@injectable
class GetFavoriteIdsUseCase {
  GetFavoriteIdsUseCase(this._repository);

  final FavoritesRepository _repository;

  Either<Failure, Set<String>> call() => _repository.getFavoriteIds();
}
