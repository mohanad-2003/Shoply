import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

@injectable
class RemoveFromCartUseCase implements UseCase<Unit, String> {
  RemoveFromCartUseCase(this._repository);

  final CartRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(String itemId) =>
      _repository.removeItem(itemId);
}
