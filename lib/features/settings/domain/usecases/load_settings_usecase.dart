import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/params/no_params.dart';
import '../../../../core/use_cases/main_use_case.dart';
import '../entities/shop_settings_entity.dart';
import '../repositories/settings_repository.dart';

class LoadSettingsUseCase extends UseCase<ShopSettingsEntity, NoParams> {
  LoadSettingsUseCase(this._repository);
  final SettingsRepository _repository;
  @override
  Future<Result<ShopSettingsEntity, Failure>> call(NoParams params) =>
      _repository.load();
}
