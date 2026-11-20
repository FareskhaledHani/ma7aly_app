import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/amount_format.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/entities/customer_movement_entity.dart';

class CustomerMovementCard extends StatelessWidget {
  const CustomerMovementCard({
    super.key,
    required this.movement,
    required this.onTap,
  });
  final CustomerMovementEntity movement;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.canvas,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Sizes.s12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Sizes.s12.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movement.productName ??
                        (movement.kind == CustomerMovementKind.payment
                                ? AppStrings.payment
                                : AppStrings.withdrawal)
                            .tr(),
                    style: AppTextStyles.style14W600.copyWith(
                      fontSize: Sizes.s14.sp,
                    ),
                  ),
                  Gap(Sizes.s4.h),
                  Text(
                    DateFormat.yMMMd(context.locale.toString())
                        .format(movement.date),
                    style: AppTextStyles.style11W700.copyWith(
                      fontSize: Sizes.s11.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.muted,
                    ),
                  ),
                  if (movement.note != null)
                    Text(
                      movement.note!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.style11W700.copyWith(
                        fontSize: Sizes.s11.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.muted,
                      ),
                    ),
                ],
              ),
            ),
            Gap(Sizes.s12.w),
            Text(
              formatMoney(context, movement.balanceDelta),
              style: AppTextStyles.style14W600.copyWith(
                fontSize: Sizes.s14.sp,
                color: movement.kind == CustomerMovementKind.payment
                    ? AppColors.regular
                    : AppColors.overdue,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
