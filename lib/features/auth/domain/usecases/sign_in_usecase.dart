import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/main_use_case.dart';
import '../entities/account_entity.dart';
import '../repositories/auth_repository.dart';

class SignInParams {
  const SignInParams({required this.email, required this.password});
  final String email;
  final String password;
  // Credentials deliberately have no generated toString or equality props.
}

class SignInUseCase extends UseCase<AccountEntity, SignInParams> {
  SignInUseCase(this._repository);
  final AuthRepository _repository;
  @override
  Future<Result<AccountEntity, Failure>> call(SignInParams params) =>
      _repository.signIn(params);
}
