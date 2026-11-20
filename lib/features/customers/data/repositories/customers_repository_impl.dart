import 'package:firebase_core/firebase_core.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/app_strings.dart';
import '../../domain/entities/customers_page_entity.dart';
import '../../domain/repositories/customers_repository.dart';
import '../../domain/usecases/add_customer_usecase.dart';
import '../../domain/usecases/get_customers_usecase.dart';
import '../datasources/customers_remote_data_source.dart';
import '../../domain/entities/customer_account_entity.dart';
import '../../domain/usecases/get_customer_account_usecase.dart';
import '../../domain/usecases/save_customer_movement_usecase.dart';

class CustomersRepositoryImpl implements CustomersRepository {
  CustomersRepositoryImpl(this._remote);
  final CustomersRemoteDataSource _remote;
  Future<Result<T, Failure>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on FirebaseException catch (error) {
      final message = switch (error.code) {
        'unavailable' ||
        'network-request-failed' => AppStrings.noInternetConnection,
        'permission-denied' ||
        'unauthenticated' ||
        'requires-recent-login' => AppStrings.customersAccessDenied,
        'already-exists' => AppStrings.customerAlreadySaved,
        'aborted' => AppStrings.movementChanged,
        'confirm-credit' => AppStrings.confirmCredit,
        'confirm-negative-stock' => AppStrings.confirmNegativeStock,
        'invalid-argument' => AppStrings.movementInvalid,
        _ => AppStrings.somethingWentWrong,
      };
      return Error(ServerFailure(message: message));
    } catch (_) {
      return const Error(ServerFailure(message: AppStrings.somethingWentWrong));
    }
  }

  @override
  Future<Result<CustomerAccountEntity, Failure>> getAccount(
    CustomerAccountParams params,
  ) => _guard(() => _remote.getAccount(params));
  @override
  Future<Result<void, Failure>> saveMovement(
    SaveCustomerMovementParams params,
  ) => _guard(() => _remote.saveMovement(params));

  @override
  Future<Result<CustomersPageEntity, Failure>> getCustomers(
    GetCustomersParams params,
  ) => _guard(() => _remote.getCustomers(params));
  @override
  Future<Result<String, Failure>> addCustomer(AddCustomerParams params) =>
      _guard(() => _remote.addCustomer(params));
}
