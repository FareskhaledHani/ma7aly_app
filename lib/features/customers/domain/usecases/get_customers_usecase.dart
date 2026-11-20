import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/main_use_case.dart';
import '../entities/customer_entity.dart';
import '../entities/customers_page_entity.dart';
import '../repositories/customers_repository.dart';

class GetCustomersParams {
  const GetCustomersParams({
    this.query = '',
    this.filter = CustomerFilter.all,
    this.cursor,
    this.pageSize = 20,
    required this.today,
  });
  final String query;
  final CustomerFilter filter;
  final CustomerCursor? cursor;
  final int pageSize;
  final DateTime today;
}

class GetCustomersUseCase
    extends UseCase<CustomersPageEntity, GetCustomersParams> {
  GetCustomersUseCase(this._repository);
  final CustomersRepository _repository;
  @override
  Future<Result<CustomersPageEntity, Failure>> call(
    GetCustomersParams params,
  ) => _repository.getCustomers(params);
}
