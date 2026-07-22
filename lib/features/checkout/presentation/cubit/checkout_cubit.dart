import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';
import '../../../cart/domain/entities/cart_summary_entity.dart';
import '../../../cart/domain/entities/promo_code_entity.dart';
import '../../../cart/domain/usecases/get_cart_usecase.dart';
import '../../../cart/domain/usecases/remove_from_cart_usecase.dart';
import '../models/checkout_models.dart';

part 'checkout_state.dart';

/// Drives the checkout screen: loads the cart, tracks the chosen address and
/// payment method, then simulates placing the order (clearing the cart on
/// success so the user returns to an empty bag).
@injectable
class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit(this._getCart, this._removeItem)
      : super(const CheckoutState());

  final GetCartUseCase _getCart;
  final RemoveFromCartUseCase _removeItem;

  /// [promo] is forwarded from the cart so any applied discount carries over.
  Future<void> load(PromoCodeEntity? promo) async {
    emit(state.copyWith(status: CheckoutStatus.loading));

    final result = await _getCart(const NoParams());
    result.match(
      (failure) => emit(state.copyWith(
        status: CheckoutStatus.error,
        failureKey: failure.l10nKey,
      )),
      (items) {
        const addresses = CheckoutMockData.addresses;
        const methods = CheckoutMockData.paymentMethods;
        emit(state.copyWith(
          status: CheckoutStatus.ready,
          items: items,
          summary: CartSummaryEntity.from(items, promo),
          addresses: addresses,
          selectedAddressId: addresses.first.id,
          paymentMethods: methods,
          selectedPaymentId: methods.first.id,
        ));
      },
    );
  }

  void selectAddress(String id) =>
      emit(state.copyWith(selectedAddressId: id));

  void selectPayment(String id) =>
      emit(state.copyWith(selectedPaymentId: id));

  Future<void> placeOrder() async {
    if (state.status != CheckoutStatus.ready) return;
    emit(state.copyWith(status: CheckoutStatus.placing));

    // Simulate payment authorization / order creation latency.
    await Future<void>.delayed(const Duration(milliseconds: 1800));

    // Empty the bag now that the order is confirmed.
    for (final item in state.items) {
      await _removeItem(item.id);
    }

    emit(state.copyWith(
      status: CheckoutStatus.success,
      orderNumber: _generateOrderNumber(),
    ));
  }

  String _generateOrderNumber() {
    final stamp = DateTime.now().millisecondsSinceEpoch % 1000000;
    return '#SH${stamp.toString().padLeft(6, '0')}';
  }

  ShippingAddress? get selectedAddress => state.selectedAddress;
}
