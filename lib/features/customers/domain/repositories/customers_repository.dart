import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../entities/customers_page_entity.dart';
import '../usecases/add_customer_usecase.dart';
import '../usecases/get_customers_usecase.dart';
import '../usecases/get_customer_account_usecase.dart';
import '../usecases/save_customer_movement_usecase.dart';
import '../entities/customer_account_entity.dart';

abstract class CustomersRepository {
  Future<Result<CustomerAccountEntity, Failure>> getAccount(
    CustomerAccountParams params,
  );
  Future<Result<void, Failure>> saveMovement(SaveCustomerMovementParams params);
  Future<Result<CustomersPageEntity, Failure>> getCustomers(
    GetCustomersParams params,
  );
  Future<Result<String, Failure>> addCustomer(AddCustomerParams params);
}
