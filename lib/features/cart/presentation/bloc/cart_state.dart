part of 'cart_bloc.dart';

enum CartStatus { loading, loaded, empty, error }

class CartState extends Equatable {
  const CartState({
    this.status = CartStatus.loading,
    this.items = const [],
    this.promo,
    this.summary,
    this.failureKey,
    this.promoError = false,
    this.applyingPromo = false,
  });

  final CartStatus status;
  final List<CartItemEntity> items;
  final PromoCodeEntity? promo;
  final CartSummaryEntity? summary;
  final String? failureKey;
  final bool promoError;
  final bool applyingPromo;

  CartState copyWith({
    CartStatus? status,
    List<CartItemEntity>? items,
    PromoCodeEntity? promo,
    bool clearPromo = false,
    CartSummaryEntity? summary,
    String? failureKey,
    bool? promoError,
    bool? applyingPromo,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      promo: clearPromo ? null : (promo ?? this.promo),
      summary: summary ?? this.summary,
      failureKey: failureKey,
      promoError: promoError ?? false,
      applyingPromo: applyingPromo ?? false,
    );
  }

  @override
  List<Object?> get props =>
      [status, items, promo, summary, failureKey, promoError, applyingPromo];
}
