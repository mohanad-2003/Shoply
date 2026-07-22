part of 'wishlist_bloc.dart';

sealed class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

class WishlistStarted extends WishlistEvent {
  const WishlistStarted();
}

class WishlistItemRemoved extends WishlistEvent {
  const WishlistItemRemoved(this.productId);

  final String productId;

  @override
  List<Object?> get props => [productId];
}
