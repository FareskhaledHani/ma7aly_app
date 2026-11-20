import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/animate_extensions.dart';
import '../../../../core/extensions/text_style.dart';
import '../../../../core/helpers/auth_validators.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../config/routes/app_navigator.dart';
import '../../../../config/routes/app_routes.dart';
import 'login_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    this.onSignIn,
    required this.onPasswordReset,
    this.isSigningIn = false,
    this.isResettingPassword = false,
  });

  final void Function(String email, String password)? onSignIn;
  final ValueChanged<String> onPasswordReset;
  final bool isSigningIn;
  final bool isResettingPassword;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormFieldState<String>>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscurePassword = true;

  bool get _isBusy => widget.isSigningIn || widget.isResettingPassword;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (_isBusy ||
        widget.onSignIn == null ||
        !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    FocusScope.of(context).unfocus();
    widget.onSignIn?.call(_email.text.trim(), _password.text);
  }

  void _resetPassword() {
    if (_isBusy || !(_emailKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    widget.onPasswordReset(_email.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final bodyStyle = AppTextStyles.style13W400
        .copyColorWith(AppColors.ink)
        .copyWith(fontSize: Sizes.s13.sp, height: 1.55);
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginTextField(
              fieldKey: _emailKey,
              controller: _email,
              label: AppStrings.emailLabel.tr(),
              hint: AppStrings.emailHint.tr(),
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.username],
              enabled: !_isBusy,
              validator: AuthValidators.email,
            ),
            Gap(Sizes.s16.h),
            LoginTextField(
              controller: _password,
              label: AppStrings.passwordLabel.tr(),
              obscureText: _obscurePassword,
              enabled: !_isBusy,
              autofillHints: const [AutofillHints.password],
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: AuthValidators.password,
              suffix: TextButton(
                onPressed: _isBusy
                    ? null
                    : () => setState(() {
                        _obscurePassword = !_obscurePassword;
                      }),
                child: Text(
                  (_obscurePassword
                          ? AppStrings.showPassword
                          : AppStrings.hidePassword)
                      .tr(),
                  style: bodyStyle,
                ),
              ),
            ),
            Gap(Sizes.s16.h),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: _isBusy ? null : _resetPassword,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(Sizes.zero.w, Sizes.s20.h),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: widget.isResettingPassword
                    ? SizedBox(
                        height: Sizes.s20.h,
                        width: Sizes.s20.h,
                        child: CircularProgressIndicator(
                          color: AppColors.ink,
                          strokeWidth: Sizes.s2.w,
                        ),
                      )
                    : Text(AppStrings.forgotPassword.tr(), style: bodyStyle),
              ),
            ),
            Gap(Sizes.s16.h),
            MainButton(
              label: AppStrings.signIn.tr(),
              onPressed: _isBusy || widget.onSignIn == null ? null : _submit,
              isLoading: widget.isSigningIn,
              height: Sizes.s52.h,
              borderRadius: Sizes.s16.r,
              textStyle: AppTextStyles.style14W500.copyWith(
                fontSize: Sizes.s14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
              elevation: Sizes.zero,
            ),
            Gap(Sizes.s16.h),
            Text(
              AppStrings.accountActivationNote.tr(),
              style: AppTextStyles.style10W400
                  .copyColorWith(AppColors.muted)
                  .copyWith(fontSize: Sizes.s11.sp, height: 1.55),
            ),
            Gap(Sizes.s8.h),
            TextButton(
              onPressed: _isBusy
                  ? null
                  : () =>
                        AppNavigator.navigateNamedTo(AppRoutes.registerScreen),
              child: Text(AppStrings.createAccountLink.tr(), style: bodyStyle),
            ),
          ],
        ),
      ),
    ).fadeSlideIn(delay: const Duration(milliseconds: 300));
  }
}
