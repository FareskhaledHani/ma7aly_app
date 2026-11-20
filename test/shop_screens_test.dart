import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ma7aly_app/app_injector.dart';
import 'package:ma7aly_app/app_shell.dart';
import 'package:ma7aly_app/config/routes/app_navigator.dart';
import 'package:ma7aly_app/core/errors/failures.dart';
import 'package:ma7aly_app/core/utils/app_strings.dart';
import 'package:ma7aly_app/core/widgets/money_panel.dart';
import 'package:ma7aly_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:ma7aly_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:ma7aly_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:ma7aly_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ma7aly_app/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:ma7aly_app/features/auth/presentation/screens/welcome_screen.dart';
import 'package:ma7aly_app/features/customers/domain/entities/customer_entity.dart';
import 'package:ma7aly_app/features/customers/domain/usecases/get_customers_usecase.dart';
import 'package:ma7aly_app/features/customers/domain/usecases/get_customer_account_usecase.dart';
import 'package:ma7aly_app/features/customers/domain/usecases/save_customer_movement_usecase.dart';
import 'package:ma7aly_app/features/customers/presentation/cubit/customers_cubit.dart';
import 'package:ma7aly_app/features/customers/presentation/cubit/customer_account_cubit.dart';
import 'package:ma7aly_app/features/customers/presentation/cubit/save_customer_movement_cubit.dart';
import 'package:ma7aly_app/features/customers/presentation/widgets/payment_receipt_dialog.dart';
import 'package:ma7aly_app/features/products/domain/entities/product_entity.dart';
import 'package:ma7aly_app/features/products/domain/usecases/get_products_usecase.dart';
import 'package:ma7aly_app/features/products/domain/usecases/add_product_usecase.dart';
import 'package:ma7aly_app/features/products/presentation/cubit/products_cubit.dart';
import 'package:ma7aly_app/features/products/presentation/cubit/add_product_cubit.dart';
import 'package:ma7aly_app/features/products/presentation/widgets/product_card.dart';
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

  for (final language in ['ar', 'en']) {
    testWidgets(
      'Settings menu, product filters and logout are connected in $language',
      (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        String? clipboard;
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (call) async {
            if (call.method == 'Clipboard.setData') {
              clipboard = (call.arguments as Map)['text'] as String;
            }
            return null;
          },
        );
        addTearDown(
          () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            SystemChannels.platform,
            null,
          ),
        );
        products.items.addAll([
          ProductEntity(
            id: 'b' * 22,
            name: 'QA Biscuit',
            unit: 'pack',
            priceMinor: 1200,
          ),
          ProductEntity(
            id: 'l' * 22,
            name: 'QA Low',
            unit: 'kg',
            priceMinor: 3200,
            trackInventory: true,
            stockMilli: 1000,
            lowStockMilli: 2000,
          ),
        ]);
        await showShop(tester, language);
        await tester.tap(find.text(AppStrings.productsTab.tr()));
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppStrings.productsPricesOnly.tr()));
        await tester.pumpAndSettle();
        expect(find.text('QA Biscuit'), findsOneWidget);
        expect(find.byType(ProductCard), findsOneWidget);
        await tester.tap(find.text(AppStrings.productsLow.tr()));
        await tester.pumpAndSettle();
        expect(find.text('QA Low'), findsOneWidget);
        expect(find.byType(ProductCard), findsOneWidget);
        await tester.enterText(find.byType(TextField).first, 'No such product');
        await tester.pump(const Duration(milliseconds: 350));
        await tester.pumpAndSettle();
        expect(find.text(AppStrings.productsEmpty.tr()), findsOneWidget);
        await tester.enterText(find.byType(TextField).first, '');
        await tester.pump(const Duration(milliseconds: 350));
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppStrings.productsAll.tr()));
        await tester.pumpAndSettle();
        expect(find.byType(ProductCard), findsNWidgets(3));

        await tester.tap(find.text(AppStrings.settingsTab.tr()));
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppStrings.shopData.tr()));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byType(TextFormField).at(0),
          'Updated QA shop',
        );
        await tester.enterText(find.byType(TextFormField).at(1), '٠١٠١٢٣٤٥٦٧٨');
        final save = find.widgetWithText(
          ElevatedButton,
          AppStrings.saveSettings.tr(),
        );
        await tester.ensureVisible(save);
        await tester.tap(save);
        await tester.pumpAndSettle();
        expect(find.text('Updated QA shop'), findsOneWidget);
        expect(settings.value.phone, '01012345678');
        await tester.tap(find.text(AppStrings.inventorySettings.tr()));
        await tester.pumpAndSettle();
        expect(find.byType(ProductCard), findsNWidgets(3));
        await tester.tap(find.text(AppStrings.settingsTab.tr()));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text(AppStrings.exportAccounts.tr()));
        await tester.tap(find.text(AppStrings.exportAccounts.tr()));
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppStrings.cancel.tr()));
        await tester.pumpAndSettle();
        expect(clipboard, isNull);
        await tester.tap(find.text(AppStrings.exportAccounts.tr()));
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppStrings.confirm.tr()));
        await tester.pumpAndSettle();
        expect(clipboard, contains('QA Customer'));
        await tester.pump(const Duration(seconds: 5));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text(AppStrings.securitySettings.tr()));
        await tester.tap(find.text(AppStrings.securitySettings.tr()));
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppStrings.confirm.tr()));
        await tester.pumpAndSettle();
        expect(auth.resetCalls, 1);
        await tester.pump(const Duration(seconds: 5));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text(AppStrings.help.tr()));
        await tester.tap(find.text(AppStrings.help.tr()));
        await tester.pumpAndSettle();
        expect(find.text(AppStrings.helpBody.tr()), findsOneWidget);
        await tester.tap(find.text(AppStrings.done.tr()));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text(AppStrings.language.tr()));
        await tester.tap(find.text(AppStrings.language.tr()));
        await tester.pumpAndSettle();
        expect(
          find.text(language == 'ar' ? 'Shop settings' : 'إعدادات المحل'),
          findsOneWidget,
        );
        await tester.ensureVisible(find.text(AppStrings.language.tr()));
        await tester.tap(find.text(AppStrings.language.tr()));
        await tester.pumpAndSettle();
        expect(
          find.text(language == 'ar' ? 'إعدادات المحل' : 'Shop settings'),
          findsOneWidget,
        );
        await tester.ensureVisible(
          find.widgetWithText(ElevatedButton, AppStrings.signOut.tr()),
        );
        await tester.tap(
          find.widgetWithText(ElevatedButton, AppStrings.signOut.tr()),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppStrings.confirm.tr()));
        await tester.pumpAndSettle();
        expect(settings.signedOut, isTrue);
        expect(find.byType(WelcomeScreen), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
    testWidgets('Product loading errors can be retried in $language', (
      tester,
    ) async {
      await showShop(tester, language);
      products.pageResponse = (_) async =>
          const Error(ServerFailure(message: AppStrings.noInternetConnection));
      await tester.tap(find.text(AppStrings.productsTab.tr()));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.noInternetConnection.tr()), findsOneWidget);
      products.pageResponse = null;
      await tester.tap(
        find.widgetWithText(ElevatedButton, AppStrings.retry.tr()),
      );
      await tester.pumpAndSettle();
      expect(find.text('QA Sugar'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
    testWidgets(
      'Products, overpayment confirmation and shop settings work in $language',
      (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await showShop(tester, language);
        await tester.tap(find.text(AppStrings.productsTab.tr()));
        await tester.pumpAndSettle();
        expect(find.byType(ProductCard), findsOneWidget);
        await tester.tap(
          find.widgetWithText(ElevatedButton, AppStrings.addProduct.tr()),
        );
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextFormField).at(0), 'QA Rice');
        await tester.enterText(find.byType(TextFormField).at(1), 'kg');
        await tester.enterText(find.byType(TextFormField).at(2), '32');
        await tester.enterText(find.byType(TextFormField).at(3), '28');
        await tester.enterText(find.byType(TextFormField).at(4), '25');
        await tester.enterText(find.byType(TextFormField).at(5), '5');
        final saveProduct = find.widgetWithText(
          ElevatedButton,
          AppStrings.saveProduct.tr(),
        );
        await tester.ensureVisible(saveProduct);
        await tester.tap(saveProduct);
        await tester.pumpAndSettle();
        expect(products.addCalls, 1);
        expect(products.items.last.stockMilli, 25000);
        expect(products.items.last.priceMinor, 3200);
        expect(find.byType(ProductCard), findsNWidgets(2));

        await tester.tap(find.text(AppStrings.customersTab.tr()));
        await tester.pumpAndSettle();
        await tester.tap(find.text('QA Customer'));
        await tester.pumpAndSettle();
        customers.movementResponse = (params) async {
          if (!params.confirmNegativeStock) {
            return const Error(
              ServerFailure(message: AppStrings.confirmNegativeStock),
            );
          }
          customers.movements
              .putIfAbsent(params.customerId, () => [])
              .insert(0, params.movement);
          return const Success(null);
        };
        await tester.tap(
          find.widgetWithText(ElevatedButton, AppStrings.addWithdrawal.tr()),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppStrings.selectProduct.tr()));
        await tester.pumpAndSettle();
        await tester.tap(find.text('QA Sugar'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextFormField).at(0), '2');
        await tester.pumpAndSettle();
        expect(
          tester.widget<MoneyPanel>(find.byType(MoneyPanel)).amountMinor,
          7000,
        );
        final saveWithdrawal = find.widgetWithText(
          ElevatedButton,
          AppStrings.saveWithdrawal.tr(),
        );
        await tester.ensureVisible(saveWithdrawal);
        await tester.tap(saveWithdrawal);
        await tester.pumpAndSettle();
        expect(find.text(AppStrings.confirmNegativeStock.tr()), findsOneWidget);
        await tester.tap(find.text(AppStrings.confirm.tr()));
        await tester.pumpAndSettle();
        expect(customers.movements.values.single.single.amountMinor, 7000);
        customers.movementResponse = null;
        await tester.ensureVisible(find.text('QA Sugar'));
        await tester.tap(find.text('QA Sugar'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextFormField).at(0), '1');
        final edit = find.widgetWithText(
          ElevatedButton,
          AppStrings.saveChanges.tr(),
        );
        await tester.ensureVisible(edit);
        await tester.tap(edit);
        await tester.pumpAndSettle();
        expect(customers.movements.values.single.single.amountMinor, 3500);
        await tester.ensureVisible(find.text('QA Sugar'));
        await tester.tap(find.text('QA Sugar'));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text(AppStrings.deleteMovement.tr()));
        await tester.tap(find.text(AppStrings.deleteMovement.tr()));
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppStrings.confirm.tr()));
        await tester.pumpAndSettle();
        expect(customers.movements.values.single, isEmpty);
        await tester.tap(
          find.widgetWithText(ElevatedButton, AppStrings.recordPayment.tr()),
        );
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextFormField).first, '200');
        SaveCustomerMovementParams? saved;
        customers.movementResponse = (params) async {
          if (!params.confirmCredit) {
            return const Error(
              ServerFailure(message: AppStrings.confirmCredit),
            );
          }
          saved = params;
          return const Success(null);
        };
        final savePayment = find.widgetWithText(
          ElevatedButton,
          AppStrings.confirmPayment.tr(),
        );
        await tester.ensureVisible(savePayment);
        await tester.tap(savePayment);
        await tester.pumpAndSettle();
        expect(find.text(AppStrings.confirmCredit.tr()), findsOneWidget);
        expect(saved, isNull);
        await tester.tap(find.text(AppStrings.confirm.tr()));
        await tester.pumpAndSettle();
        expect(saved?.confirmCredit, isTrue);
        expect(saved?.movement.amountMinor, 20000);
        expect(find.byType(PaymentReceiptDialog), findsOneWidget);
        await tester.tap(find.text(AppStrings.done.tr()));
        await tester.pumpAndSettle();
        final backLabel = MaterialLocalizations.of(
          tester.element(find.byType(Scaffold).last),
        ).backButtonTooltip;
        await tester.tap(find.byTooltip(backLabel));
        await tester.pumpAndSettle();

        await tester.tap(find.text(AppStrings.settingsTab.tr()));
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppStrings.customerFollowUp.tr()));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextFormField).at(0), '25');
        await tester.enterText(find.byType(TextFormField).at(1), '5');
        final saveSettings = find.widgetWithText(
          ElevatedButton,
          AppStrings.saveSettings.tr(),
        );
        await tester.ensureVisible(saveSettings);
        await tester.tap(saveSettings);
        await tester.pumpAndSettle();
        expect(settings.value.minimumPaymentPercent, 25);
        expect(settings.value.warningDays, 5);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
