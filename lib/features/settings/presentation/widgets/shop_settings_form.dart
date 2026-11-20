import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/animate_extensions.dart';
import '../../../../core/helpers/auth_validators.dart';
import '../../../../core/helpers/customer_input.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/form_hint.dart';
import '../../../../core/widgets/main_button.dart';
import '../../domain/entities/shop_settings_entity.dart';

class ShopSettingsForm extends StatefulWidget {
  const ShopSettingsForm({
    super.key,
    required this.settings,
    required this.followUp,
    required this.isLoading,
    required this.onSave,
  });
  final ShopSettingsEntity settings;
  final bool followUp;
  final bool isLoading;
  final ValueChanged<ShopSettingsEntity> onSave;
  @override
  State<ShopSettingsForm> createState() => _ShopSettingsFormState();
}

class _ShopSettingsFormState extends State<ShopSettingsForm> {
  final _key = GlobalKey<FormState>();
  late final TextEditingController _name, _phone, _percent, _days;
  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.settings.shopName);
    _phone = TextEditingController(text: widget.settings.phone);
    _percent = TextEditingController(
      text: '${widget.settings.minimumPaymentPercent}',
    );
    _days = TextEditingController(text: '${widget.settings.warningDays}');
  }

  @override
  void dispose() {
    for (final c in [_name, _phone, _percent, _days]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    if (widget.isLoading || !(_key.currentState?.validate() ?? false)) return;
    widget.onSave(
      ShopSettingsEntity(
        shopName: _name.text.trim(),
        phone: CustomerInput.digits(_phone.text.trim()),
        email: widget.settings.email,
        minimumPaymentPercent:
            int.tryParse(CustomerInput.digits(_percent.text)) ??
            widget.settings.minimumPaymentPercent,
        warningDays:
            int.tryParse(CustomerInput.digits(_days.text)) ??
            widget.settings.warningDays,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Form(
    key: _key,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.followUp) ...[
          AppTextField(
            controller: _percent,
            label: AppStrings.followUpPercent.tr(),
            maxLength: 3,
            enabled: !widget.isLoading,
            keyboardType: TextInputType.number,
            validator: (v) {
              final n = int.tryParse(CustomerInput.digits(v ?? ''));
              return n == null || n < 1 || n > 100
                  ? AppStrings.settingsInvalid
                  : null;
            },
          ),
          Gap(Sizes.s20.h),
          AppTextField(
            controller: _days,
            label: AppStrings.warningDays.tr(),
            maxLength: 2,
            enabled: !widget.isLoading,
            keyboardType: TextInputType.number,
            validator: (v) {
              final n = int.tryParse(CustomerInput.digits(v ?? ''));
              return n == null || n < 0 || n > 30
                  ? AppStrings.settingsInvalid
                  : null;
            },
          ),
          Gap(Sizes.s20.h),
          FormHint(
            text: AppStrings.followUpRules.tr(
              namedArgs: {
                'percent': '${widget.settings.minimumPaymentPercent}',
                'days': '${widget.settings.warningDays}',
              },
            ),
          ),
        ] else ...[
          AppTextField(
            controller: _name,
            label: AppStrings.shopName.tr(),
            maxLength: 100,
            enabled: !widget.isLoading,
            validator: AuthValidators.name,
          ),
          Gap(Sizes.s20.h),
          AppTextField(
            controller: _phone,
            label: AppStrings.phoneLabel.tr(),
            maxLength: 24,
            enabled: !widget.isLoading,
            keyboardType: TextInputType.phone,
            validator: (v) => v?.trim().isEmpty == true
                ? null
                : AuthValidators.phone(CustomerInput.digits(v ?? '')),
          ),
        ],
        Gap(Sizes.s24.h),
        MainButton(
          label: AppStrings.saveSettings.tr(),
          onPressed: _save,
          isLoading: widget.isLoading,
          textColor: AppColors.ink,
          borderRadius: Sizes.s16.r,
        ),
      ],
    ),
  ).fadeSlideIn();
}
