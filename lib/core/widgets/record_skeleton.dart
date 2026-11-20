import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../extensions/animate_extensions.dart';
import '../utils/utils.dart';

class RecordSkeleton extends StatelessWidget {
  const RecordSkeleton({super.key, this.count = 4});
  final int count;
  @override
  Widget build(BuildContext context) => Column(
    children: List.generate(
      count,
      (_) => Padding(
        padding: EdgeInsets.only(bottom: Sizes.s16.h),
        child: Container(
          padding: EdgeInsets.all(Sizes.s20.r),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(Sizes.s20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Sizes.s140.w,
                height: Sizes.s16.h,
                color: AppColors.grey3,
              ),
              Gap(Sizes.s16.h),
              Container(
                width: Sizes.s220.w,
                height: Sizes.s12.h,
                color: AppColors.grey3,
              ),
            ],
          ),
        ).pulse(),
      ),
    ),
  );
}
