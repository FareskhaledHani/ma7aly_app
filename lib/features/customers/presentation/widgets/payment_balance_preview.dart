import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/amount_format.dart';
import '../../../../core/utils/utils.dart';

class PaymentBalancePreview extends StatelessWidget {
  const PaymentBalancePreview({
    super.key,
    required this.currentBalance,
    required this.nextBalance,
  });
  final int currentBalance;
  final int nextBalance;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(Sizes.s16.r),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(Sizes.s20.r),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppStrings.currentBalance.tr(),
                style: AppTextStyles.style12W400.copyWith(
                  fontSize: Sizes.s12.sp,
                  color: AppColors.muted,
                ),
              ),
            ),
            Text(
              formatMoney(context, currentBalance),
              style: AppTextStyles.style12W400.copyWith(
                fontSize: Sizes.s12.sp,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
        Gap(Sizes.s12.h),
        Row(
          children: [
            Expanded(
              child: Text(
                (nextBalance < 0
                        ? AppStrings.customerCredit
                        : AppStrings.balanceAfterPayment)
                    .tr(),
                style: AppTextStyles.style14W600.copyWith(
                  fontSize: Sizes.s14.sp,
                  color: AppColors.regular,
                ),
              ),
            ),
            Text(
              formatMoney(context, nextBalance.abs()),
              style: AppTextStyles.style14W600.copyWith(
                fontSize: Sizes.s14.sp,
                color: AppColors.regular,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
