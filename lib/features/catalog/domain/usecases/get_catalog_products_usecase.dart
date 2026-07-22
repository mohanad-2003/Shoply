import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../repositories/catalog_repository.dart';

@injectable
class GetCatalogProductsUseCase
    implements UseCase<List<ProductEntity>, CatalogQuery> {
  GetCatalogProductsUseCase(this._repository);

  final CatalogRepository _repository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call(CatalogQuery params) =>
      _repository.getProducts(
        categoryId: params.categoryId,
        query: params.query,
      );
}

class CatalogQuery extends Equatable {
  const CatalogQuery({this.categoryId, this.query});

  final String? categoryId;
  final String? query;

  @override
  List<Object?> get props => [categoryId, query];
}
