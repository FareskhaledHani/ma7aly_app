import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/text_style.dart';
import '../../../../core/utils/utils.dart';

class LoginTextField extends StatelessWidget {
  const LoginTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    this.fieldKey,
    this.hint,
    this.obscureText = false,
    this.enabled = true,
    this.suffix,
    this.keyboardType,
    this.autofillHints,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.textDirection = TextDirection.ltr,
  });

  final TextEditingController controller;
  final Key? fieldKey;
  final String label;
  final String? hint;
  final String? Function(String?) validator;
  final bool obscureText;
  final bool enabled;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(Sizes.s4.r),
      borderSide: const BorderSide(color: AppColors.fieldOutline),
    );
    return TextFormField(
      key: fieldKey,
      controller: controller,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      textDirection: textDirection,
      textAlign: TextAlign.center,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      autocorrect: false,
      enableSuggestions: keyboardType == TextInputType.emailAddress,
      validator: (value) => validator(value)?.tr(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: AppTextStyles.style13W400
          .copyColorWith(AppColors.ink)
          .copyWith(fontSize: Sizes.s13.sp, height: 1.55),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: AppTextStyles.style13W400
            .copyColorWith(AppColors.muted)
            .copyWith(fontSize: Sizes.s13.sp),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Sizes.s16.w,
          vertical: Sizes.s18.h,
        ),
        border: border,
        enabledBorder: border,
        disabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.ink),
        ),
        errorBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.error),
        ),
        errorMaxLines: 2,
        suffixIcon: suffix,
      ),
    );
  }
}
