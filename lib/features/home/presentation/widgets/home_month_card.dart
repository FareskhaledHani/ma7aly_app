import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/utils.dart';

class HomeMonthCard extends StatelessWidget {
  const HomeMonthCard({super.key, required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(Sizes.s12.r),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(Sizes.s16.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.style11W700.copyWith(
            fontSize: Sizes.s11.sp,
            height: 1.55,
            fontWeight: FontWeight.w400,
            color: AppColors.muted,
          ),
        ),
        Gap(Sizes.s4.h),
        Text(
          value,
          style: AppTextStyles.style14W600.copyWith(
            fontSize: Sizes.s14.sp,
            height: 1.55,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
