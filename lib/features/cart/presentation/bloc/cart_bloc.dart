import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/cart_summary_entity.dart';
import '../../domain/entities/promo_code_entity.dart';
import '../../domain/usecases/apply_promo_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_quantity_usecase.dart';

part 'cart_event.dart';
part 'cart_state.dart';

@injectable
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(
    this._getCart,
    this._updateQuantity,
    this._removeItem,
    this._applyPromo,
  ) : super(const CartState()) {
    on<CartStarted>(_onStarted);
    on<CartQuantityChanged>(_onQuantityChanged);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartPromoApplied>(_onPromoApplied);
    on<CartPromoRemoved>(_onPromoRemoved);
  }

  final GetCartUseCase _getCart;
  final UpdateQuantityUseCase _updateQuantity;
  final RemoveFromCartUseCase _removeItem;
  final ApplyPromoUseCase _applyPromo;

  Future<void> _refresh(
    Emitter<CartState> emit, {
    bool showLoader = false,
    PromoCodeEntity? promo,
    bool clearPromo = false,
  }) async {
    if (showLoader) emit(state.copyWith(status: CartStatus.loading));
    final result = await _getCart(const NoParams());
    result.match(
      (failure) => emit(state.copyWith(
        status: CartStatus.error,
        failureKey: failure.l10nKey,
      )),
      (items) {
        final effectivePromo = clearPromo ? null : (promo ?? state.promo);
        emit(state.copyWith(
          status: items.isEmpty ? CartStatus.empty : CartStatus.loaded,
          items: items,
          promo: effectivePromo,
          clearPromo: clearPromo || items.isEmpty,
          summary: CartSummaryEntity.from(
            items,
            items.isEmpty ? null : effectivePromo,
          ),
        ));
      },
    );
  }

  Future<void> _onStarted(CartStarted event, Emitter<CartState> emit) =>
      _refresh(emit, showLoader: true);

  Future<void> _onQuantityChanged(
    CartQuantityChanged event,
    Emitter<CartState> emit,
  ) async {
    await _updateQuantity(
      UpdateQuantityParams(itemId: event.itemId, quantity: event.quantity),
    );
    await _refresh(emit);
  }

  Future<void> _onItemRemoved(
    CartItemRemoved event,
    Emitter<CartState> emit,
  ) async {
    await _removeItem(event.itemId);
    await _refresh(emit);
  }

  Future<void> _onPromoApplied(
    CartPromoApplied event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(applyingPromo: true));
    final result = await _applyPromo(event.code);
    await result.match(
      (_) async => emit(state.copyWith(promoError: true)),
      (promo) async => _refresh(emit, promo: promo),
    );
  }

  Future<void> _onPromoRemoved(
    CartPromoRemoved event,
    Emitter<CartState> emit,
  ) =>
      _refresh(emit, clearPromo: true);
}
