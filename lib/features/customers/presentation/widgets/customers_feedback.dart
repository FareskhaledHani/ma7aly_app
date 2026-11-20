import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/animate_extensions.dart';
import '../../../../core/extensions/text_style.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/main_button.dart';

class CustomersFeedback extends StatelessWidget {
  const CustomersFeedback({super.key, required this.message, this.onRetry});
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
          style: AppTextStyles.style14W400
              .copyColorWith(AppColors.muted)
              .copyWith(fontSize: Sizes.s14.sp),
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
