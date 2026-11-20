import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../extensions/animate_extensions.dart';
import '../utils/utils.dart';
import 'svg_image.dart';

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Container(
            width: Sizes.s64.w,
            height: Sizes.s64.w,
            padding: EdgeInsets.all(Sizes.s16.w),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(Sizes.s16.r),
            ),
            child: const Center(child: SvgImage(AppIcons.shopBrand)),
          ),
        ),
        Gap(Sizes.s12.w),
        Flexible(
          child: Text(
            AppStrings.brandName.tr(),
            textDirection: TextDirection.ltr,
            style: AppTextStyles.brandWordmark.copyWith(fontSize: Sizes.s32.sp),
          ),
        ),
      ],
    ).logoIntro();
  }
}
