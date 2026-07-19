import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> forgotPassword({required String email});

  Future<Either<Failure, UserEntity?>> getCachedUser();

  Future<Either<Failure, Unit>> logout();
}
