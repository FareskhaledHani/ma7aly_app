import 'package:firebase_core/firebase_core.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_strings.dart';
import '../../domain/entities/shop_settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_remote_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._remote);
  final SettingsRemoteDataSource _remote;
  Future<Result<T, Failure>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on FirebaseException catch (e) {
      return Error(
        ServerFailure(
          message: e.code == 'unavailable' || e.code == 'network-request-failed'
              ? AppStrings.noInternetConnection
              : AppStrings.somethingWentWrong,
        ),
      );
    } catch (_) {
      return const Error(ServerFailure(message: AppStrings.somethingWentWrong));
    }
  }

  @override
  Future<Result<ShopSettingsEntity, Failure>> load() =>
      _guard(() async => (await _remote.load()).toEntity());
  @override
  Future<Result<void, Failure>> save(ShopSettingsEntity settings) =>
      _guard(() => _remote.save(settings));
  @override
  Future<Result<void, Failure>> signOut() => _guard(_remote.signOut);
}
