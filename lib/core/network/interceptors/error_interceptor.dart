import 'package:dio/dio.dart';

import '../../errors/exceptions.dart';

/// Maps low-level [DioException]s to typed [AppException]s so repositories
/// deal with a stable, transport-agnostic error surface.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _map(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: exception,
      ),
    );
  }

  AppException _map(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        final status = err.response?.statusCode ?? 0;
        if (status == 401) return const UnauthorizedException();
        if (status == 404) return const NotFoundException();
        if (status >= 500) return const ServerException();
        return ServerException('Request failed with status $status');
      case DioExceptionType.cancel:
        return const AppException('Request cancelled');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return const UnexpectedFallback();
      default:
        return const UnexpectedFallback();
    }
  }
}

/// Internal fallback exception for unclassified transport errors.
class UnexpectedFallback extends AppException {
  const UnexpectedFallback() : super('Unexpected network error');
}
