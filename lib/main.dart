import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ma7aly_app/app.dart';

import 'app_injector.dart';
import 'bloc_observer.dart';
import 'core/helpers/l10n.dart';
import 'core/helpers/system_ui_helper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Animate.defaultDuration = 300.ms;
  Animate.defaultCurve = Curves.easeOut;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppInjector.setUpGetIt();
  await EasyLocalization.ensureInitialized();
  SystemUIHelper.configureSystemUI();
  Bloc.observer = AppBlocObserver();
  runApp(
    EasyLocalization(
      supportedLocales: L10n.all,
      path: L10n.languagePath,
      saveLocale: true,
      startLocale: L10n.arabic,
      fallbackLocale: L10n.arabic,
      child: const TalabyDashboardApp(),
    ),
  );
}

// flutter build apk --release --no-tree-shake-icons
// dart run build_runner build --delete-conflicting-outputs
