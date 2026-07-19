import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/favorites_repository.dart';

@injectable
class ToggleFavoriteUseCase implements UseCase<bool, String> {
  ToggleFavoriteUseCase(this._repository);

  final FavoritesRepository _repository;

  @override
  Future<Either<Failure, bool>> call(String productId) =>
      _repository.toggle(productId);
}
