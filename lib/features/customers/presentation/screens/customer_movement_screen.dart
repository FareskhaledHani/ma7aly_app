import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app_injector.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/confirm_action.dart';
import '../../../../core/widgets/section_app_bar.dart';
import '../../domain/entities/customer_movement_entity.dart';
import '../cubit/save_customer_movement_cubit.dart';
import '../cubit/save_customer_movement_state.dart';
import '../widgets/customer_movement_form.dart';
import '../widgets/payment_receipt_dialog.dart';
import 'customer_movement_args.dart';

class CustomerMovementScreen extends StatelessWidget {
  const CustomerMovementScreen({super.key, required this.args});
  final CustomerMovementArgs args;
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<SaveCustomerMovementCubit>(),
    child: BlocConsumer<SaveCustomerMovementCubit, SaveCustomerMovementState>(
      listener: (context, state) async {
        if (state is MovementSuccess) {
          if (args.kind == CustomerMovementKind.payment &&
              !state.params.delete) {
            await showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (_) => PaymentReceiptDialog(
                customerName: args.customer.name,
                movement: state.params.movement,
              ),
            );
            if (!context.mounted) return;
          }
          Navigator.pop(context, true);
        }
        if (state is MovementFailure) {
          if (state.message == AppStrings.confirmCredit ||
              state.message == AppStrings.confirmNegativeStock) {
            final confirmed = await confirmAction(context, state.message);
            if (!context.mounted || !confirmed) return;
            context.read<SaveCustomerMovementCubit>().confirm(state);
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message.tr())));
          }
        }
      },
      builder: (context, state) => PopScope(
        canPop: state is! MovementLoading,
        child: Scaffold(
          appBar: SectionAppBar(
            enabled: state is! MovementLoading,
            title:
                (args.kind == CustomerMovementKind.payment
                        ? AppStrings.recordPayment
                        : args.movement == null
                        ? AppStrings.addWithdrawal
                        : AppStrings.editWithdrawal)
                    .tr(),
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Sizes.s20.r),
              child: CustomerMovementForm(
                args: args,
                isLoading: state is MovementLoading,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
