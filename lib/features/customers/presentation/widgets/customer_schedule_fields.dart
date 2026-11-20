import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/utils.dart';
import '../../domain/entities/customer_entity.dart';
import '../../domain/entities/repayment_schedule.dart';
import 'customer_first_due_date_field.dart';
import 'customer_schedule_hint.dart';

class CustomerScheduleFields extends StatelessWidget {
  const CustomerScheduleFields({
    super.key,
    required this.schedule,
    this.enabled = true,
  });
  final ValueNotifier<RepaymentSchedule> schedule;
  final bool enabled;

  InputDecoration _decoration(String label) => InputDecoration(
    labelText: label,
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
      horizontal: Sizes.s12.w,
      vertical: Sizes.s16.h,
    ),
  );

  @override
  Widget build(
    BuildContext context,
  ) => ValueListenableBuilder<RepaymentSchedule>(
    valueListenable: schedule,
    builder: (context, value, _) {
      final date = value.firstDueDate;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.repaymentSchedule.tr(),
            style: AppTextStyles.style16W600.copyWith(fontSize: Sizes.s16.sp),
          ),
          Gap(Sizes.s16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DropdownButtonFormField<RepaymentFrequency>(
                  initialValue: value.frequency,
                  isExpanded: true,
                  alignment: Alignment.center,
                  icon: const SizedBox.shrink(),
                  decoration: _decoration(AppStrings.repaymentFrequency.tr()),
                  style: AppTextStyles.style13W400.copyWith(
                    fontFamily: AppFonts.cairo,
                    fontSize: Sizes.s13.sp,
                    color: AppColors.ink,
                  ),
                  items: RepaymentFrequency.values
                      .map(
                        (frequency) => DropdownMenuItem(
                          value: frequency,
                          child: Text(switch (frequency) {
                            RepaymentFrequency.monthly =>
                              AppStrings.monthly.tr(),
                            RepaymentFrequency.weekly => AppStrings.weekly.tr(),
                            RepaymentFrequency.once =>
                              AppStrings.specificDate.tr(),
                          }),
                        ),
                      )
                      .toList(),
                  onChanged: !enabled
                      ? null
                      : (frequency) {
                          if (frequency == null) return;
                          schedule.value = RepaymentSchedule(
                            frequency: frequency,
                            firstDueDate: date,
                            day: frequency == RepaymentFrequency.once
                                ? null
                                : frequency == RepaymentFrequency.monthly
                                ? date.day
                                : date.weekday,
                          );
                        },
                ),
              ),
              if (value.frequency != RepaymentFrequency.once) ...[
                Gap(Sizes.s12.w),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    key: ValueKey('${value.frequency.name}-${value.day}'),
                    initialValue: value.day,
                    isExpanded: true,
                    alignment: Alignment.center,
                    icon: const SizedBox.shrink(),
                    decoration: _decoration(AppStrings.repaymentDay.tr()),
                    style: AppTextStyles.style13W400.copyWith(
                      fontFamily: AppFonts.cairo,
                      fontSize: Sizes.s13.sp,
                      color: AppColors.ink,
                    ),
                    items: List.generate(
                      value.frequency == RepaymentFrequency.monthly ? 31 : 7,
                      (index) {
                        final day = index + 1;
                        final label =
                            value.frequency == RepaymentFrequency.monthly
                            ? NumberFormat.decimalPattern(
                                context.locale.toString(),
                              ).format(day)
                            : DateFormat.EEEE(context.locale.toString())
                                  .format(DateTime(2024, 1, day));
                        return DropdownMenuItem(value: day, child: Text(label));
                      },
                    ),
                    onChanged: !enabled
                        ? null
                        : (day) {
                            if (day == null) return;
                            final adjusted =
                                value.frequency == RepaymentFrequency.monthly
                                ? DateTime(
                                    date.year,
                                    date.month,
                                    math.min(
                                      day,
                                      DateTime(
                                        date.year,
                                        date.month + 1,
                                        0,
                                      ).day,
                                    ),
                                  )
                                : date.add(Duration(days: day - date.weekday));
                            schedule.value = RepaymentSchedule(
                              frequency: value.frequency,
                              firstDueDate: adjusted,
                              day: day,
                            );
                          },
                  ),
                ),
              ],
            ].reversed.toList(),
          ),
          Gap(Sizes.s16.h),
          CustomerFirstDueDateField(
            date: date,
            enabled: enabled,
            onChanged: (picked) {
              schedule.value = RepaymentSchedule(
                frequency: value.frequency,
                firstDueDate: picked,
                day: value.frequency == RepaymentFrequency.once
                    ? null
                    : value.frequency == RepaymentFrequency.monthly
                    ? picked.day
                    : picked.weekday,
              );
            },
          ),
          Gap(Sizes.s12.h),
          const CustomerScheduleHint(),
        ],
      );
    },
  );
}
