import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/utils.dart';

class MovementProductField extends StatelessWidget {
  const MovementProductField({
    super.key,
    required this.name,
    required this.onSelect,
    required this.onClear,
    required this.enabled,
  });
  final String? name;
  final VoidCallback onSelect;
  final VoidCallback onClear;
  final bool enabled;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: enabled ? onSelect : null,
    borderRadius: BorderRadius.circular(Sizes.s4.r),
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: AppStrings.optionalProduct.tr(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.s4.r),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Sizes.s16.w,
          vertical: Sizes.s12.h,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name ?? AppStrings.selectProduct.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.style13W400.copyWith(fontSize: Sizes.s13.sp),
            ),
          ),
          if (name != null)
            TextButton(
              style: TextButton.styleFrom(foregroundColor: AppColors.muted),
              onPressed: enabled ? onClear : null,
              child: Text(AppStrings.clearSelection.tr()),
            ),
        ],
      ),
    ),
  );
}
