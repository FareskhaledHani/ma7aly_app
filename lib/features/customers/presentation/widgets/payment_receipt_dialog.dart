import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/animate_extensions.dart';
import '../../../../core/helpers/amount_format.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/entities/customer_movement_entity.dart';

class PaymentReceiptDialog extends StatelessWidget {
  const PaymentReceiptDialog({
    super.key,
    required this.customerName,
    required this.movement,
  });
  final String customerName;
  final CustomerMovementEntity movement;
  @override
  Widget build(BuildContext context) {
    final receipt = AppStrings.paymentReceipt.tr(
      namedArgs: {
        'name': customerName,
        'amount': formatMoney(context, movement.amountMinor),
        'date': DateFormat.yMMMd(context.locale.toString())
            .format(movement.date),
        'id': movement.id,
      },
    );
    return AlertDialog(
      title: Text(AppStrings.paymentSaved.tr()),
      content: SingleChildScrollView(
        child: SelectableText(receipt).fadeSlideIn(),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(foregroundColor: AppColors.ink),
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: receipt));
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppStrings.receiptCopied.tr())),
            );
          },
          child: Text(AppStrings.copyReceipt.tr()),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: AppColors.ink),
          onPressed: () => Navigator.pop(context),
          child: Text(AppStrings.done.tr()),
        ),
      ],
    );
  }
}
