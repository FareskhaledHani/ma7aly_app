import 'package:flutter/material.dart';
import 'package:ma7aly_app/features/auth/presentation/screens/register_screen.dart';
import 'package:ma7aly_app/features/auth/presentation/screens/welcome_screen.dart';

import '../../app_shell.dart';
import '../../features/customers/presentation/screens/add_customer_screen.dart';
import '../../features/customers/presentation/screens/customer_account_screen.dart';
import '../../features/customers/presentation/screens/customer_movement_screen.dart';
import '../../features/customers/presentation/screens/customer_movement_args.dart';
import '../../features/products/presentation/screens/products_screen.dart';
import '../../features/products/presentation/screens/add_product_screen.dart';
import '../../features/products/domain/entities/product_entity.dart';
import '../../features/settings/presentation/screens/edit_settings_screen.dart';

import 'app_routes.dart';

class RouteGenerator {
  static Route<dynamic>? getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AppRoutes.customerAccountScreen:
        final args = routeSettings.arguments;
        if (args is! CustomerAccountArgs) return null;
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (_) => CustomerAccountScreen(args: args),
        );
      case AppRoutes.customerMovementScreen:
        final args = routeSettings.arguments;
        if (args is! CustomerMovementArgs) return null;
        return MaterialPageRoute<bool>(
          settings: routeSettings,
          builder: (_) => CustomerMovementScreen(args: args),
        );
      case AppRoutes.selectProductScreen:
        return MaterialPageRoute<ProductEntity>(
          settings: routeSettings,
          builder: (_) =>
              const ProductsScreen(args: ProductsArgs(selectMode: true)),
        );
      case AppRoutes.addProductScreen:
        return MaterialPageRoute<bool>(
          settings: routeSettings,
          builder: (_) => const AddProductScreen(),
        );
      case AppRoutes.editSettingsScreen:
        final args = routeSettings.arguments;
        if (args is! EditSettingsArgs) return null;
        return MaterialPageRoute<bool>(
          settings: routeSettings,
          builder: (_) => EditSettingsScreen(args: args),
        );
      case AppRoutes.addCustomerScreen:
        return MaterialPageRoute<bool>(
          settings: routeSettings,
          builder: (_) => const AddCustomerScreen(),
        );
      case AppRoutes.registerScreen:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const RegisterScreen(),
        );
      case AppRoutes.welcomeScreen:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const WelcomeScreen(),
        );
      case AppRoutes.homeScreen:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const AppShell(),
        );
      default:
        return null;
    }
  }
}
