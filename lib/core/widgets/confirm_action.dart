import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../extensions/animate_extensions.dart';
import '../utils/utils.dart';

Future<bool> confirmAction(BuildContext context, String message) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.pleaseConfirm.tr()),
        content: Text(message.tr()).fadeSlideIn(),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.muted),
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppStrings.cancel.tr()),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.ink),
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppStrings.confirm.tr()),
          ),
        ],
      ),
    ) ??
    false;
