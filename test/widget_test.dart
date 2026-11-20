import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ma7aly_app/app.dart';
import 'package:ma7aly_app/core/helpers/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ma7aly_app/app_injector.dart';
import 'package:ma7aly_app/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:ma7aly_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:ma7aly_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:ma7aly_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ma7aly_app/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:ma7aly_app/features/auth/presentation/widgets/login_form.dart';
import 'package:ma7aly_app/features/auth/presentation/widgets/register_form.dart';

import 'support/fake_auth_repository.dart';
import 'support/fake_customers_repository.dart';
import 'support/fake_home_repository.dart';

import 'package:ma7aly_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:ma7aly_app/features/home/domain/usecases/get_home_overview_usecase.dart';
import 'package:ma7aly_app/features/home/presentation/screen/home_screen.dart';

import 'package:ma7aly_app/features/customers/domain/usecases/get_customers_usecase.dart';
import 'package:ma7aly_app/features/customers/presentation/cubit/customers_cubit.dart';

void main() {
  late FakeAuthRepository repository;
  setUp(() {
    repository = FakeAuthRepository();
    getIt.registerFactory(
      () => HomeCubit(
        GetHomeOverviewUseCase(
          FakeHomeRepository(),
          GetCustomersUseCase(FakeCustomersRepository()),
        ),
      ),
    );
    getIt.registerFactory(
      () => CustomersCubit(GetCustomersUseCase(FakeCustomersRepository())),
    );
    getIt.registerFactory(
      () => AuthCubit(SignInUseCase(repository), RegisterUseCase(repository)),
    );
    getIt.registerFactory(
      () => PasswordResetCubit(ResetPasswordUseCase(repository)),
    );
  });
  tearDown(() => getIt.reset());
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });
  for (final locale in [L10n.arabic, const Locale('en')]) {
    testWidgets('Welcome fits a small phone in ${locale.languageCode}', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: L10n.all,
          path: L10n.languagePath,
          startLocale: locale,
          saveLocale: false,
          fallbackLocale: L10n.arabic,
          child: const TalabyDashboardApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('MA7ALY'), findsOneWidget);
      expect(
        find.text(
          locale.languageCode == 'ar'
              ? 'دفتر محلّك،\nدايمًا معاك.'
              : 'Your shop ledger,\nalways with you.',
        ),
        findsOneWidget,
      );

      expect(tester.takeException(), isNull);

      final login = find.widgetWithText(
        ElevatedButton,
        locale.languageCode == 'ar' ? 'تسجيل الدخول' : 'Sign in',
      );
      await tester.ensureVisible(login);
      await tester.tap(login);
      await tester.pumpAndSettle();
      expect(repository.signInCalls, 0);
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'private-value');
      await tester.ensureVisible(
        find.text(locale.languageCode == 'ar' ? 'إظهار' : 'Show'),
      );
      await tester.tap(
        find.text(locale.languageCode == 'ar' ? 'إظهار' : 'Show'),
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField).at(1)).obscureText,
        isFalse,
      );

      await tester.ensureVisible(
        find.text(
          locale.languageCode == 'ar'
              ? 'معندكش حساب؟ إنشاء حساب جديد'
              : 'New here? Create an account',
        ),
      );
      await tester.tap(
        find.text(
          locale.languageCode == 'ar'
              ? 'معندكش حساب؟ إنشاء حساب جديد'
              : 'New here? Create an account',
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(RegisterForm), findsOneWidget);
      expect(find.byType(LoginForm), findsNothing);
      final create = find.widgetWithText(
        ElevatedButton,
        locale.languageCode == 'ar' ? 'إنشاء حساب جديد' : 'Create an account',
      );
      await tester.ensureVisible(create);
      await tester.tap(create);
      await tester.pumpAndSettle();
      expect(repository.registerCalls, 0);
      expect(tester.takeException(), isNull);
      await tester.enterText(find.byType(TextFormField).at(0), 'QA User');
      await tester.enterText(find.byType(TextFormField).at(1), '01000000000');
      await tester.enterText(
        find.byType(TextFormField).at(2),
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(3), 'valid-pass');
      await tester.ensureVisible(create);
      await tester.tap(create);
      await tester.pumpAndSettle();
      expect(repository.registerCalls, 1);
      expect(repository.lastRegistration?.name, 'QA User');
      expect(repository.lastRegistration?.photo, isNull);
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
