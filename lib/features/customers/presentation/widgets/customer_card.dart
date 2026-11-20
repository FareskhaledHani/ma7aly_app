import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/text_style.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/entities/customer_entity.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({
    super.key,
    required this.customer,
    required this.today,
    this.onTap,
  });
  final CustomerEntity customer;
  final DateTime today;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final status = customer.statusAt(today);
    final color = switch (status) {
      CustomerStatus.overdue => AppColors.overdue,
      CustomerStatus.upcoming => AppColors.upcoming,
      _ => AppColors.regular,
    };
    final background = switch (status) {
      CustomerStatus.overdue => AppColors.overdueBackground,
      CustomerStatus.upcoming => AppColors.upcomingBackground,
      _ => AppColors.white,
    };
    final statusLabel = switch (status) {
      CustomerStatus.overdue => AppStrings.customerOverdue,
      CustomerStatus.upcoming => AppStrings.customerUpcoming,
      _ => AppStrings.customerRegular,
    };
    final money = NumberFormat.currency(
      locale: context.locale.toString(),
      symbol: AppStrings.egp.tr(),
      decimalDigits: customer.balanceMinor % 100 == 0 ? 0 : 2,
    ).format(customer.balanceMinor / 100);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Sizes.s20.r),
      child: Container(
        constraints: BoxConstraints(minHeight: Sizes.s112.h),
        padding: EdgeInsets.all(Sizes.s16.w),
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(Sizes.s20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              customer.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.style14W600
                  .copyColorWith(AppColors.ink)
                  .copyWith(fontSize: Sizes.s14.sp),
            ),
            Gap(Sizes.s6.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    statusLabel.tr(),
                    style: AppTextStyles.style12W400
                        .copyColorWith(color)
                        .copyWith(fontSize: Sizes.s12.sp),
                  ),
                ),
                Text(
                  money,
                  style: AppTextStyles.style16W600
                      .copyColorWith(AppColors.ink)
                      .copyWith(fontSize: Sizes.s16.sp),
                ),
              ],
            ),
            Gap(Sizes.s6.h),
            Text(
              AppStrings.customerDueOn.tr(
                namedArgs: {
                  'date': DateFormat.yMMMd(context.locale.toString())
                      .format(customer.dueDateAt(today)),
                },
              ),
              style: AppTextStyles.style11W700
                  .copyColorWith(AppColors.muted)
                  .copyWith(
                    fontSize: Sizes.s11.sp,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
