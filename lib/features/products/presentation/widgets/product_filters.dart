import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/utils.dart';
import '../../domain/usecases/get_products_usecase.dart';

class ProductFilters extends StatelessWidget {
  const ProductFilters({
    super.key,
    required this.value,
    required this.onChanged,
  });
  final ProductFilter value;
  final ValueChanged<ProductFilter> onChanged;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (final item in ProductFilter.values) ...[
        if (item != ProductFilter.all) Gap(Sizes.s8.w),
        Expanded(
          child: Semantics(
            selected: item == value,
            button: true,
            child: InkWell(
              onTap: () => onChanged(item),
              borderRadius: BorderRadius.circular(Sizes.s8.r),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: Sizes.s5.h,
                  horizontal: Sizes.s4.w,
                ),
                decoration: BoxDecoration(
                  color: item == value ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(Sizes.s8.r),
                ),
                child: Text(
                  switch (item) {
                    ProductFilter.all => AppStrings.productsAll.tr(),
                    ProductFilter.lowStock => AppStrings.productsLow.tr(),
                    ProductFilter.pricesOnly =>
                      AppStrings.productsPricesOnly.tr(),
                  },
                  textAlign: TextAlign.center,
                  style: AppTextStyles.style10W400.copyWith(
                    fontSize: Sizes.s10.sp,
                    color: item == value ? AppColors.ink : AppColors.muted,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ],
  );
}
