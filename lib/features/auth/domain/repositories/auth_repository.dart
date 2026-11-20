import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../entities/account_entity.dart';
import '../usecases/register_usecase.dart';
import '../usecases/sign_in_usecase.dart';

abstract class AuthRepository {
  Future<Result<AccountEntity, Failure>> signIn(SignInParams params);
  Future<Result<AccountEntity, Failure>> register(RegisterParams params);
  Future<Result<void, Failure>> resetPassword(String email);
}
