import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/promo_code_entity.dart';
import '../repositories/cart_repository.dart';

@injectable
class ApplyPromoUseCase implements UseCase<PromoCodeEntity, String> {
  ApplyPromoUseCase(this._repository);

  final CartRepository _repository;

  @override
  Future<Either<Failure, PromoCodeEntity>> call(String code) =>
      _repository.applyPromo(code);
}
