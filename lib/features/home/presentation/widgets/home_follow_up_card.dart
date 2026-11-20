import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/amount_format.dart';
import '../../../../core/utils/utils.dart';
import '../../../customers/domain/entities/customer_entity.dart';
import '../../domain/entities/home_follow_up_entity.dart';

class HomeFollowUpCard extends StatelessWidget {
  const HomeFollowUpCard({super.key, required this.item, required this.onTap});
  final HomeFollowUpEntity item;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final overdue = item.status == CustomerStatus.overdue;
    final status =
        (overdue ? AppStrings.customerOverdue : AppStrings.customerUpcoming)
            .tr();
    final number = NumberFormat.decimalPattern(context.locale.toString());
    final date = DateFormat.MMMd(context.locale.toString())
        .format(item.dueDate);
    final dueLabel = item.oldDebt
        ? AppStrings.homeOldDebt.tr()
        : (item.days < 0
                  ? AppStrings.homeOverdueDate
                  : AppStrings.homeUpcomingDate)
              .tr(
                namedArgs: {
                  'date': date,
                  'days': number.format(item.days.abs()),
                },
              );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Sizes.s20.r),
      child: Container(
        padding: EdgeInsets.all(Sizes.s16.r),
        decoration: BoxDecoration(
          color: overdue
              ? AppColors.homeOverdueBackground
              : AppColors.homeUpcomingBackground,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(Sizes.s20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              item.name,
              style: AppTextStyles.style14W600.copyWith(
                fontSize: Sizes.s14.sp,
                height: 1.55,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gap(Sizes.s8.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.paymentPercent == null
                        ? status
                        : AppStrings.homePaymentStatus.tr(
                            namedArgs: {
                              'status': status,
                              'percent': number.format(item.paymentPercent),
                            },
                          ),
                    style: AppTextStyles.style11W700.copyWith(
                      fontSize: Sizes.s11.sp,
                      height: 1.55,
                      fontWeight: FontWeight.w400,
                      color: overdue
                          ? AppColors.homeOverdue
                          : AppColors.homeUpcoming,
                    ),
                  ),
                ),
                Gap(Sizes.s8.w),
                Flexible(
                  child: Text(
                    formatMoney(context, item.balanceMinor),
                    style: AppTextStyles.style14W600.copyWith(
                      fontSize: Sizes.s14.sp,
                      height: 1.55,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            Gap(Sizes.s8.h),
            Text(
              dueLabel,
              style: AppTextStyles.style11W700.copyWith(
                fontSize: Sizes.s11.sp,
                height: 1.55,
                fontWeight: FontWeight.w400,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
