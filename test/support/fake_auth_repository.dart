import 'package:ma7aly_app/core/errors/failures.dart';
import 'package:ma7aly_app/features/auth/domain/entities/account_entity.dart';
import 'package:ma7aly_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ma7aly_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:ma7aly_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:multiple_result/multiple_result.dart';

class FakeAuthRepository implements AuthRepository {
  int signInCalls = 0;
  int registerCalls = 0;
  int resetCalls = 0;
  SignInParams? lastSignIn;
  RegisterParams? lastRegistration;
  Future<Result<AccountEntity, Failure>>? signInResponse;
  Future<Result<void, Failure>>? resetResponse;

  @override
  Future<Result<AccountEntity, Failure>> signIn(SignInParams params) {
    signInCalls++;
    lastSignIn = params;
    return signInResponse ??
        Future.value(Success(AccountEntity(uid: 'test', email: params.email)));
  }

  @override
  Future<Result<AccountEntity, Failure>> register(RegisterParams params) async {
    registerCalls++;
    lastRegistration = params;
    return Success(AccountEntity(uid: 'test', email: params.email));
  }

  @override
  Future<Result<void, Failure>> resetPassword(String email) {
    resetCalls++;
    return resetResponse ?? Future.value(const Success(null));
  }
}
