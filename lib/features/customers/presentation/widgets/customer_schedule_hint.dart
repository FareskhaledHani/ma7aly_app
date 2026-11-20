import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/animate_extensions.dart';
import '../../../../core/utils/utils.dart';

class CustomerScheduleHint extends StatelessWidget {
  const CustomerScheduleHint({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(Sizes.s12.r),
    decoration: BoxDecoration(
      color: AppColors.upcomingBackground,
      borderRadius: BorderRadius.circular(Sizes.s12.r),
    ),
    child: Text(
      AppStrings.customerScheduleHint.tr(),
      textAlign: TextAlign.center,
      style: AppTextStyles.style10W400.copyWith(
        fontSize: Sizes.s10.sp,
        color: AppColors.muted,
      ),
    ),
  ).fadeSlideIn();
}
