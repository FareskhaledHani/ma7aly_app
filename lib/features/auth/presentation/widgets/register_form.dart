import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/animate_extensions.dart';
import '../../../../core/extensions/text_style.dart';
import '../../../../core/helpers/auth_validators.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/main_button.dart';
import '../../domain/entities/account_photo.dart';
import '../../domain/usecases/register_usecase.dart';
import 'account_photo_field.dart';
import 'login_text_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });
  final ValueChanged<RegisterParams> onSubmit;
  final bool isLoading;
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _key = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  AccountPhoto? _photo;
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (widget.isLoading || !(_key.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    widget.onSubmit(
      RegisterParams(
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
        photo: _photo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Form(
        key: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AccountPhotoField(
              enabled: !widget.isLoading,
              onChanged: (photo) => _photo = photo,
            ),
            Gap(Sizes.s24.h),
            LoginTextField(
              controller: _name,
              label: AppStrings.nameLabel.tr(),
              textDirection: Directionality.of(context),
              enabled: !widget.isLoading,
              validator: AuthValidators.name,
              autofillHints: const [AutofillHints.name],
            ),
            Gap(Sizes.s16.h),
            LoginTextField(
              controller: _phone,
              label: AppStrings.phoneLabel.tr(),
              enabled: !widget.isLoading,
              validator: AuthValidators.phone,
              keyboardType: TextInputType.phone,
              autofillHints: const [AutofillHints.telephoneNumber],
            ),
            Gap(Sizes.s16.h),
            LoginTextField(
              controller: _email,
              label: AppStrings.emailLabel.tr(),
              enabled: !widget.isLoading,
              validator: AuthValidators.email,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
            ),
            Gap(Sizes.s16.h),
            LoginTextField(
              controller: _password,
              label: AppStrings.passwordLabel.tr(),
              enabled: !widget.isLoading,
              validator: AuthValidators.newPassword,
              obscureText: _obscure,
              autofillHints: const [AutofillHints.newPassword],
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              suffix: TextButton(
                onPressed: widget.isLoading
                    ? null
                    : () => setState(() => _obscure = !_obscure),
                child: Text(
                  (_obscure ? AppStrings.showPassword : AppStrings.hidePassword)
                      .tr(),
                  style: AppTextStyles.style12W400
                      .copyColorWith(AppColors.ink)
                      .copyWith(fontSize: Sizes.s12.sp),
                ),
              ),
            ),
            Gap(Sizes.s24.h),
            MainButton(
              label: AppStrings.createAccount.tr(),
              onPressed: widget.isLoading ? null : _submit,
              isLoading: widget.isLoading,
              height: Sizes.s52.h,
              borderRadius: Sizes.s16.r,
              textColor: AppColors.ink,
              elevation: Sizes.zero,
            ),
            Gap(Sizes.s12.h),
            TextButton(
              onPressed: widget.isLoading
                  ? null
                  : () => Navigator.of(context).pop(),
              child: Text(
                AppStrings.alreadyHaveAccount.tr(),
                style: AppTextStyles.style13W400
                    .copyColorWith(AppColors.ink)
                    .copyWith(fontSize: Sizes.s13.sp),
              ),
            ),
          ],
        ),
      ),
    ).fadeSlideIn();
  }
}
