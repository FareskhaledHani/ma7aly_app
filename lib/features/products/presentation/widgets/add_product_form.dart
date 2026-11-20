import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/animate_extensions.dart';
import '../../../../core/helpers/customer_input.dart';
import '../../../../core/helpers/record_id.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/form_hint.dart';
import '../../../../core/widgets/main_button.dart';
import '../../domain/entities/product_entity.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({
    super.key,
    required this.onSave,
    required this.isLoading,
  });
  final ValueChanged<ProductEntity> onSave;
  final bool isLoading;
  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _key = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _unit = TextEditingController();
  final _price = TextEditingController();
  final _cost = TextEditingController();
  final _stock = TextEditingController();
  final _threshold = TextEditingController();
  final _extra = TextEditingController();
  final _tracking = ValueNotifier(true);
  final _id = RecordId.create();
  @override
  void dispose() {
    for (final c in [_name, _unit, _price, _cost, _stock, _threshold, _extra]) {
      c.dispose();
    }
    _tracking.dispose();
    super.dispose();
  }

  String? _money(String? text) => CustomerInput.moneyMinor(text ?? '') == null
      ? AppStrings.productInvalid
      : null;
  String? _quantity(String? text) =>
      (text?.trim().isEmpty ?? true) ||
          CustomerInput.quantityMilli(text!) != null
      ? null
      : AppStrings.quantityInvalid;
  Widget _field(
    TextEditingController c,
    String label, {
    bool required = false,
    bool money = false,
    bool quantity = false,
    int max = 100,
  }) => AppTextField(
    controller: c,
    label: label.tr(),
    enabled: !widget.isLoading,
    maxLength: max,
    textAlign: TextAlign.center,
    keyboardType: money || quantity
        ? const TextInputType.numberWithOptions(decimal: true)
        : TextInputType.text,
    validator: (text) => required && (text?.trim().isEmpty ?? true)
        ? AppStrings.requiredField
        : money
        ? _money(text)
        : quantity
        ? _quantity(text)
        : null,
  );
  void _save() {
    if (widget.isLoading || !(_key.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    widget.onSave(
      ProductEntity(
        id: _id,
        name: _name.text.trim(),
        unit: _unit.text.trim(),
        priceMinor: CustomerInput.moneyMinor(_price.text) ?? 0,
        costMinor: _cost.text.trim().isEmpty
            ? null
            : CustomerInput.moneyMinor(_cost.text),
        trackInventory: _tracking.value,
        stockMilli: _tracking.value
            ? CustomerInput.quantityMilli(_stock.text) ?? 0
            : 0,
        lowStockMilli: _tracking.value
            ? CustomerInput.quantityMilli(_threshold.text) ?? 0
            : 0,
        extraUnit: _extra.text.trim().isEmpty ? null : _extra.text.trim(),
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
          AppStrings.addProductSubtitle.tr(),
          style: AppTextStyles.style12W400.copyWith(
            fontSize: Sizes.s12.sp,
            color: AppColors.muted,
          ),
        ),
        Gap(Sizes.s20.h),
        _field(_name, AppStrings.productName, required: true),
        Gap(Sizes.s16.h),
        _field(_unit, AppStrings.productUnit, required: true, max: 24),
        Gap(Sizes.s16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _field(
                _price,
                AppStrings.productPrice,
                required: true,
                money: true,
                max: 13,
              ),
            ),
            Gap(Sizes.s12.w),
            Expanded(
              child: _field(
                _cost,
                AppStrings.productCost,
                money: true,
                max: 13,
              ),
            ),
          ],
        ),
        Gap(Sizes.s16.h),
        ValueListenableBuilder<bool>(
          valueListenable: _tracking,
          builder: (context, tracking, _) => Column(
            children: [
              Material(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(Sizes.s20.r),
                clipBehavior: Clip.antiAlias,
                child: SwitchListTile(
                  value: tracking,
                  onChanged: widget.isLoading
                      ? null
                      : (value) => _tracking.value = value,
                  activeThumbColor: AppColors.primary,
                  title: Text(
                    (tracking
                            ? AppStrings.inventoryEnabled
                            : AppStrings.inventoryDisabled)
                        .tr(),
                    style: AppTextStyles.style14W600.copyWith(
                      fontSize: Sizes.s14.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  subtitle: Text(
                    AppStrings.inventoryToggleHint.tr(),
                    style: AppTextStyles.style11W700.copyWith(
                      fontSize: Sizes.s11.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              if (tracking) ...[
                Gap(Sizes.s16.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _field(
                        _stock,
                        AppStrings.productStock,
                        quantity: true,
                        max: 10,
                      ),
                    ),
                    Gap(Sizes.s12.w),
                    Expanded(
                      child: _field(
                        _threshold,
                        AppStrings.productThreshold,
                        quantity: true,
                        max: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        Gap(Sizes.s16.h),
        FormHint(text: AppStrings.inventoryOffHint.tr()),
        Gap(Sizes.s16.h),
        _field(_extra, AppStrings.productExtraUnit, max: 100),
        Gap(Sizes.s16.h),
        MainButton(
          label: AppStrings.saveProduct.tr(),
          onPressed: _save,
          isLoading: widget.isLoading,
          height: Sizes.s52.h,
          textColor: AppColors.ink,
          borderRadius: Sizes.s16.r,
        ),
        Gap(Sizes.s20.h),
      ],
    ),
  ).fadeSlideIn();
}
