import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ma7aly_app/core/errors/failures.dart';
import 'package:ma7aly_app/core/helpers/auth_validators.dart';
import 'package:ma7aly_app/core/utils/app_strings.dart';
import 'package:ma7aly_app/features/auth/domain/entities/account_entity.dart';
import 'package:ma7aly_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:ma7aly_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:ma7aly_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:ma7aly_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ma7aly_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:ma7aly_app/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:ma7aly_app/features/auth/presentation/cubit/password_reset_state.dart';
import 'package:multiple_result/multiple_result.dart';

import 'support/fake_auth_repository.dart';

void main() {
  test(
    'Validation accepts existing short passwords but enforces signup minimum',
    () {
      expect(AuthValidators.password('abc'), isNull);
      expect(AuthValidators.newPassword('abc'), AppStrings.passwordWeak);
      expect(AuthValidators.email('  valid@example.com  '), isNull);
      expect(AuthValidators.email('invalid'), AppStrings.emailInvalid);
      expect(AuthValidators.name(' '), AppStrings.nameInvalid);
      expect(AuthValidators.phone('+20 1012345678'), isNull);
    },
  );

  test(
    'Sign in suppresses duplicate requests and does not emit after close',
    () async {
      final repository = FakeAuthRepository();
      final result = Completer<Result<AccountEntity, Failure>>();
      repository.signInResponse = result.future;
      final cubit = AuthCubit(
        SignInUseCase(repository),
        RegisterUseCase(repository),
      );
      final first = cubit.signIn('test@example.com', 'test-only');
      await cubit.signIn('test@example.com', 'test-only');
      expect(repository.signInCalls, 1);
      expect(cubit.state, isA<AuthLoading>());
      await cubit.close();
      result.complete(
        const Success(AccountEntity(uid: 'test', email: 'test@example.com')),
      );
      await first;
    },
  );

  test('Reset suppresses duplicate sends and surfaces safe failure', () async {
    final repository = FakeAuthRepository();
    final result = Completer<Result<void, Failure>>();
    repository.resetResponse = result.future;
    final cubit = PasswordResetCubit(ResetPasswordUseCase(repository));
    final first = cubit.resetPassword('test@example.com');
    await cubit.resetPassword('test@example.com');
    expect(repository.resetCalls, 1);
    result.complete(
      const Error(ServerFailure(message: AppStrings.noInternetConnection)),
    );
    await first;
    expect(cubit.state, isA<PasswordResetFailure>());
    await cubit.close();
  });
}
