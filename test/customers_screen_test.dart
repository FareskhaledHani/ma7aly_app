import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ma7aly_app/app_injector.dart';
import 'package:ma7aly_app/app_shell.dart';
import 'package:ma7aly_app/config/routes/app_navigator.dart';
import 'package:ma7aly_app/config/routes/route_generator.dart';
import 'package:ma7aly_app/config/theme/app_theme.dart';
import 'package:ma7aly_app/core/helpers/l10n.dart';
import 'package:ma7aly_app/features/customers/domain/usecases/add_customer_usecase.dart';
import 'package:ma7aly_app/features/customers/domain/usecases/get_customers_usecase.dart';
import 'package:ma7aly_app/features/customers/domain/entities/customer_entity.dart';
import 'package:ma7aly_app/features/customers/presentation/cubit/add_customer_cubit.dart';
import 'package:ma7aly_app/features/customers/presentation/cubit/customers_cubit.dart';
import 'package:ma7aly_app/features/customers/presentation/widgets/customer_card.dart';

import 'support/fake_customers_repository.dart';
import 'support/fake_home_repository.dart';

import 'package:ma7aly_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:ma7aly_app/features/home/domain/usecases/get_home_overview_usecase.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FakeCustomersRepository repository;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });
  setUp(() {
    repository = FakeCustomersRepository();
    getIt.registerFactory(
      () => HomeCubit(
        GetHomeOverviewUseCase(
          FakeHomeRepository(),
          GetCustomersUseCase(repository),
        ),
      ),
    );
    getIt.registerFactory(
      () => CustomersCubit(GetCustomersUseCase(repository)),
    );
    getIt.registerFactory(
      () => AddCustomerCubit(AddCustomerUseCase(repository)),
    );
  });
  tearDown(() => getIt.reset());

  for (final language in ['ar', 'en']) {
    testWidgets('Customer creation returns to refreshed list in $language', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final ar = language == 'ar';
      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: L10n.all,
          path: L10n.languagePath,
          startLocale: Locale(language),
          fallbackLocale: L10n.arabic,
          saveLocale: false,
          child: ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, _) => MaterialApp(
              theme: AppTheme.talabyDashboardTheme,
              navigatorKey: AppNavigator.navigatorKey,
              onGenerateRoute: RouteGenerator.getRoute,
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              home: const AppShell(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text(ar ? 'الزباين' : 'Customers'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          ar
              ? 'لسه مفيش زباين. أضف أول زبون علشان تبدأ.'
              : 'No customers yet. Add your first customer to get started.',
        ),
        findsOneWidget,
      );
      await tester.tap(
        find.widgetWithText(
          ElevatedButton,
          ar ? '+ إضافة زبون' : '+ Add customer',
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).at(0), 'QA Customer');
      await tester.enterText(find.byType(TextFormField).at(1), '٠١٠١٢٣٤٥٦٧٨');
      await tester.enterText(find.byType(TextFormField).at(3), '١٢٠٫٣٥');
      final frequency = find.byType(
        DropdownButtonFormField<RepaymentFrequency>,
      );
      await tester.ensureVisible(frequency);
      await tester.tap(frequency);
      await tester.pumpAndSettle();
      await tester.tap(find.text(ar ? 'تاريخ محدد' : 'Specific date').last);
      await tester.pumpAndSettle();
      expect(find.byType(DropdownButtonFormField<int>), findsNothing);
      final save = find.widgetWithText(
        ElevatedButton,
        ar ? 'حفظ الزبون' : 'Save customer',
      );
      await tester.ensureVisible(save);
      await tester.tap(save);
      await tester.pumpAndSettle();
      expect(repository.addCalls, 1);
      expect(repository.items.single.openingBalanceMinor, 12035);
      expect(repository.items.single.phone, '01012345678');
      expect(repository.items.single.frequency, RepaymentFrequency.once);
      expect(repository.items.single.repaymentDay, isNull);
      expect(find.byType(CustomerCard), findsOneWidget);
      expect(find.text('QA Customer'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
