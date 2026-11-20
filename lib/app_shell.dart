import 'package:flutter/material.dart';

import 'core/widgets/app_bottom_navigation.dart';
import 'features/home/presentation/screen/home_screen.dart';
import 'features/customers/presentation/screens/customers_screen.dart';
import 'features/products/presentation/screens/products_screen.dart';
import 'features/settings/presentation/screens/settings_screen.dart';
import 'config/routes/app_navigator.dart';
import 'config/routes/app_routes.dart';
import 'features/customers/presentation/screens/customer_account_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _tab = ValueNotifier<int>(0);
  int _customersGeneration = 0;
  void _selectTab(int value) {
    if (value == 1 && _tab.value != 1) _customersGeneration++;
    _tab.value = value;
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<int>(
    valueListenable: _tab,
    builder: (context, tab, _) => Scaffold(
      body: IndexedStack(
        index: tab,
        children: [
          if (tab == 0)
            HomeScreen(
              onOpenCustomer: (id) async {
                await AppNavigator.navigateNamedTo<void>(
                  AppRoutes.customerAccountScreen,
                  arguments: CustomerAccountArgs(customerId: id),
                );
              },
            )
          else
            const SizedBox.shrink(),
          if (tab == 1)
            CustomersScreen(
              key: ValueKey(_customersGeneration),
              onBack: () => _selectTab(0),
            )
          else
            const SizedBox.shrink(),
          if (tab == 2)
            ProductsScreen(
              args: const ProductsArgs(selectMode: false),
              onBack: () => _selectTab(0),
            )
          else
            const SizedBox.shrink(),
          if (tab == 3)
            SettingsScreen(
              onProducts: () => _selectTab(2),
              onBack: () => _selectTab(0),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(
        selectedIndex: tab,
        onChanged: _selectTab,
      ),
    ),
  );
}
