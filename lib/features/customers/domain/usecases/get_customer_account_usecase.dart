import 'package:equatable/equatable.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/main_use_case.dart';
import '../entities/customer_account_entity.dart';
import '../repositories/customers_repository.dart';

class CustomerAccountParams extends Equatable {
  const CustomerAccountParams(this.customerId);
  final String customerId;
  @override
  List<Object?> get props => [customerId];
}

class GetCustomerAccountUseCase
    extends UseCase<CustomerAccountEntity, CustomerAccountParams> {
  GetCustomerAccountUseCase(this._repository);
  final CustomersRepository _repository;
  @override
  Future<Result<CustomerAccountEntity, Failure>> call(
    CustomerAccountParams params,
  ) => _repository.getAccount(params);
}
