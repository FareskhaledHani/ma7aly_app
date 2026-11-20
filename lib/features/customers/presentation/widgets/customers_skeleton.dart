import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/animate_extensions.dart';
import '../../../../core/utils/utils.dart';

class CustomersSkeleton extends StatelessWidget {
  const CustomersSkeleton({super.key, this.count = 4});
  final int count;
  @override
  Widget build(BuildContext context) => Column(
    children: List.generate(
      count,
      (index) => Padding(
        padding: EdgeInsets.only(bottom: Sizes.s16.h),
        child: Container(
          constraints: BoxConstraints(minHeight: Sizes.s112.h),
          padding: EdgeInsets.all(Sizes.s16.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(Sizes.s20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Sizes.s120.w,
                height: Sizes.s16.h,
                color: AppColors.grey3,
              ),
              Gap(Sizes.s12.h),
              Container(
                width: Sizes.s80.w,
                height: Sizes.s12.h,
                color: AppColors.grey3,
              ),
              Gap(Sizes.s12.h),
              Container(
                width: Sizes.s200.w,
                height: Sizes.s10.h,
                color: AppColors.grey3,
              ),
            ],
          ),
        ).pulse(),
      ),
    ),
  );
}
