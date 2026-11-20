import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/animate_extensions.dart';
import '../../../../core/extensions/text_style.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/svg_image.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Sizes.s24.w),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(Sizes.s24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExcludeSemantics(
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: SizedBox(
                width: Sizes.s72.w,
                height: Sizes.s72.w,
                child: const Center(child: SvgImage(AppIcons.shopWelcome)),
              ),
            ),
          ),
          Gap(Sizes.s12.h),
          Text(
            AppStrings.welcomeCardTitle.tr(),
            style: AppTextStyles.style22W700.copyWith(fontSize: Sizes.s22.sp),
          ),
          Gap(Sizes.s12.h),
          Text(
            AppStrings.welcomeCardDescription.tr(),
            style: AppTextStyles.style13W400
                .copyColorWith(AppColors.ink)
                .copyWith(fontSize: Sizes.s13.sp, height: 1.55),
          ),
        ],
      ),
    ).fadeSlideIn(delay: const Duration(milliseconds: 200));
  }
}
