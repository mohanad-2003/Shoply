part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartStarted extends CartEvent {
  const CartStarted();
}

class CartQuantityChanged extends CartEvent {
  const CartQuantityChanged(this.itemId, this.quantity);

  final String itemId;
  final int quantity;

  @override
  List<Object?> get props => [itemId, quantity];
}

class CartItemRemoved extends CartEvent {
  const CartItemRemoved(this.itemId);

  final String itemId;

  @override
  List<Object?> get props => [itemId];
}

class CartPromoApplied extends CartEvent {
  const CartPromoApplied(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}

class CartPromoRemoved extends CartEvent {
  const CartPromoRemoved();
}
