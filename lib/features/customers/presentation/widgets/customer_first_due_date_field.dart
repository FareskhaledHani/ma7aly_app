import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/utils.dart';

class CustomerFirstDueDateField extends StatelessWidget {
  const CustomerFirstDueDateField({
    super.key,
    required this.date,
    required this.onChanged,
    this.enabled = true,
    this.label,
  });

  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  final bool enabled;
  final String? label;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: enabled,
    child: InkWell(
      borderRadius: BorderRadius.circular(Sizes.s4.r),
      onTap: !enabled
          ? null
          : () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100, 12, 31),
              );
              if (picked == null || !context.mounted) return;
              onChanged(picked);
            },
      child: InputDecorator(
        decoration: InputDecoration(
          enabled: enabled,
          labelText: label ?? AppStrings.firstRepaymentDate.tr(),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: AppTextStyles.style13W400.copyWith(
            fontSize: Sizes.s13.sp,
            color: AppColors.muted,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.s4.r),
            borderSide: const BorderSide(color: AppColors.fieldOutline),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: Sizes.s16.w,
            vertical: Sizes.s18.h,
          ),
        ),
        child: Text(
          DateFormat.yMMMMd(context.locale.toString()).format(date),
          textAlign: TextAlign.center,
          style: AppTextStyles.style13W400.copyWith(
            fontSize: Sizes.s13.sp,
            color: enabled ? AppColors.ink : AppColors.muted,
          ),
        ),
      ),
    ),
  );
}
