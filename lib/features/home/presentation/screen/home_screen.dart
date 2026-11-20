import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_injector.dart';
import '../cubit/home_cubit.dart';
import '../widgets/home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onOpenCustomer});
  final Future<void> Function(String customerId) onOpenCustomer;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..load(),
      child: HomeBody(onOpenCustomer: onOpenCustomer),
    );
  }
}
