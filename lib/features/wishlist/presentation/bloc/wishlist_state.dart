part of 'wishlist_bloc.dart';

enum WishlistStatus { loading, loaded, empty, error }

class WishlistState extends Equatable {
  const WishlistState({
    this.status = WishlistStatus.loading,
    this.products = const [],
    this.failureKey,
  });

  final WishlistStatus status;
  final List<ProductEntity> products;
  final String? failureKey;

  WishlistState copyWith({
    WishlistStatus? status,
    List<ProductEntity>? products,
    String? failureKey,
  }) {
    return WishlistState(
      status: status ?? this.status,
      products: products ?? this.products,
      failureKey: failureKey,
    );
  }

  @override
  List<Object?> get props => [status, products, failureKey];
}
