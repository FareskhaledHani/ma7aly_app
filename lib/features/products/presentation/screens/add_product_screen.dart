import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app_injector.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/section_app_bar.dart';
import '../cubit/add_product_cubit.dart';
import '../cubit/add_product_state.dart';
import '../widgets/add_product_form.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<AddProductCubit>(),
    child: BlocConsumer<AddProductCubit, AddProductState>(
      listener: (context, state) {
        if (state is ProductSuccess) Navigator.pop(context, true);
        if (state is ProductFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message.tr())));
        }
      },
      builder: (context, state) => PopScope(
        canPop: state is! ProductLoading,
        child: Scaffold(
          appBar: SectionAppBar(
            title: AppStrings.addProductTitle.tr(),
            enabled: state is! ProductLoading,
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Sizes.s20.r),
              child: AddProductForm(
                onSave: context.read<AddProductCubit>().save,
                isLoading: state is ProductLoading,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
