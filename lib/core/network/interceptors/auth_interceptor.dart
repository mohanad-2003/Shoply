import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../constants/app_constants.dart';

/// Attaches the bearer token (if any) from secure storage to each request.
/// On a 401 it clears the token — a documented swap point for real
/// refresh-token rotation in a later phase.
@lazySingleton
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: AppConstants.secureAuthToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Phase 1: just drop the token. Later: attempt refresh + retry.
      await _storage.delete(key: AppConstants.secureAuthToken);
    }
    handler.next(err);
  }
}
