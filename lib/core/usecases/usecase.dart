import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../errors/failures.dart';

/// Base contract for a use case. [T] is the success payload, [Params] the
/// input. Standardises call sites: `await useCase(params)`.
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Synchronous variant for use cases that don't hit async boundaries.
abstract class SyncUseCase<T, Params> {
  Either<Failure, T> call(Params params);
}

/// Sentinel for use cases that take no parameters.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
