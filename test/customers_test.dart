import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ma7aly_app/core/errors/failures.dart';
import 'package:ma7aly_app/core/helpers/customer_input.dart';
import 'package:ma7aly_app/features/customers/domain/entities/customer_entity.dart';
import 'package:ma7aly_app/features/customers/domain/entities/customers_page_entity.dart';
import 'package:ma7aly_app/features/customers/domain/usecases/add_customer_usecase.dart';
import 'package:ma7aly_app/features/customers/domain/usecases/get_customers_usecase.dart';
import 'package:ma7aly_app/features/customers/presentation/cubit/add_customer_cubit.dart';
import 'package:ma7aly_app/features/customers/presentation/cubit/add_customer_state.dart';
import 'package:ma7aly_app/features/customers/presentation/cubit/customers_cubit.dart';
import 'package:multiple_result/multiple_result.dart';

import 'support/fake_customers_repository.dart';

void main() {
  test('Amounts stay exact in piastres and support Arabic digits', () {
    expect(CustomerInput.moneyMinor('0.29'), 29);
    expect(CustomerInput.moneyMinor('١٢٠٫٣٥'), 12035);
    expect(CustomerInput.moneyMinor(''), 0);
    expect(CustomerInput.moneyMinor('-10'), isNull);
    expect(CustomerInput.moneyMinor('1.001'), isNull);
    expect(CustomerInput.phoneKey('٠١٠ ١٢٣٤٥٦٧٨'), '01012345678');
    expect(CustomerInput.nameKey('  أَحمد  محمد '), 'احمد محمد');
  });

  test(
    'Follow-up boundaries include three days, exclude exactly 50 percent',
    () {
      final today = DateTime(2026, 11, 2, 23, 59);
      CustomerStatus status(
        int offset, {
        int paid = 40,
        int old = 0,
        int balance = 60,
        int drawn = 100,
      }) => CustomerFollowUpPolicy.evaluate(
        today: today,
        dueDate: DateTime(2026, 11, 2 + offset),
        outstandingMinor: balance,
        carriedDebtMinor: old,
        monthlyWithdrawalsMinor: drawn,
        monthlyPaymentsMinor: paid,
      );
      expect(status(-1), CustomerStatus.overdue);
      expect(status(0), CustomerStatus.upcoming);
      expect(status(3), CustomerStatus.upcoming);
      expect(status(4), CustomerStatus.regular);
      expect(status(-1, paid: 50), CustomerStatus.regular);
      expect(status(-1, paid: 100, old: 100), CustomerStatus.overdue);
      expect(status(-1, drawn: 0, old: 100), CustomerStatus.overdue);
      expect(status(-1, old: 100, balance: 0), CustomerStatus.regular);
    },
  );

  test('Save prevents duplicates and uses the same request ID', () async {
    final repository = FakeCustomersRepository();
    final response = Completer<Result<String, Failure>>();
    repository.saveResponse = response.future;
    final cubit = AddCustomerCubit(AddCustomerUseCase(repository));
    final params = AddCustomerParams(
      name: 'Test',
      dueDate: DateTime(2026, 11, 2),
      frequency: RepaymentFrequency.once,
      requestId: '1234567890123456789012',
    );
    final save = cubit.save(params);
    await cubit.save(params);
    expect(repository.addCalls, 1);
    response.complete(const Success('1234567890123456789012'));
    await save;
    expect(cubit.state, isA<AddCustomerSuccess>());
    await cubit.save(params);
    expect(repository.addCalls, 1);
    await cubit.close();
  });

  test(
    'A refreshed query ignores stale pages and keeps the new count',
    () async {
      final repository = FakeCustomersRepository();
      final old = Completer<Result<CustomersPageEntity, Failure>>();
      repository.pageResponse = (params) => params.filter == CustomerFilter.all
          ? old.future
          : Future.value(
              const Success(
                CustomersPageEntity(items: [], hasMore: false, totalCount: 7),
              ),
            );
      final cubit = CustomersCubit(GetCustomersUseCase(repository));
      cubit.paging.fetchNextPage();
      cubit.filter(CustomerFilter.overdue);
      cubit.paging.fetchNextPage();
      await Future<void>.delayed(Duration.zero);
      old.complete(
        const Success(
          CustomersPageEntity(items: [], hasMore: false, totalCount: 99),
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.totalCount, 7);
      expect(cubit.state.filter, CustomerFilter.overdue);
      await cubit.close();
    },
  );

  test(
    'Paging errors remain recoverable without an unhandled exception',
    () async {
      final repository = FakeCustomersRepository();
      repository.pageResponse = (_) => Future.value(
        const Error(ServerFailure(message: 'noInternetConnection')),
      );
      final cubit = CustomersCubit(GetCustomersUseCase(repository));
      cubit.paging.fetchNextPage();
      await Future<void>.delayed(Duration.zero);
      expect(cubit.paging.value.error, isA<CustomersPageException>());
      repository.pageResponse = null;
      cubit.paging.fetchNextPage();
      await Future<void>.delayed(Duration.zero);
      expect(cubit.paging.value.error, isNull);
      await cubit.close();
    },
  );
}
