import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app_injector.dart';
import '../../../../core/utils/utils.dart';
import '../cubit/add_customer_cubit.dart';
import '../cubit/add_customer_state.dart';
import '../widgets/add_customer_form.dart';
import '../../../../core/widgets/section_app_bar.dart';

class AddCustomerScreen extends StatelessWidget {
  const AddCustomerScreen({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<AddCustomerCubit>(),
    child: BlocConsumer<AddCustomerCubit, AddCustomerState>(
      listener: (context, state) {
        if (state is AddCustomerSuccess) Navigator.of(context).pop(true);
        if (state is AddCustomerFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message.tr())));
        }
      },
      builder: (context, state) => PopScope(
        canPop: state is! AddCustomerLoading,
        child: Scaffold(
          appBar: SectionAppBar(
            title: AppStrings.newCustomer.tr(),
            enabled: state is! AddCustomerLoading,
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: Sizes.s20.w,
                vertical: Sizes.s20.h,
              ),
              child: AddCustomerForm(
                onSave: context.read<AddCustomerCubit>().save,
                isLoading: state is AddCustomerLoading,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
