import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../../cart/domain/usecases/add_to_cart_usecase.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../../product/domain/usecases/get_favorite_ids_usecase.dart';
import '../../../product/domain/usecases/toggle_favorite_usecase.dart';
import '../../domain/usecases/get_catalog_products_usecase.dart';

part 'catalog_state.dart';

/// Powers both the category/see-all list and the search screen. Merges the
/// favourites set so hearts stay in sync with the rest of the app.
@injectable
class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit(
    this._getProducts,
    this._getFavoriteIds,
    this._toggleFavorite,
    this._addToCart,
  ) : super(const CatalogState());

  final GetCatalogProductsUseCase _getProducts;
  final GetFavoriteIdsUseCase _getFavoriteIds;
  final ToggleFavoriteUseCase _toggleFavorite;
  final AddToCartUseCase _addToCart;

  Future<void> addToCart(ProductEntity p) => _addToCart(CartItemEntity(
        id: p.id,
        productId: p.id,
        name: p.name,
        imagePath: p.imagePath,
        price: p.price,
        quantity: 1,
      ));

  String? _categoryId;

  Future<void> load({String? categoryId, String? query}) async {
    _categoryId = categoryId;
    emit(state.copyWith(status: CatalogStatus.loading, query: query ?? ''));
    final result =
        await _getProducts(CatalogQuery(categoryId: categoryId, query: query));
    final favIds = _getFavoriteIds().getOrElse((_) => <String>{});
    result.match(
      (failure) => emit(state.copyWith(
        status: CatalogStatus.error,
        failureKey: failure.l10nKey,
      )),
      (products) {
        final merged = products
            .map((p) => p.copyWith(isFavorite: favIds.contains(p.id)))
            .toList(growable: false);
        emit(state.copyWith(
          status: merged.isEmpty ? CatalogStatus.empty : CatalogStatus.loaded,
          products: merged,
        ));
      },
    );
  }

  /// Re-runs the search within the current category scope.
  Future<void> search(String query) =>
      load(categoryId: _categoryId, query: query);

  /// Clears results back to the initial (suggestions) state.
  void reset() => emit(const CatalogState());

  Future<void> toggleFavorite(String productId) async {
    final result = await _toggleFavorite(productId);
    result.match(
      (_) {},
      (isNowFavorite) => emit(state.copyWith(
        products: state.products
            .map((p) => p.id == productId
                ? p.copyWith(isFavorite: isNowFavorite)
                : p)
            .toList(growable: false),
      )),
    );
  }
}
