import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../extensions/animate_extensions.dart';
import '../utils/utils.dart';
import 'main_button.dart';

class AppFeedback extends StatelessWidget {
  const AppFeedback({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: Sizes.s32.h),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyles.style14W400.copyWith(
            fontSize: Sizes.s14.sp,
            color: AppColors.muted,
          ),
        ),
        if (onRetry != null) ...[
          Gap(Sizes.s16.h),
          MainButton(
            label: AppStrings.retry.tr(),
            onPressed: onRetry,
            textColor: AppColors.ink,
            borderRadius: Sizes.s16.r,
          ),
        ],
      ],
    ),
  ).fadeSlideIn();
}
