import 'exceptions.dart';
import 'failures.dart';

/// Translates data-layer [AppException]s into presentation-facing [Failure]s.
Failure mapExceptionToFailure(Object error) {
  if (error is ValidationException) {
    return Failure.validation(message: error.message);
  }
  if (error is NetworkException) {
    return Failure.network(message: error.message);
  }
  if (error is CacheException) {
    return Failure.cache(message: error.message);
  }
  if (error is NotFoundException || error is ServerException) {
    return Failure.server(message: (error as AppException).message);
  }
  if (error is UnauthorizedException) {
    return Failure.server(message: error.message);
  }
  if (error is AppException) {
    return Failure.unexpected(message: error.message);
  }
  return Failure.unexpected(message: error.toString());
}
