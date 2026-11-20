import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/animate_extensions.dart';
import '../../../../core/extensions/text_style.dart';
import '../../../../core/utils/utils.dart';

class WelcomeHeading extends StatelessWidget {
  const WelcomeHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.welcomeHeadline.tr(),
          style: AppTextStyles.style32W800.copyWith(fontSize: Sizes.s32.sp),
        ),
        Gap(Sizes.s16.h),
        Text(
          AppStrings.welcomeDescription.tr(),
          style: AppTextStyles.style13W400
              .copyColorWith(AppColors.muted)
              .copyWith(fontSize: Sizes.s13.sp, height: 1.55),
        ),
      ],
    ).fadeSlideIn(delay: const Duration(milliseconds: 100));
  }
}
