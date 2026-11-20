import 'package:firebase_auth/firebase_auth.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_strings.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote);
  final AuthRemoteDataSource _remote;

  String _authMessage(String code) => switch (code) {
    'invalid-email' => AppStrings.emailInvalid,
    'invalid-credential' ||
    'wrong-password' ||
    'user-not-found' => AppStrings.authInvalidCredentials,
    'email-already-in-use' => AppStrings.authEmailInUse,
    'weak-password' => AppStrings.passwordWeak,
    'user-disabled' => AppStrings.authDisabled,
    'network-request-failed' ||
    'unavailable' => AppStrings.noInternetConnection,
    'too-many-requests' => AppStrings.authTooManyRequests,
    'registration-cleanup-failed' => AppStrings.registrationIncomplete,
    'bucket-not-found' ||
    'object-not-found' ||
    'no-default-bucket' => AppStrings.photoUploadUnavailable,
    _ => AppStrings.somethingWentWrong,
  };

  Future<Result<AccountEntity, Failure>> _authenticate(
    Future<AccountEntity> Function() action,
  ) async {
    try {
      return Success(await action());
    } on FirebaseException catch (error) {
      return Error(ServerFailure(message: _authMessage(error.code)));
    } catch (_) {
      return const Error(ServerFailure(message: AppStrings.somethingWentWrong));
    }
  }

  @override
  Future<Result<AccountEntity, Failure>> signIn(SignInParams params) =>
      _authenticate(() async => (await _remote.signIn(params)).toEntity());

  @override
  Future<Result<AccountEntity, Failure>> register(RegisterParams params) =>
      _authenticate(() async => (await _remote.register(params)).toEntity());

  @override
  Future<Result<void, Failure>> resetPassword(String email) async {
    try {
      await _remote.resetPassword(email);
      return const Success(null);
    } on FirebaseAuthException catch (error) {
      // Keep the response identical for existing and unknown email addresses.
      if (error.code == 'user-not-found') return const Success(null);
      final message = switch (error.code) {
        'invalid-email' => AppStrings.emailInvalid,
        'network-request-failed' => AppStrings.noInternetConnection,
        'too-many-requests' => AppStrings.authTooManyRequests,
        _ => AppStrings.somethingWentWrong,
      };
      return Error(ServerFailure(message: message));
    } catch (_) {
      return const Error(ServerFailure(message: AppStrings.somethingWentWrong));
    }
  }
}
