import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/main_use_case.dart';
import '../../../../core/utils/app_strings.dart';
import '../entities/shop_settings_entity.dart';
import '../repositories/settings_repository.dart';

class SaveSettingsUseCase extends UseCase<void, ShopSettingsEntity> {
  SaveSettingsUseCase(this._repository);
  final SettingsRepository _repository;
  @override
  Future<Result<void, Failure>> call(ShopSettingsEntity s) {
    if (s.shopName.length > 100 ||
        (s.phone.isNotEmpty &&
            !RegExp(r'^[+]?[0-9][0-9 ()-]{5,23}$').hasMatch(s.phone)) ||
        s.phone.length > 24 ||
        s.minimumPaymentPercent < 1 ||
        s.minimumPaymentPercent > 100 ||
        s.warningDays < 0 ||
        s.warningDays > 30) {
      return Future.value(
        const Error(ServerFailure(message: AppStrings.settingsInvalid)),
      );
    }
    return _repository.save(s);
  }
}
