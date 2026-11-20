import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/animate_extensions.dart';
import '../../../../core/helpers/amount_format.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/entities/home_overview_entity.dart';
import 'home_month_card.dart';

class HomeBalanceSummary extends StatelessWidget {
  const HomeBalanceSummary({super.key, required this.overview});
  final HomeOverviewEntity overview;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(Sizes.s20.r),
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(Sizes.s24.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.homeOutstanding.tr(),
              style: AppTextStyles.style13W400.copyWith(
                fontSize: Sizes.s13.sp,
                height: 1.55,
                color: AppColors.white,
              ),
            ),
            Gap(Sizes.s4.h),
            Text(
              formatMoney(context, overview.outstandingMinor),
              style: AppTextStyles.style32W800.copyWith(
                fontSize: Sizes.s32.sp,
                height: 1.55,
                color: AppColors.primary,
              ),
            ),
            Gap(Sizes.s4.h),
            Text(
              AppStrings.homeOpenAccounts.tr(
                namedArgs: {
                  'count': NumberFormat.decimalPattern(
                    context.locale.toString(),
                  ).format(overview.openAccounts),
                },
              ),
              style: AppTextStyles.style11W700.copyWith(
                fontSize: Sizes.s11.sp,
                height: 1.55,
                fontWeight: FontWeight.w400,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ).fadeSlideIn(),
      Gap(Sizes.s16.h),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: HomeMonthCard(
              label: AppStrings.homeWithdrawals.tr(),
              value: formatMoney(context, overview.withdrawalsMinor),
            ).listItemAnimation(0),
          ),
          Gap(Sizes.s12.w),
          Expanded(
            child: HomeMonthCard(
              label: AppStrings.homePayments.tr(),
              value: formatMoney(context, overview.paymentsMinor),
            ).listItemAnimation(1),
          ),
        ],
      ),
    ],
  );
}
