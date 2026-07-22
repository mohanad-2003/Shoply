import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../checkout/presentation/models/checkout_models.dart';

class PaymentMethodsState extends Equatable {
  const PaymentMethodsState({this.methods = const [], this.defaultId});

  final List<PaymentMethodOption> methods;
  final String? defaultId;

  PaymentMethodsState copyWith({
    List<PaymentMethodOption>? methods,
    String? defaultId,
  }) =>
      PaymentMethodsState(
        methods: methods ?? this.methods,
        defaultId: defaultId ?? this.defaultId,
      );

  @override
  List<Object?> get props => [methods, defaultId];
}

/// Session-scoped wallet seeded with the mock payment methods.
class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  PaymentMethodsCubit()
      : super(
          PaymentMethodsState(
            methods: List.of(CheckoutMockData.paymentMethods),
            defaultId: CheckoutMockData.paymentMethods.first.id,
          ),
        );

  void add(PaymentMethodOption method) {
    emit(state.copyWith(
      methods: [...state.methods, method],
      defaultId: state.methods.isEmpty ? method.id : state.defaultId,
    ));
  }

  void setDefault(String id) => emit(state.copyWith(defaultId: id));

  void remove(String id) {
    final remaining =
        state.methods.where((m) => m.id != id).toList(growable: false);
    final newDefault = state.defaultId == id
        ? (remaining.isEmpty ? null : remaining.first.id)
        : state.defaultId;
    emit(PaymentMethodsState(methods: remaining, defaultId: newDefault));
  }
}
