import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../checkout/presentation/models/checkout_models.dart';

class AddressesState extends Equatable {
  const AddressesState({this.addresses = const [], this.defaultId});

  final List<ShippingAddress> addresses;
  final String? defaultId;

  AddressesState copyWith({
    List<ShippingAddress>? addresses,
    String? defaultId,
  }) =>
      AddressesState(
        addresses: addresses ?? this.addresses,
        defaultId: defaultId ?? this.defaultId,
      );

  @override
  List<Object?> get props => [addresses, defaultId];
}

/// In-memory address book seeded with mock data. Persistence is out of scope
/// for Phase 1, so edits live for the session.
class AddressesCubit extends Cubit<AddressesState> {
  AddressesCubit()
      : super(
          AddressesState(
            addresses: List.of(CheckoutMockData.addresses),
            defaultId: CheckoutMockData.addresses.first.id,
          ),
        );

  void add(ShippingAddress address) {
    emit(state.copyWith(
      addresses: [...state.addresses, address],
      defaultId: state.addresses.isEmpty ? address.id : state.defaultId,
    ));
  }

  void setDefault(String id) => emit(state.copyWith(defaultId: id));

  void remove(String id) {
    final remaining =
        state.addresses.where((a) => a.id != id).toList(growable: false);
    final newDefault = state.defaultId == id
        ? (remaining.isEmpty ? null : remaining.first.id)
        : state.defaultId;
    emit(AddressesState(addresses: remaining, defaultId: newDefault));
  }
}
