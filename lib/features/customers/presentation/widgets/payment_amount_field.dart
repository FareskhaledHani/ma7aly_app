import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/customer_input.dart';
import '../../../../core/utils/utils.dart';

class PaymentAmountField extends StatelessWidget {
  const PaymentAmountField({
    super.key,
    required this.controller,
    required this.enabled,
  });
  final TextEditingController controller;
  final bool enabled;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(Sizes.s24.r),
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(Sizes.s20.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.paymentAmount.tr(),
          style: AppTextStyles.style13W400.copyWith(fontSize: Sizes.s13.sp),
        ),
        Gap(Sizes.s16.h),
        TextFormField(
          controller: controller,
          enabled: enabled,
          maxLength: 13,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: AppTextStyles.style32W800.copyWith(fontSize: Sizes.s32.sp),
          decoration: InputDecoration(
            counterText: '',
            border: InputBorder.none,
            hintText: AppStrings.amountHint.tr(),
            suffixText: AppStrings.egp.tr(),
            errorMaxLines: 2,
            contentPadding: EdgeInsets.zero,
          ),
          validator: (text) => (CustomerInput.moneyMinor(text ?? '') ?? 0) <= 0
              ? AppStrings.movementInvalid.tr()
              : null,
        ),
      ],
    ),
  );
}
