import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../extensions/animate_extensions.dart';
import '../helpers/amount_format.dart';
import '../utils/utils.dart';

class MoneyPanel extends StatelessWidget {
  const MoneyPanel({
    super.key,
    required this.label,
    required this.amountMinor,
    this.subtitle,
    this.dark = false,
    this.yellow = false,
  });
  final String label;
  final int amountMinor;
  final String? subtitle;
  final bool dark;
  final bool yellow;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(Sizes.s24.r),
    decoration: BoxDecoration(
      color: dark
          ? AppColors.ink
          : yellow
          ? AppColors.primary
          : AppColors.upcomingBackground,
      borderRadius: BorderRadius.circular(Sizes.s20.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.style13W400.copyWith(
            fontSize: Sizes.s13.sp,
            color: dark ? AppColors.white : AppColors.ink,
          ),
        ),
        Gap(Sizes.s16.h),
        Text(
          formatMoney(context, amountMinor),
          style: AppTextStyles.style32W800.copyWith(
            fontSize: Sizes.s32.sp,
            color: dark ? AppColors.primary : AppColors.ink,
          ),
        ),
        if (subtitle != null) ...[
          Gap(Sizes.s8.h),
          Text(
            subtitle!,
            style: AppTextStyles.style11W700.copyWith(
              fontSize: Sizes.s11.sp,
              color: dark ? AppColors.white : AppColors.muted,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    ),
  ).fadeSlideIn();
}
