part of 'catalog_cubit.dart';

enum CatalogStatus { initial, loading, loaded, empty, error }

class CatalogState extends Equatable {
  const CatalogState({
    this.status = CatalogStatus.initial,
    this.products = const [],
    this.query = '',
    this.failureKey,
  });

  final CatalogStatus status;
  final List<ProductEntity> products;
  final String query;
  final String? failureKey;

  CatalogState copyWith({
    CatalogStatus? status,
    List<ProductEntity>? products,
    String? query,
    String? failureKey,
  }) {
    return CatalogState(
      status: status ?? this.status,
      products: products ?? this.products,
      query: query ?? this.query,
      failureKey: failureKey,
    );
  }

  @override
  List<Object?> get props => [status, products, query, failureKey];
}
