import 'package:injectable/injectable.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Mocked auth backend. Simulates latency and fails deterministically so
/// error/retry UI is reachable without a real API:
///   * login  → wrong password (< 6 chars) throws [ValidationException];
///              reserved fail email throws [ServerException].
///   * register → reserved existing email throws [ValidationException].
abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> forgotPassword({required String email});
  Future<String> verifyOtp({required String email, required String code});
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  });
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  int _idCounter = 1;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(AppConstants.mockDelay);

    if (email.trim().toLowerCase() == AppConstants.reservedFailEmail) {
      throw const ServerException('Login service is temporarily unavailable');
    }
    if (password.length < 6) {
      throw const ValidationException('Invalid email or password');
    }

    final name = _nameFromEmail(email);
    return UserModel(
      id: 'u${_idCounter++}',
      name: name,
      email: email.trim(),
      token: 'mock-token-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(AppConstants.mockDelay);

    if (email.trim().toLowerCase() == AppConstants.reservedExistingEmail) {
      throw const ValidationException('An account with this email exists');
    }

    return UserModel(
      id: 'u${_idCounter++}',
      name: name.trim(),
      email: email.trim(),
      token: 'mock-token-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future<void>.delayed(AppConstants.mockDelay);
    if (email.trim().toLowerCase() == AppConstants.reservedFailEmail) {
      throw const ServerException('Unable to send reset link');
    }
  }

  @override
  Future<String> verifyOtp({
    required String email,
    required String code,
  }) async {
    await Future<void>.delayed(AppConstants.mockShortDelay);
    if (code.trim() != AppConstants.reservedOtpCode) {
      throw const ValidationException('The verification code is incorrect');
    }
    return 'reset-token-${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    await Future<void>.delayed(AppConstants.mockDelay);
    if (resetToken.isEmpty) {
      throw const ServerException('Reset session expired, please try again');
    }
  }

  String _nameFromEmail(String email) {
    final local = email.split('@').first;
    if (local.isEmpty) return 'Shopper';
    return local[0].toUpperCase() + local.substring(1);
  }
}
