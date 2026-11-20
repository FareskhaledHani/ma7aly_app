import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_injector.dart';
import '../../../../core/utils/utils.dart';
import '../../../../config/routes/app_navigator.dart';
import '../../../../config/routes/app_routes.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../cubit/password_reset_cubit.dart';
import '../cubit/password_reset_state.dart';
import 'login_form.dart';

class LoginSection extends StatelessWidget {
  const LoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<PasswordResetCubit>()),
        BlocProvider(create: (_) => getIt<AuthCubit>()),
      ],
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            AppNavigator.navigateNamedFinishGlobal(AppRoutes.homeScreen);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message.tr())));
          }
        },
        builder: (context, authState) =>
            BlocConsumer<PasswordResetCubit, PasswordResetState>(
              listener: (context, state) {
                final message = switch (state) {
                  PasswordResetSuccess() => AppStrings.passwordResetSent,
                  PasswordResetFailure(:final message) => message,
                  _ => null,
                };
                if (message != null) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message.tr())));
                }
              },
              builder: (context, state) => LoginForm(
                onSignIn: context.read<AuthCubit>().signIn,
                isSigningIn: authState is AuthLoading,
                onPasswordReset: context
                    .read<PasswordResetCubit>()
                    .resetPassword,
                isResettingPassword: state is PasswordResetLoading,
              ),
            ),
      ),
    );
  }
}
