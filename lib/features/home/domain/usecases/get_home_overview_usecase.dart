import 'package:multiple_result/multiple_result.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/use_cases/main_use_case.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../customers/domain/entities/customer_entity.dart';
import '../../../customers/domain/entities/customers_page_entity.dart';
import '../../../customers/domain/usecases/get_customers_usecase.dart';
import '../entities/home_overview_entity.dart';
import '../entities/home_follow_up_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeOverviewUseCase extends UseCase<HomeOverviewEntity, DateTime> {
  GetHomeOverviewUseCase(this._home, this._customers);
  final HomeRepository _home;
  final GetCustomersUseCase _customers;

  @override
  Future<Result<HomeOverviewEntity, Failure>> call(DateTime today) async {
    final identityResult = await _home.getIdentity();
    final identity = identityResult.when((value) => value, (_) => null);
    if (identity == null) {
      return identityResult.when(
        (_) =>
            const Error(ServerFailure(message: AppStrings.somethingWentWrong)),
        (failure) => Error(failure),
      );
    }
    final customers = <CustomerEntity>[];
    CustomerCursor? cursor;
    while (true) {
      final result = await _customers(
        GetCustomersParams(today: today, cursor: cursor, pageSize: 50),
      );
      final page = result.when((value) => value, (_) => null);
      if (page == null) {
        return result.when(
          (_) => const Error(
            ServerFailure(message: AppStrings.somethingWentWrong),
          ),
          (failure) => Error(failure),
        );
      }
      customers.addAll(page.items);
      if (!page.hasMore) break;
      final next = page.nextCursor;
      if (next == null ||
          next.id == cursor?.id && next.value == cursor?.value) {
        return const Error(
          ServerFailure(message: AppStrings.somethingWentWrong),
        );
      }
      cursor = next;
    }
    final followUp =
        customers
            .where((c) => c.statusAt(today) != CustomerStatus.regular)
            .toList()
          ..sort((a, b) {
            final aOverdue = a.statusAt(today) == CustomerStatus.overdue;
            final bOverdue = b.statusAt(today) == CustomerStatus.overdue;
            if (aOverdue != bOverdue) return aOverdue ? -1 : 1;
            final date = a.dueDateAt(today).compareTo(b.dueDateAt(today));
            return date != 0 ? date : a.id.compareTo(b.id);
          });
    return Success(
      HomeOverviewEntity(
        identity: identity,
        today: today,
        outstandingMinor: customers
            .where((c) => c.balanceMinor > 0)
            .fold(0, (sum, c) => sum + c.balanceMinor),
        openAccounts: customers.where((c) => c.balanceMinor > 0).length,
        paymentsMinor: customers.fold(
          0,
          (sum, c) => sum + c.monthlyPaymentsMinor,
        ),
        withdrawalsMinor: customers.fold(
          0,
          (sum, c) => sum + c.monthlyWithdrawalsMinor,
        ),
        followUp: List.unmodifiable(
          followUp.map((c) => HomeFollowUpEntity(c, today)),
        ),
      ),
    );
  }
}
