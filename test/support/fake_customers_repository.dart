import 'package:ma7aly_app/core/errors/failures.dart';
import 'package:ma7aly_app/features/customers/domain/entities/customer_entity.dart';
import 'package:ma7aly_app/features/customers/domain/entities/customers_page_entity.dart';
import 'package:ma7aly_app/features/customers/domain/repositories/customers_repository.dart';
import 'package:ma7aly_app/features/customers/domain/usecases/add_customer_usecase.dart';
import 'package:ma7aly_app/features/customers/domain/usecases/get_customers_usecase.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:ma7aly_app/features/customers/domain/entities/customer_account_entity.dart';
import 'package:ma7aly_app/features/customers/domain/entities/customer_movement_entity.dart';
import 'package:ma7aly_app/features/customers/domain/usecases/get_customer_account_usecase.dart';
import 'package:ma7aly_app/features/customers/domain/usecases/save_customer_movement_usecase.dart';

class FakeCustomersRepository implements CustomersRepository {
  final movements = <String, List<CustomerMovementEntity>>{};
  Future<Result<void, Failure>> Function(SaveCustomerMovementParams)?
  movementResponse;
  int movementCalls = 0;
  @override
  Future<Result<CustomerAccountEntity, Failure>> getAccount(
    CustomerAccountParams params,
  ) async => Success(
    CustomerAccountEntity(
      customer: items.firstWhere((c) => c.id == params.customerId),
      movements: List.of(movements[params.customerId] ?? []),
    ),
  );
  @override
  Future<Result<void, Failure>> saveMovement(
    SaveCustomerMovementParams params,
  ) async {
    movementCalls++;
    if (movementResponse != null) return movementResponse!(params);
    final entries = movements.putIfAbsent(params.customerId, () => []);
    entries.removeWhere((m) => m.id == params.movement.id);
    if (!params.delete) entries.insert(0, params.movement);
    return const Success(null);
  }

  final items = <CustomerEntity>[];
  int addCalls = 0;
  final requests = <GetCustomersParams>[];
  Future<Result<String, Failure>>? saveResponse;
  Future<Result<CustomersPageEntity, Failure>> Function(GetCustomersParams)?
  pageResponse;
  @override
  Future<Result<CustomersPageEntity, Failure>> getCustomers(
    GetCustomersParams params,
  ) {
    requests.add(params);
    return pageResponse?.call(params) ??
        Future.value(
          Success(
            CustomersPageEntity(
              items: List.of(items),
              hasMore: false,
              totalCount: items.length,
            ),
          ),
        );
  }

  @override
  Future<Result<String, Failure>> addCustomer(AddCustomerParams params) {
    addCalls++;
    if (saveResponse != null) return saveResponse!;
    items.add(
      CustomerEntity(
        id: params.requestId,
        name: params.name,
        phone: params.phone,
        description: params.description,
        openingBalanceMinor: params.openingBalanceMinor,
        dueDate: params.dueDate,
        frequency: params.frequency,
        repaymentDay: params.repaymentDay,
      ),
    );
    return Future.value(Success(params.requestId));
  }
}
