import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecurityState extends Equatable {
  const SecurityState({
    this.biometrics = false,
    this.twoFactor = false,
    this.loginAlerts = true,
  });

  final bool biometrics;
  final bool twoFactor;
  final bool loginAlerts;

  SecurityState copyWith({
    bool? biometrics,
    bool? twoFactor,
    bool? loginAlerts,
  }) =>
      SecurityState(
        biometrics: biometrics ?? this.biometrics,
        twoFactor: twoFactor ?? this.twoFactor,
        loginAlerts: loginAlerts ?? this.loginAlerts,
      );

  @override
  List<Object?> get props => [biometrics, twoFactor, loginAlerts];
}

/// Session-scoped security preferences. Persistence is out of scope for
/// Phase 1.
class SecurityCubit extends Cubit<SecurityState> {
  SecurityCubit() : super(const SecurityState());

  void toggleBiometrics(bool v) => emit(state.copyWith(biometrics: v));
  void toggleTwoFactor(bool v) => emit(state.copyWith(twoFactor: v));
  void toggleLoginAlerts(bool v) => emit(state.copyWith(loginAlerts: v));
}
