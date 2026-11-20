import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/animate_extensions.dart';
import '../../../../core/helpers/amount_format.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/form_hint.dart';
import '../../../../core/widgets/money_panel.dart';
import '../../domain/entities/customer_account_entity.dart';
import '../../domain/entities/customer_movement_entity.dart';

class CustomerAccountSummary extends StatelessWidget {
  const CustomerAccountSummary({super.key, required this.account});
  final CustomerAccountEntity account;
  @override
  Widget build(BuildContext context) {
    final customer = account.customer;
    final today = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(Sizes.s20.r),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(Sizes.s20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                customer.name,
                style: AppTextStyles.style22W700.copyWith(
                  fontSize: Sizes.s22.sp,
                ),
              ),
              if (customer.phone != null)
                Text(
                  customer.phone!,
                  style: AppTextStyles.style12W400.copyWith(
                    fontSize: Sizes.s12.sp,
                    color: AppColors.muted,
                  ),
                ),
              if (customer.description != null)
                Text(
                  customer.description!,
                  style: AppTextStyles.style12W400.copyWith(
                    fontSize: Sizes.s12.sp,
                    color: AppColors.muted,
                  ),
                ),
              Gap(Sizes.s8.h),
              Text(
              AppStrings.customerDueOn.tr(
                  namedArgs: {
                    'date': DateFormat.yMMMd(context.locale.toString())
                      .format(customer.dueDateAt(today)),
                  },
                ),
                style: AppTextStyles.style12W400.copyWith(
                  fontSize: Sizes.s12.sp,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ).fadeSlideIn(),
        Gap(Sizes.s16.h),
        MoneyPanel(
          label:
              (account.balanceMinor < 0
                      ? AppStrings.customerCredit
                      : AppStrings.remainingDebt)
                  .tr(),
          amountMinor: account.balanceMinor.abs(),
          dark: true,
          subtitle: AppStrings.monthlyAccountTotals.tr(
            namedArgs: {
              'withdrawals': formatMoney(
                context,
                account.monthlyTotal(CustomerMovementKind.withdrawal, today),
              ),
              'payments': formatMoney(
                context,
                account.monthlyTotal(CustomerMovementKind.payment, today),
              ),
            },
          ),
        ),
        if (account.balanceMinor < 0) ...[
          Gap(Sizes.s12.h),
          FormHint(text: AppStrings.creditBalanceNotice.tr()),
        ],
      ],
    );
  }
}
