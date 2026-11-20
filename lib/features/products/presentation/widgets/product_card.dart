import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/amount_format.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/svg_image.dart';
import '../../domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onTap});
  final ProductEntity product;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(Sizes.s20.r),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Sizes.s20.r),
      child: Padding(
        padding: EdgeInsets.all(Sizes.s16.r),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.style14W600.copyWith(
                      fontSize: Sizes.s14.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(Sizes.s4.h),
                  Text(
                    AppStrings.productPriceUnit.tr(
                      namedArgs: {
                        'price': formatMoney(context, product.priceMinor),
                        'unit': product.unit,
                      },
                    ),
                    style: AppTextStyles.style12W400.copyWith(
                      fontSize: Sizes.s12.sp,
                      color: AppColors.muted,
                    ),
                  ),
                  Gap(Sizes.s8.h),
                  Text(
                    product.trackInventory
                        ? (product.isLowStock
                                  ? AppStrings.productLowStock
                                  : AppStrings.productAvailable)
                              .tr(
                                namedArgs: {
                                  'quantity': formatQuantity(
                                    context,
                                    product.stockMilli,
                                  ),
                                  'unit': product.unit,
                                },
                              )
                        : AppStrings.productPriceOnly.tr(),
                    style: AppTextStyles.style11W700.copyWith(
                      fontSize: Sizes.s11.sp,
                      fontWeight: FontWeight.w400,
                      color: !product.trackInventory
                          ? AppColors.muted
                          : product.isLowStock
                          ? AppColors.upcoming
                          : AppColors.regular,
                    ),
                  ),
                ],
              ),
            ),
            Gap(Sizes.s16.w),
            Container(
              padding: EdgeInsets.all(Sizes.s12.r),
              decoration: BoxDecoration(
                color: AppColors.upcomingBackground,
                borderRadius: BorderRadius.circular(Sizes.s12.r),
              ),
              child: SvgImage.icon(AppIcons.products, size: Sizes.s20.w),
            ),
          ],
        ),
      ),
    ),
  );
}
