import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ma7aly_app/config/routes/app_navigator.dart';
import 'package:ma7aly_app/config/routes/route_generator.dart';
import 'package:ma7aly_app/config/theme/app_theme.dart';
import 'package:ma7aly_app/core/helpers/l10n.dart';

class TestApp extends StatelessWidget {
  const TestApp({
    super.key,
    required this.locale,
    required this.child,
    this.assetLoader = const RootBundleAssetLoader(),
  });
  final Locale locale;
  final Widget child;
  final AssetLoader assetLoader;
  @override
  Widget build(BuildContext context) => EasyLocalization(
    supportedLocales: L10n.all,
    path: L10n.languagePath,
    startLocale: locale,
    saveLocale: false,
    fallbackLocale: L10n.arabic,
    assetLoader: assetLoader,
    child: ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MaterialApp(
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.talabyDashboardTheme,
        navigatorKey: AppNavigator.navigatorKey,
        onGenerateRoute: RouteGenerator.getRoute,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        home: child,
      ),
    ),
  );
}
