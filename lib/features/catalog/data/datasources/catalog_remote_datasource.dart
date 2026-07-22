import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/mock/mock_catalog.dart';
import '../../../home/domain/entities/product_entity.dart';

/// Mocked catalog backend backed by the shared [MockCatalog]. A real
/// datasource would translate these into API calls with query params.
abstract class CatalogRemoteDataSource {
  Future<List<ProductEntity>> getProducts({String? categoryId, String? query});
}

@LazySingleton(as: CatalogRemoteDataSource)
class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  @override
  Future<List<ProductEntity>> getProducts({
    String? categoryId,
    String? query,
  }) async {
    await Future<void>.delayed(AppConstants.mockShortDelay);

    var products = MockCatalog.products;

    if (categoryId != null && categoryId.isNotEmpty) {
      products =
          products.where((p) => p.category == categoryId).toList(growable: false);
    }

    final q = query?.trim().toLowerCase();
    if (q != null && q.isNotEmpty) {
      products = products
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              p.brand.toLowerCase().contains(q) ||
              p.category.toLowerCase().contains(q))
          .toList(growable: false);
    }

    return products;
  }
}
