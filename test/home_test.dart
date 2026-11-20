import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ma7aly_app/app_injector.dart';
import 'package:ma7aly_app/config/routes/app_navigator.dart';
import 'package:ma7aly_app/core/enums/async_status.dart';
import 'package:ma7aly_app/core/errors/failures.dart';
import 'package:ma7aly_app/core/utils/app_strings.dart';
import 'package:ma7aly_app/features/customers/domain/entities/customer_entity.dart';
import 'package:ma7aly_app/features/customers/domain/entities/customers_page_entity.dart';
import 'package:ma7aly_app/features/customers/domain/usecases/get_customers_usecase.dart';
import 'package:ma7aly_app/features/home/domain/usecases/get_home_overview_usecase.dart';
import 'package:ma7aly_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:ma7aly_app/features/home/presentation/screen/home_screen.dart';
import 'package:ma7aly_app/features/home/presentation/widgets/home_follow_up_card.dart';

import 'support/fake_customers_repository.dart';
import 'support/fake_home_repository.dart';
import 'support/file_test_asset_loader.dart';
import 'support/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final today = DateTime(2026, 11, 2);
  late FakeCustomersRepository customers;
  late FakeHomeRepository home;
  late GetHomeOverviewUseCase useCase;
  CustomerEntity customer(
    String id,
    int balance,
    DateTime due, {
    int payments = 0,
    int withdrawals = 0,
  }) => CustomerEntity(
    id: id,
    name: id,
    openingBalanceMinor: balance,
    dueDate: due,
    frequency: RepaymentFrequency.once,
    monthlyPaymentsMinor: payments,
    monthlyWithdrawalsMinor: withdrawals,
  );
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });
  setUp(() {
    AppNavigator.navigatorKey = GlobalKey<NavigatorState>();
    customers = FakeCustomersRepository();
    home = FakeHomeRepository();
    useCase = GetHomeOverviewUseCase(home, GetCustomersUseCase(customers));
    getIt.registerFactory(() => HomeCubit(useCase, clock: () => today));
  });
  tearDown(() => getIt.reset());

  test(
    'Overview covers all pages, keeps credit separate and orders follow-up',
    () async {
      customers.pageResponse = (params) async => Success(
        params.cursor == null
            ? CustomersPageEntity(
                items: [
                  customer(
                    'upcoming',
                    60000,
                    DateTime(2026, 11, 5),
                    payments: 4000,
                    withdrawals: 10000,
                  ),
                ],
                hasMore: true,
                nextCursor: const CustomerCursor(
                  value: 'upcoming',
                  id: 'upcoming',
                ),
              )
            : CustomersPageEntity(
                items: [
                  customer(
                    'overdue',
                    120000,
                    DateTime(2026, 11, 1),
                    payments: 8000,
                    withdrawals: 20000,
                  ),
                  customer('credit', -30000, DateTime(2026, 10, 1)),
                ],
                hasMore: false,
              ),
      );
      final result = await useCase(today);
      result.when((value) {
        expect(value.outstandingMinor, 180000);
        expect(value.openAccounts, 2);
        expect(value.paymentsMinor, 12000);
        expect(value.withdrawalsMinor, 30000);
        expect(value.followUp.map((c) => c.id), ['overdue', 'upcoming']);
        expect(value.followUp.first.paymentPercent, 40);
        expect(value.followUp.first.days, -1);
      }, (failure) => fail(failure.message));
      expect(customers.requests.length, 2);
    },
  );
  test(
    'Later page failures cannot appear as a partial successful total',
    () async {
      customers.pageResponse = (params) async => params.cursor == null
          ? const Success(
              CustomersPageEntity(
                items: [],
                hasMore: true,
                nextCursor: CustomerCursor(value: 'a', id: 'a'),
              ),
            )
          : const Error(
              ServerFailure(message: AppStrings.noInternetConnection),
            );
      final cubit = HomeCubit(useCase, clock: () => today);
      await cubit.load();
      expect(cubit.state.status, AsyncStatus.failure);
      expect(cubit.state.overview, isNull);
      await cubit.close();
    },
  );
  test('Closing while loading does not emit after close', () async {
    final pending = Completer<Result<CustomersPageEntity, Failure>>();
    customers.pageResponse = (_) => pending.future;
    final cubit = HomeCubit(useCase);
    final loading = cubit.load();
    await Future<void>.delayed(Duration.zero);
    await cubit.close();
    pending.complete(
      const Success(CustomersPageEntity(items: [], hasMore: false)),
    );
    await loading;
  });
  for (final language in ['ar', 'en']) {
    testWidgets(
      'Home in $language opens a customer and refreshes the balance',
      (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        customers.items.add(
          customer(
            'QA Customer',
            120000,
            DateTime(2026, 11, 1),
            payments: 4000,
            withdrawals: 10000,
          ),
        );
        String? opened;
        await tester.pumpWidget(
          TestApp(
            locale: Locale(language),
            assetLoader: FileTestAssetLoader(),
            child: Scaffold(
              body: HomeScreen(
                onOpenCustomer: (id) async {
                  opened = id;
                  customers.items.clear();
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('QA Shop'), findsOneWidget);
        expect(find.text(AppStrings.homeOutstanding.tr()), findsOneWidget);
        expect(find.byType(HomeFollowUpCard), findsOneWidget);
        await tester.tap(find.byType(HomeFollowUpCard));
        await tester.pumpAndSettle();
        expect(opened, 'QA Customer');
        expect(find.byType(HomeFollowUpCard), findsNothing);
        expect(find.text(AppStrings.homeNoFollowUp.tr()), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
    testWidgets('Home in $language retries a load failure on a small screen', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      home.response = const Error(
        ServerFailure(message: AppStrings.noInternetConnection),
      );
      await tester.pumpWidget(
        TestApp(
          locale: Locale(language),
          assetLoader: FileTestAssetLoader(),
          child: Scaffold(body: HomeScreen(onOpenCustomer: (_) async {})),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.noInternetConnection.tr()), findsOneWidget);
      home.response = FakeHomeRepository().response;
      await tester.tap(find.text(AppStrings.retry.tr()));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.homeNoFollowUp.tr()), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
