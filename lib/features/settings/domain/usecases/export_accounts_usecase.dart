import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/params/no_params.dart';
import '../../../../core/use_cases/main_use_case.dart';
import '../../../customers/domain/entities/customer_entity.dart';
import '../../../customers/domain/entities/customers_page_entity.dart';
import '../../../customers/domain/repositories/customers_repository.dart';
import '../../../customers/domain/usecases/get_customers_usecase.dart';

class ExportAccountsUseCase extends UseCase<List<CustomerEntity>, NoParams> {
  ExportAccountsUseCase(this._repository);
  final CustomersRepository _repository;
  @override
  Future<Result<List<CustomerEntity>, Failure>> call(NoParams params) async {
    final items = <CustomerEntity>[];
    CustomerCursor? cursor;
    final today = DateTime.now();
    while (true) {
      final result = await _repository.getCustomers(
        GetCustomersParams(today: today, cursor: cursor),
      );
      Failure? error;
      final page = result.when((p) => p, (failure) {
        error = failure;
        return null;
      });
      if (page == null) return Error(error!);
      items.addAll(page.items);
      if (!page.hasMore) return Success(items);
      cursor = page.nextCursor;
    }
  }
}
