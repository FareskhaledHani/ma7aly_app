import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/params/no_params.dart';
import '../../../../core/use_cases/main_use_case.dart';
import '../repositories/settings_repository.dart';

class SignOutUseCase extends UseCase<void, NoParams> {
  SignOutUseCase(this._repository);
  final SettingsRepository _repository;
  @override
  Future<Result<void, Failure>> call(NoParams params) => _repository.signOut();
}
