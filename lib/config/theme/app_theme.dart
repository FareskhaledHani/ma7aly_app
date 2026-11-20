import 'package:flutter/material.dart';

import '../../core/utils/utils.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData talabyDashboardTheme = ThemeData(
    useMaterial3: false,
    fontFamily: AppFonts.cairo,
    scaffoldBackgroundColor: AppColors.canvas,
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.ink,
      secondary: AppColors.ink,
      surface: AppColors.canvas,
      onSurface: AppColors.ink,
      error: AppColors.error,
    ),
  );
}
