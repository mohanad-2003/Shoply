part of 'checkout_cubit.dart';

enum CheckoutStatus { loading, ready, placing, success, error }

class CheckoutState extends Equatable {
  const CheckoutState({
    this.status = CheckoutStatus.loading,
    this.items = const [],
    this.summary,
    this.addresses = const [],
    this.selectedAddressId,
    this.paymentMethods = const [],
    this.selectedPaymentId,
    this.orderNumber,
    this.failureKey,
  });

  final CheckoutStatus status;
  final List<CartItemEntity> items;
  final CartSummaryEntity? summary;
  final List<ShippingAddress> addresses;
  final String? selectedAddressId;
  final List<PaymentMethodOption> paymentMethods;
  final String? selectedPaymentId;
  final String? orderNumber;
  final String? failureKey;

  ShippingAddress? get selectedAddress {
    for (final a in addresses) {
      if (a.id == selectedAddressId) return a;
    }
    return addresses.isEmpty ? null : addresses.first;
  }

  PaymentMethodOption? get selectedPayment {
    for (final p in paymentMethods) {
      if (p.id == selectedPaymentId) return p;
    }
    return paymentMethods.isEmpty ? null : paymentMethods.first;
  }

  CheckoutState copyWith({
    CheckoutStatus? status,
    List<CartItemEntity>? items,
    CartSummaryEntity? summary,
    List<ShippingAddress>? addresses,
    String? selectedAddressId,
    List<PaymentMethodOption>? paymentMethods,
    String? selectedPaymentId,
    String? orderNumber,
    String? failureKey,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      items: items ?? this.items,
      summary: summary ?? this.summary,
      addresses: addresses ?? this.addresses,
      selectedAddressId: selectedAddressId ?? this.selectedAddressId,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedPaymentId: selectedPaymentId ?? this.selectedPaymentId,
      orderNumber: orderNumber ?? this.orderNumber,
      failureKey: failureKey,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        summary,
        addresses,
        selectedAddressId,
        paymentMethods,
        selectedPaymentId,
        orderNumber,
        failureKey,
      ];
}
