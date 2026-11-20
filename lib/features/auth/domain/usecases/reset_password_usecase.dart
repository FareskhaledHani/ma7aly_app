import 'package:equatable/equatable.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/main_use_case.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams(this.email);
  final String email;

  @override
  List<Object?> get props => [email];
}

class ResetPasswordUseCase extends UseCase<void, ResetPasswordParams> {
  ResetPasswordUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Result<void, Failure>> call(ResetPasswordParams params) =>
      _repository.resetPassword(params.email);
}
