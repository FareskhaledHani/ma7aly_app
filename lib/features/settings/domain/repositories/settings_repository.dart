import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../entities/shop_settings_entity.dart';

abstract class SettingsRepository {
  Future<Result<ShopSettingsEntity, Failure>> load();
  Future<Result<void, Failure>> save(ShopSettingsEntity settings);
  Future<Result<void, Failure>> signOut();
}
