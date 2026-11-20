import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

import '../utils/app_strings.dart';

String formatMoney(BuildContext context, int minor) => NumberFormat.currency(
  locale: context.locale.toString(),
  symbol: AppStrings.egp.tr(),
  decimalDigits: minor % 100 == 0 ? 0 : 2,
).format(minor / 100);

String formatQuantity(BuildContext context, int milli) =>
    NumberFormat.decimalPattern(context.locale.toString()).format(milli / 1000);
