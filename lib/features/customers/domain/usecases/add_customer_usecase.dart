import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/main_use_case.dart';
import '../entities/customer_entity.dart';
import '../repositories/customers_repository.dart';

class AddCustomerParams {
  const AddCustomerParams({
    required this.name,
    this.phone,
    this.description,
    this.openingBalanceMinor = 0,
    required this.dueDate,
    required this.frequency,
    this.repaymentDay,
    required this.requestId,
  });
  final String name;
  final String? phone;
  final String? description;
  final int openingBalanceMinor;
  final DateTime dueDate;
  final RepaymentFrequency frequency;
  final int? repaymentDay;
  // A stable ID per form makes a retry idempotent.
  final String requestId;
}

class AddCustomerUseCase extends UseCase<String, AddCustomerParams> {
  AddCustomerUseCase(this._repository);
  final CustomersRepository _repository;
  @override
  Future<Result<String, Failure>> call(AddCustomerParams params) =>
      _repository.addCustomer(params);
}
