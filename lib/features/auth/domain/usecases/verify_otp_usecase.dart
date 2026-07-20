import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

@injectable
class VerifyOtpUseCase implements UseCase<String, VerifyOtpParams> {
  VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, String>> call(VerifyOtpParams params) =>
      _repository.verifyOtp(email: params.email, code: params.code);
}

class VerifyOtpParams extends Equatable {
  const VerifyOtpParams({required this.email, required this.code});

  final String email;
  final String code;

  @override
  List<Object?> get props => [email, code];
}
