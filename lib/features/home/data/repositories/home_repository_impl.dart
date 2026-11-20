import 'package:firebase_core/firebase_core.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_strings.dart';
import '../../domain/entities/home_identity_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._remote);
  final HomeRemoteDataSource _remote;
  @override
  Future<Result<HomeIdentityEntity, Failure>> getIdentity() async {
    try {
      return Success((await _remote.getIdentity()).toEntity());
    } on FirebaseException catch (e) {
      return Error(
        ServerFailure(
          message: switch (e.code) {
            'unavailable' ||
            'network-request-failed' => AppStrings.noInternetConnection,
            'permission-denied' ||
            'unauthenticated' => AppStrings.customersAccessDenied,
            _ => AppStrings.somethingWentWrong,
          },
        ),
      );
    } catch (_) {
      return const Error(ServerFailure(message: AppStrings.somethingWentWrong));
    }
  }
}
