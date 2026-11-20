import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/utils.dart';
import '../../domain/entities/customer_entity.dart';

class CustomerFilters extends StatelessWidget {
  const CustomerFilters({
    super.key,
    required this.filter,
    required this.totalCount,
    required this.onChanged,
  });
  final CustomerFilter filter;
  final int totalCount;
  final ValueChanged<CustomerFilter> onChanged;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (final item in CustomerFilter.values) ...[
        if (item != CustomerFilter.all) Gap(Sizes.s8.w),
        Expanded(
          child: Semantics(
            selected: filter == item,
            button: true,
            child: InkWell(
              borderRadius: BorderRadius.circular(Sizes.s8.r),
              onTap: () => onChanged(item),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.s4.w,
                  vertical: Sizes.s4.h,
                ),
                decoration: BoxDecoration(
                  color: filter == item ? AppColors.primary : AppColors.white,
                  borderRadius: BorderRadius.circular(Sizes.s8.r),
                ),
                child: Text(
                  switch (item) {
                    CustomerFilter.all => AppStrings.customersAll.tr(
                      namedArgs: {
                        'count': NumberFormat.decimalPattern(
                          context.locale.toString(),
                        ).format(totalCount),
                      },
                    ),
                    CustomerFilter.overdue => AppStrings.customerOverdue.tr(),
                    CustomerFilter.regular => AppStrings.customerRegular.tr(),
                  },
                  textAlign: TextAlign.center,
                  style: AppTextStyles.style11W700.copyWith(
                    fontSize: Sizes.s11.sp,
                    fontWeight: FontWeight.w400,
                    color: filter == item ? AppColors.ink : AppColors.muted,
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
