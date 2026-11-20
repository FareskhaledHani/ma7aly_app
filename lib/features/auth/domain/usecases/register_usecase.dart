import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/main_use_case.dart';
import '../entities/account_entity.dart';
import '../entities/account_photo.dart';
import '../repositories/auth_repository.dart';

class RegisterParams {
  const RegisterParams({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    this.photo,
  });
  final String name;
  final String phone;
  final String email;
  final String password;
  final AccountPhoto? photo;
}

class RegisterUseCase extends UseCase<AccountEntity, RegisterParams> {
  RegisterUseCase(this._repository);
  final AuthRepository _repository;
  @override
  Future<Result<AccountEntity, Failure>> call(RegisterParams params) =>
      _repository.register(params);
}
