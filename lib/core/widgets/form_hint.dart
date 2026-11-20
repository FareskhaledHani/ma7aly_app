import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/animate_extensions.dart';
import '../utils/utils.dart';

class FormHint extends StatelessWidget {
  const FormHint({super.key, required this.text, this.warning = false});
  final String text;
  final bool warning;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(Sizes.s12.r),
    decoration: BoxDecoration(
      color: warning
          ? AppColors.overdueBackground
          : AppColors.upcomingBackground,
      borderRadius: BorderRadius.circular(Sizes.s12.r),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.style11W700.copyWith(
        fontSize: Sizes.s11.sp,
        fontWeight: FontWeight.w400,
        color: warning ? AppColors.overdue : AppColors.muted,
      ),
    ),
  ).fadeSlideIn();
}
