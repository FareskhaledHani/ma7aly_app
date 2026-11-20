import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ma7aly_app/app_injector.dart';
import 'package:ma7aly_app/app_shell.dart';
import 'package:ma7aly_app/config/routes/app_navigator.dart';
import 'package:ma7aly_app/core/utils/app_strings.dart';
import 'package:ma7aly_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:ma7aly_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:ma7aly_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:ma7aly_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ma7aly_app/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:ma7aly_app/features/customers/domain/entities/customer_entity.dart';
import 'package:ma7aly_app/features/customers/domain/usecases/get_customers_usecase.dart';
import 'package:ma7aly_app/features/customers/domain/usecases/get_customer_account_usecase.dart';
import 'package:ma7aly_app/features/customers/domain/usecases/save_customer_movement_usecase.dart';
import 'package:ma7aly_app/features/customers/presentation/cubit/customers_cubit.dart';
import 'package:ma7aly_app/features/customers/presentation/cubit/customer_account_cubit.dart';
import 'package:ma7aly_app/features/customers/presentation/cubit/save_customer_movement_cubit.dart';
import 'package:ma7aly_app/features/products/domain/entities/product_entity.dart';
import 'package:ma7aly_app/features/products/domain/usecases/get_products_usecase.dart';
import 'package:ma7aly_app/features/products/domain/usecases/add_product_usecase.dart';
import 'package:ma7aly_app/features/products/presentation/cubit/products_cubit.dart';
import 'package:ma7aly_app/features/products/presentation/cubit/add_product_cubit.dart';
import 'package:ma7aly_app/features/settings/domain/usecases/load_settings_usecase.dart';
import 'package:ma7aly_app/features/settings/domain/usecases/save_settings_usecase.dart';
import 'package:ma7aly_app/features/settings/domain/usecases/sign_out_usecase.dart';
import 'package:ma7aly_app/features/settings/domain/usecases/export_accounts_usecase.dart';
import 'package:ma7aly_app/features/settings/presentation/cubit/settings_cubit.dart';

import 'support/fake_auth_repository.dart';
import 'support/fake_customers_repository.dart';
import 'support/fake_home_repository.dart';

import 'package:ma7aly_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:ma7aly_app/features/home/domain/usecases/get_home_overview_usecase.dart';

import 'support/fake_products_repository.dart';
import 'support/fake_settings_repository.dart';
import 'support/test_app.dart';
import 'support/file_test_asset_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late FakeCustomersRepository customers;
  late FakeProductsRepository products;
  late FakeSettingsRepository settings;
  late FakeAuthRepository auth;
  late AssetLoader assetLoader;
  setUpAll(() async {
    assetLoader = FileTestAssetLoader();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });
  setUp(() {
    AppNavigator.navigatorKey = GlobalKey<NavigatorState>();
    customers = FakeCustomersRepository();
    getIt.registerFactory(
      () => HomeCubit(
        GetHomeOverviewUseCase(
          FakeHomeRepository(),
          GetCustomersUseCase(customers),
        ),
      ),
    );
    products = FakeProductsRepository();
    settings = FakeSettingsRepository();
    auth = FakeAuthRepository();
    getIt.registerFactory(
      () => AuthCubit(SignInUseCase(auth), RegisterUseCase(auth)),
    );
    getIt.registerFactory(() => PasswordResetCubit(ResetPasswordUseCase(auth)));
    customers.items.add(
      CustomerEntity(
        id: 'c' * 22,
        name: 'QA Customer',
        openingBalanceMinor: 12000,
        dueDate: DateTime(2026, 11, 1),
        frequency: RepaymentFrequency.once,
      ),
    );
    products.items.add(
      ProductEntity(
        id: 'p' * 22,
        name: 'QA Sugar',
        unit: 'kg',
        priceMinor: 3500,
        trackInventory: true,
        stockMilli: 1000,
      ),
    );
    getIt.registerFactory(() => CustomersCubit(GetCustomersUseCase(customers)));
    getIt.registerFactory(
      () => CustomerAccountCubit(GetCustomerAccountUseCase(customers)),
    );
    getIt.registerFactory(
      () => SaveCustomerMovementCubit(SaveCustomerMovementUseCase(customers)),
    );
    getIt.registerFactory(() => ProductsCubit(GetProductsUseCase(products)));
    getIt.registerFactory(() => AddProductCubit(AddProductUseCase(products)));
    getIt.registerFactory(
      () => SettingsCubit(
        LoadSettingsUseCase(settings),
        SaveSettingsUseCase(settings),
        SignOutUseCase(settings),
        ExportAccountsUseCase(customers),
        ResetPasswordUseCase(auth),
      ),
    );
  });
  tearDown(() => getIt.reset());
  Future<void> showShop(WidgetTester tester, String language) async {
    await tester.pumpWidget(
      TestApp(
        locale: Locale(language),
        assetLoader: assetLoader,
        child: const AppShell(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Capture README screenshots with demo data', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final fonts = FontLoader('Cairo')
      ..addFont(rootBundle.load('assets/fonts/Cairo.ttf'));
    await fonts.load();
    await showShop(tester, 'ar');
    await expectLater(
      find.byType(AppShell),
      matchesGoldenFile('../docs/screenshots/home-ar.png'),
    );
    await tester.tap(find.text(AppStrings.customersTab.tr()));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(AppShell),
      matchesGoldenFile('../docs/screenshots/customers-ar.png'),
    );
    await tester.tap(find.text(AppStrings.productsTab.tr()));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(AppShell),
      matchesGoldenFile('../docs/screenshots/products-ar.png'),
    );
    await tester.tap(find.text(AppStrings.settingsTab.tr()));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(AppShell),
      matchesGoldenFile('../docs/screenshots/settings-ar.png'),
    );
    expect(tester.takeException(), isNull);
  });
}
