import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/animate_extensions.dart';
import '../../../../core/helpers/auth_validators.dart';
import '../../../../core/helpers/customer_input.dart';
import '../../../../core/helpers/record_id.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/main_button.dart';
import '../../domain/entities/customer_entity.dart';
import '../../domain/entities/repayment_schedule.dart';
import '../../domain/usecases/add_customer_usecase.dart';
import 'customer_schedule_fields.dart';

class AddCustomerForm extends StatefulWidget {
  const AddCustomerForm({
    super.key,
    required this.onSave,
    this.isLoading = false,
  });
  final ValueChanged<AddCustomerParams> onSave;
  final bool isLoading;
  @override
  State<AddCustomerForm> createState() => _AddCustomerFormState();
}

class _AddCustomerFormState extends State<AddCustomerForm> {
  final _key = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _description = TextEditingController();
  final _balance = TextEditingController();
  late final ValueNotifier<RepaymentSchedule> _schedule;
  late final String _requestId;
  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _schedule = ValueNotifier(
      RepaymentSchedule(
        frequency: RepaymentFrequency.monthly,
        firstDueDate: DateTime(today.year, today.month, today.day),
        day: today.day,
      ),
    );
    _requestId = RecordId.create();
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _description.dispose();
    _balance.dispose();
    _schedule.dispose();
    super.dispose();
  }

  void _save() {
    if (widget.isLoading || !(_key.currentState?.validate() ?? false)) return;
    final amount = CustomerInput.moneyMinor(_balance.text);
    if (amount == null) return;
    FocusScope.of(context).unfocus();
    final schedule = _schedule.value;
    widget.onSave(
      AddCustomerParams(
        name: _name.text.trim(),
        phone: _phone.text.trim().isEmpty
            ? null
            : CustomerInput.digits(_phone.text.trim()),
        description: _description.text.trim().isEmpty
            ? null
            : _description.text.trim(),
        openingBalanceMinor: amount,
        dueDate: schedule.firstDueDate,
        frequency: schedule.frequency,
        repaymentDay: schedule.day,
        requestId: _requestId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Form(
    key: _key,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.addCustomerSubtitle.tr(),
          style: AppTextStyles.style12W400.copyWith(
            fontSize: Sizes.s12.sp,
            color: AppColors.muted,
          ),
        ),
        Gap(Sizes.s20.h),
        AppTextField(
          controller: _name,
          label: AppStrings.customerName.tr(),
          hintText: AppStrings.customerNameHint.tr(),
          textAlign: TextAlign.center,
          maxLength: 100,
          enabled: !widget.isLoading,
          validator: AuthValidators.name,
        ),
        Gap(Sizes.s16.h),
        AppTextField(
          controller: _phone,
          label: AppStrings.customerPhoneOptional.tr(),
          hintText: AppStrings.customerPhoneHint.tr(),
          textAlign: TextAlign.center,
          maxLength: 24,
          keyboardType: TextInputType.phone,
          enabled: !widget.isLoading,
          validator: (text) => text?.trim().isNotEmpty == true
              ? AuthValidators.phone(CustomerInput.digits(text!))
              : null,
        ),
        Gap(Sizes.s16.h),
        AppTextField(
          controller: _description,
          label: AppStrings.customerDescriptionOptional.tr(),
          hintText: AppStrings.customerDescriptionHint.tr(),
          textAlign: TextAlign.center,
          maxLength: 300,
          enabled: !widget.isLoading,
        ),
        Gap(Sizes.s16.h),
        AppTextField(
          controller: _balance,
          label: AppStrings.customerOpeningBalance.tr(),
          hintText: NumberFormat.currency(
            locale: context.locale.toString(),
            symbol: AppStrings.egp.tr(),
            decimalDigits: 0,
          ).format(0),
          textAlign: TextAlign.center,
          maxLength: 13,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          enabled: !widget.isLoading,
          validator: (text) => CustomerInput.moneyMinor(text ?? '') == null
              ? AppStrings.customerBalanceInvalid
              : null,
        ),
        Gap(Sizes.s24.h),
        CustomerScheduleFields(schedule: _schedule, enabled: !widget.isLoading),
        Gap(Sizes.s24.h),
        MainButton(
          label: AppStrings.saveCustomer.tr(),
          onPressed: widget.isLoading ? null : _save,
          isLoading: widget.isLoading,
          height: Sizes.s52.h,
          borderRadius: Sizes.s16.r,
          textColor: AppColors.ink,
          textStyle: AppTextStyles.style14W600.copyWith(
            color: AppColors.ink,
            fontSize: Sizes.s14.sp,
          ),
          elevation: Sizes.zero,
        ),
        Gap(Sizes.s20.h),
      ],
    ),
  ).fadeSlideIn();
}
