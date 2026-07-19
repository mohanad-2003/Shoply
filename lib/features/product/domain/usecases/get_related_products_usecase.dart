import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../repositories/product_repository.dart';

@injectable
class GetRelatedProductsUseCase
    implements UseCase<List<ProductEntity>, String> {
  GetRelatedProductsUseCase(this._repository);

  final ProductRepository _repository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call(String id) =>
      _repository.getRelatedProducts(id);
}
