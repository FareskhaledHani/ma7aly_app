import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/svg_image.dart';

class SettingsMenuItem extends StatelessWidget {
  const SettingsMenuItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    onTap: onTap,
    title: Text(
      title,
      style: AppTextStyles.style14W600.copyWith(fontSize: Sizes.s14.sp),
    ),
    subtitle: Text(
      subtitle,
      style: AppTextStyles.style11W700.copyWith(
        fontSize: Sizes.s11.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.muted,
      ),
    ),
    trailing: SvgImage.icon(
      AppIcons.arrow,
      color: AppColors.muted,
      size: Sizes.s18.w,
    ),
  );
}
