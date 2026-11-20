import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../config/routes/app_navigator.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/extensions/animate_extensions.dart';
import '../../../../core/helpers/customer_input.dart';
import '../../../../core/helpers/record_id.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/confirm_action.dart';
import '../../../../core/widgets/form_hint.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../core/widgets/money_panel.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/entities/customer_movement_entity.dart';
import '../../domain/usecases/save_customer_movement_usecase.dart';
import '../cubit/save_customer_movement_cubit.dart';
import '../screens/customer_movement_args.dart';
import 'customer_first_due_date_field.dart';
import 'movement_product_field.dart';
import 'payment_amount_field.dart';
import 'payment_balance_preview.dart';

class CustomerMovementForm extends StatefulWidget {
  const CustomerMovementForm({
    super.key,
    required this.args,
    required this.isLoading,
  });
  final CustomerMovementArgs args;
  final bool isLoading;
  @override
  State<CustomerMovementForm> createState() => _CustomerMovementFormState();
}

class _CustomerMovementFormState extends State<CustomerMovementForm> {
  final _key = GlobalKey<FormState>();
  late final TextEditingController _quantity,
      _unit,
      _price,
      _amount,
      _note,
      _method;
  late final ValueNotifier<DateTime> _date;
  late final ValueNotifier<ProductEntity?> _product;
  final _computed = ValueNotifier<int?>(null);
  late final String _id;
  bool get _payment => widget.args.kind == CustomerMovementKind.payment;
  @override
  void initState() {
    super.initState();
    final m = widget.args.movement;
    _id = m?.id ?? RecordId.create();
    _quantity = TextEditingController(
      text: m?.quantityMilli == null
          ? ''
          : CustomerInput.decimal(m!.quantityMilli!, 3),
    );
    _unit = TextEditingController(text: m?.unit ?? '');
    _price = TextEditingController(
      text: m?.unitPriceMinor == null
          ? ''
          : CustomerInput.decimal(m!.unitPriceMinor!, 2),
    );
    _amount = TextEditingController(
      text: m == null ? '' : CustomerInput.decimal(m.amountMinor, 2),
    );
    _note = TextEditingController(text: m?.note ?? '');
    _method = TextEditingController(
      text: m?.paymentMethod ?? AppStrings.cash.tr(),
    );
    _date = ValueNotifier(m?.date ?? DateTime.now());
    _product = ValueNotifier(
      m?.productId == null
          ? null
          : ProductEntity(
              id: m!.productId!,
              name: m.productName ?? '',
              unit: m.unit ?? '',
              priceMinor: m.unitPriceMinor ?? 0,
              trackInventory: m.trackedInventory,
            ),
    );
    _quantity.addListener(_calculate);
    _price.addListener(_calculate);
    _calculate();
  }

  @override
  void dispose() {
    for (final c in [_quantity, _unit, _price, _amount, _note, _method]) {
      c.dispose();
    }
    _date.dispose();
    _product.dispose();
    _computed.dispose();
    super.dispose();
  }

  void _calculate() {
    final total = context.read<SaveCustomerMovementCubit>().calculateTotal(
      _quantity.text,
      _price.text,
    );
    _computed.value = total;
    if (total != null) _amount.text = CustomerInput.decimal(total, 2);
  }

  Future<void> _selectProduct() async {
    final product = await AppNavigator.navigateNamedTo<ProductEntity>(
      AppRoutes.selectProductScreen,
    );
    if (!mounted || product == null) return;
    _product.value = product;
    _unit.text = product.unit;
    if (_quantity.text.trim().isEmpty) _quantity.text = '1';
    _price.text = CustomerInput.decimal(product.priceMinor, 2);
  }

  void _save() {
    if (widget.isLoading || !(_key.currentState?.validate() ?? false)) return;
    final amount = CustomerInput.moneyMinor(_amount.text);
    if (amount == null || amount <= 0) return;
    FocusScope.of(context).unfocus();
    final product = _product.value;
    final m = CustomerMovementEntity(
      id: _id,
      kind: widget.args.kind,
      amountMinor: amount,
      date: _date.value,
      note: _note.text.trim().isEmpty ? null : _note.text.trim(),
      quantityMilli: _payment || _quantity.text.trim().isEmpty
          ? null
          : CustomerInput.quantityMilli(_quantity.text),
      unit: _payment || _unit.text.trim().isEmpty ? null : _unit.text.trim(),
      unitPriceMinor: _payment || _price.text.trim().isEmpty
          ? null
          : CustomerInput.moneyMinor(_price.text),
      paymentMethod: _payment ? _method.text.trim() : null,
      productId: _payment ? null : product?.id,
      productName: _payment ? null : product?.name,
      trackedInventory: !_payment && (product?.trackInventory ?? false),
    );
    context.read<SaveCustomerMovementCubit>().save(
      SaveCustomerMovementParams(
        customerId: widget.args.customer.id,
        movement: m,
        expectedRevision: widget.args.movement?.revision,
      ),
    );
  }

