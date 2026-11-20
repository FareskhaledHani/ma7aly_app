import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../utils/utils.dart';
import 'svg_image.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) {
    final labels = [
      AppStrings.homeTab,
      AppStrings.customersTab,
      AppStrings.productsTab,
      AppStrings.settingsTab,
    ];
    final icons = [
      AppIcons.home,
      AppIcons.customers,
      AppIcons.products,
      AppIcons.settings,
    ];
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.s12.w,
            vertical: Sizes.s10.h,
          ),
          child: Row(
            children: List.generate(
              4,
              (index) => Expanded(
                child: Semantics(
                  selected: selectedIndex == index,
                  button: true,
                  child: InkWell(
                    onTap: () => onChanged(index),
                    borderRadius: BorderRadius.circular(Sizes.s12.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: Sizes.s8.h),
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? AppColors.primary
                            : AppColors.white,
                        borderRadius: BorderRadius.circular(Sizes.s12.r),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgImage.icon(icons[index], size: Sizes.s20.w),
                          Gap(Sizes.s4.h),
                          Text(
                            labels[index].tr(),
                            style: AppTextStyles.style10W400.copyWith(
                              fontSize: Sizes.s10.sp,
                              color: selectedIndex == index
                                  ? AppColors.ink
                                  : AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
