import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

@injectable
class UpdateQuantityUseCase implements UseCase<Unit, UpdateQuantityParams> {
  UpdateQuantityUseCase(this._repository);

  final CartRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(UpdateQuantityParams params) =>
      _repository.updateQuantity(params.itemId, params.quantity);
}

class UpdateQuantityParams extends Equatable {
  const UpdateQuantityParams({required this.itemId, required this.quantity});

  final String itemId;
  final int quantity;

  @override
  List<Object?> get props => [itemId, quantity];
}
