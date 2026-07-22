import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/wishlist_repository.dart';

@injectable
class RemoveFromWishlistUseCase implements UseCase<bool, String> {
  RemoveFromWishlistUseCase(this._repository);

  final WishlistRepository _repository;

  @override
  Future<Either<Failure, bool>> call(String productId) =>
      _repository.removeFromWishlist(productId);
}
