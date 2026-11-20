import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/text_style.dart';
import '../utils/utils.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType,
    this.maxLength,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    this.hintText,
    this.textAlign = TextAlign.start,
    this.readOnly = false,
  });
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool enabled;
  final TextInputAction textInputAction;
  final String? hintText;
  final TextAlign textAlign;
  final bool readOnly;
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    enabled: enabled,
    keyboardType: keyboardType,
    maxLength: maxLength,
    textInputAction: textInputAction,
    textAlign: textAlign,
    readOnly: readOnly,
    validator: (value) => validator?.call(value)?.tr(),
    autovalidateMode: AutovalidateMode.onUserInteraction,
    style: AppTextStyles.style14W400
        .copyColorWith(AppColors.ink)
        .copyWith(fontSize: Sizes.s14.sp),
    decoration: InputDecoration(
      labelText: label,
      hintText: hintText,
      counterText: '',
      errorMaxLines: 2,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: AppTextStyles.style13W400
          .copyColorWith(AppColors.muted)
          .copyWith(fontSize: Sizes.s13.sp),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Sizes.s4.r),
        borderSide: const BorderSide(color: AppColors.fieldOutline),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: Sizes.s16.w,
        vertical: Sizes.s18.h,
      ),
    ),
  );
}
