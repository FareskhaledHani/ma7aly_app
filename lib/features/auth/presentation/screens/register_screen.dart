import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../app_injector.dart';
import '../../../../config/routes/app_navigator.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/brand_header.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            AppNavigator.navigateNamedFinishGlobal(AppRoutes.homeScreen);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message.tr())));
          }
        },
        builder: (context, state) => PopScope(
          canPop: state is! AuthLoading,
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.s20.w,
                  vertical: Sizes.s20.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BrandHeader(),
                    Gap(Sizes.s24.h),
                    Text(
                      AppStrings.createAccount.tr(),
                      style: AppTextStyles.style22W700.copyWith(
                        fontSize: Sizes.s22.sp,
                      ),
                    ),
                    Gap(Sizes.s16.h),
                    RegisterForm(
                      onSubmit: context.read<AuthCubit>().register,
                      isLoading: state is AuthLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
