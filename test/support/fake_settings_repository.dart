import 'package:multiple_result/multiple_result.dart';
import 'package:ma7aly_app/core/errors/failures.dart';
import 'package:ma7aly_app/features/settings/domain/entities/shop_settings_entity.dart';
import 'package:ma7aly_app/features/settings/domain/repositories/settings_repository.dart';

class FakeSettingsRepository implements SettingsRepository {
  ShopSettingsEntity value = const ShopSettingsEntity(
    shopName: 'QA shop',
    phone: '01000000000',
    email: 'qa@example.com',
  );
  int saveCalls = 0;
  bool signedOut = false;
  @override
  Future<Result<ShopSettingsEntity, Failure>> load() async => Success(value);
  @override
  Future<Result<void, Failure>> save(ShopSettingsEntity settings) async {
    saveCalls++;
    value = settings;
    return const Success(null);
  }

  @override
  Future<Result<void, Failure>> signOut() async {
    signedOut = true;
    return const Success(null);
  }
}