  Future<void> _delete() async {
    final movement = widget.args.movement;
    if (movement == null || widget.isLoading) return;
    final confirmed = await confirmAction(
      context,
      AppStrings.deleteMovementConfirm,
    );
    if (!mounted || !confirmed) return;
    context.read<SaveCustomerMovementCubit>().save(
      SaveCustomerMovementParams(
        customerId: widget.args.customer.id,
        movement: movement,
        expectedRevision: movement.revision,
        delete: true,
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int max = 24,
    bool number = false,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) => AppTextField(
    controller: controller,
    label: label.tr(),
    enabled: !widget.isLoading,
    maxLength: max,
    textAlign: TextAlign.center,
    readOnly: readOnly,
    keyboardType: number
        ? const TextInputType.numberWithOptions(decimal: true)
        : TextInputType.text,
    validator: validator,
  );
  @override
  Widget build(BuildContext context) => Form(
    key: _key,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.args.customer.name,
          style: AppTextStyles.style12W400.copyWith(
            fontSize: Sizes.s12.sp,
            color: AppColors.muted,
          ),
        ),
        Gap(Sizes.s16.h),
        if (_payment)
          PaymentAmountField(controller: _amount, enabled: !widget.isLoading)
        else ...[
          ValueListenableBuilder<ProductEntity?>(
            valueListenable: _product,
            builder: (context, product, _) => MovementProductField(
              name: product?.name,
              onSelect: _selectProduct,
              onClear: () => _product.value = null,
              enabled: !widget.isLoading,
            ),
          ),
          Gap(Sizes.s16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _field(
                  _quantity,
                  AppStrings.quantity,
                  max: 10,
                  number: true,
                  validator: (value) =>
                      (value?.trim().isEmpty ?? true) && _product.value == null
                      ? null
                      : (CustomerInput.quantityMilli(value ?? '') ?? 0) <= 0
                      ? AppStrings.quantityInvalid
                      : null,
                ),
              ),
              Gap(Sizes.s12.w),
              Expanded(
                child: ValueListenableBuilder<ProductEntity?>(
                  valueListenable: _product,
                  builder: (context, product, _) =>
                      _field(_unit, AppStrings.unit, readOnly: product != null),
                ),
              ),
            ],
          ),
          Gap(Sizes.s16.h),
          _field(
            _price,
            AppStrings.unitPrice,
            max: 13,
            number: true,
            validator: (v) => CustomerInput.moneyMinor(v ?? '') == null
                ? AppStrings.movementInvalid
                : null,
          ),
          Gap(Sizes.s16.h),
          ValueListenableBuilder<int?>(
            valueListenable: _computed,
            builder: (context, total, _) =>
                widget.args.movement == null && total != null && total > 0
                ? MoneyPanel(
                    label: AppStrings.withdrawalTotal.tr(),
                    amountMinor: total,
                  )
                : _field(
                    _amount,
                    AppStrings.withdrawalTotal,
                    max: 13,
                    number: true,
                    readOnly: total != null,
                    validator: (v) =>
                        (CustomerInput.moneyMinor(v ?? '') ?? 0) <= 0
                        ? AppStrings.movementInvalid
                        : null,
                  ),
          ),
        ],
        Gap(Sizes.s16.h),
        ValueListenableBuilder<DateTime>(
          valueListenable: _date,
          builder: (context, date, _) => CustomerFirstDueDateField(
            date: date,
            label: (_payment ? AppStrings.paymentDate : AppStrings.movementDate)
                .tr(),
            enabled: !widget.isLoading,
            onChanged: (value) => _date.value = value,
          ),
        ),
        if (_payment) ...[
          Gap(Sizes.s16.h),
          _field(
            _method,
            AppStrings.paymentMethod,
            max: 50,
            validator: (v) =>
                v?.trim().isNotEmpty == true ? null : AppStrings.requiredField,
          ),
        ],
        Gap(Sizes.s16.h),
        _field(_note, AppStrings.optionalNote, max: 300),
        Gap(Sizes.s16.h),
        if (_payment)
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _amount,
            builder: (context, value, _) => PaymentBalancePreview(
              currentBalance: widget.args.balanceMinor,
              nextBalance: context
                  .read<SaveCustomerMovementCubit>()
                  .balanceAfter(
                    widget.args.balanceMinor,
                    value.text,
                    previousPaymentMinor:
                        widget.args.movement?.amountMinor ?? 0,
                  ),
            ),
          )
        else
          FormHint(text: AppStrings.movementInventoryHint.tr()),
        Gap(Sizes.s16.h),
        MainButton(
          label:
              (_payment
                      ? AppStrings.confirmPayment
                      : widget.args.movement == null
                      ? AppStrings.saveWithdrawal
                      : AppStrings.saveChanges)
                  .tr(),
          onPressed: _save,
          isLoading: widget.isLoading,
          height: Sizes.s52.h,
          textColor: AppColors.ink,
          borderRadius: Sizes.s16.r,
        ),
        if (widget.args.movement != null) ...[
          Gap(Sizes.s12.h),
          TextButton(
            onPressed: widget.isLoading ? null : _delete,
            child: Text(
              AppStrings.deleteMovement.tr(),
              style: AppTextStyles.style14W600.copyWith(
                fontSize: Sizes.s14.sp,
                color: AppColors.overdue,
              ),
            ),
          ),
        ],
        Gap(Sizes.s20.h),
      ],
    ),
  ).fadeSlideIn();
}
