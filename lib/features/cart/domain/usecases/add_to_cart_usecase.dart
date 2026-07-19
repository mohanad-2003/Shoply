import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

@injectable
class AddToCartUseCase implements UseCase<Unit, CartItemEntity> {
  AddToCartUseCase(this._repository);

  final CartRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(CartItemEntity params) =>
      _repository.addItem(params);
}
