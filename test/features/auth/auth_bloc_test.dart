import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ui_kit/core/errors/failures.dart';
import 'package:ui_kit/core/usecases/usecase.dart';
import 'package:ui_kit/features/auth/domain/entities/user_entity.dart';
import 'package:ui_kit/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:ui_kit/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:ui_kit/features/auth/domain/usecases/login_usecase.dart';
import 'package:ui_kit/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ui_kit/features/auth/domain/usecases/register_usecase.dart';
import 'package:ui_kit/features/auth/presentation/bloc/auth_bloc.dart';

class _MockLogin extends Mock implements LoginUseCase {}

class _MockRegister extends Mock implements RegisterUseCase {}

class _MockForgot extends Mock implements ForgotPasswordUseCase {}

class _MockGetCached extends Mock implements GetCachedUserUseCase {}

class _MockLogout extends Mock implements LogoutUseCase {}

void main() {
  late _MockLogin login;
  late _MockRegister register;
  late _MockForgot forgot;
  late _MockGetCached getCached;
  late _MockLogout logout;

  const user = UserEntity(id: 'u1', name: 'Test', email: 't@t.com');

  setUpAll(() {
    registerFallbackValue(const LoginParams(email: '', password: ''));
    registerFallbackValue(
        const RegisterParams(name: '', email: '', password: ''));
    registerFallbackValue(const ForgotPasswordParams(email: ''));
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    login = _MockLogin();
    register = _MockRegister();
    forgot = _MockForgot();
    getCached = _MockGetCached();
    logout = _MockLogout();
  });

  AuthBloc build() => AuthBloc(login, register, forgot, getCached, logout);

  blocTest<AuthBloc, AuthState>(
    'emits [loading, authenticated] on successful login',
    build: () {
      when(() => login(any())).thenAnswer((_) async => const Right(user));
      return build();
    },
    act: (bloc) => bloc.add(
      const AuthLoginRequested(email: 't@t.com', password: 'secret'),
    ),
    expect: () => [
      predicate<AuthState>((s) => s.status == AuthStatus.loading),
      predicate<AuthState>(
          (s) => s.status == AuthStatus.authenticated && s.user == user),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [loading, failure] when login returns a Failure',
    build: () {
      when(() => login(any())).thenAnswer(
        (_) async => const Left(Failure.validation(message: 'bad')),
      );
      return build();
    },
    act: (bloc) => bloc.add(
      const AuthLoginRequested(email: 't@t.com', password: '123'),
    ),
    expect: () => [
      predicate<AuthState>((s) => s.status == AuthStatus.loading),
      predicate<AuthState>((s) => s.status == AuthStatus.failure),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits passwordResetSent on successful forgot-password',
    build: () {
      when(() => forgot(any())).thenAnswer((_) async => const Right(unit));
      return build();
    },
    act: (bloc) =>
        bloc.add(const AuthForgotPasswordRequested(email: 't@t.com')),
    expect: () => [
      predicate<AuthState>((s) => s.status == AuthStatus.loading),
      predicate<AuthState>((s) => s.status == AuthStatus.passwordResetSent),
    ],
  );
}
