part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  failure,
  passwordResetSent,
}

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.failureKey,
  });

  final AuthStatus status;
  final UserEntity? user;

  /// Stable l10n key for the current failure (resolved in the UI).
  final String? failureKey;

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? failureKey,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      failureKey: failureKey,
    );
  }

  @override
  List<Object?> get props => [status, user, failureKey];
}
