import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/utils.dart';
import 'svg_image.dart';

class SectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SectionAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.enabled = true,
  });
  final String title;
  final VoidCallback? onBack;
  final bool enabled;
  @override
  Size get preferredSize => Size.fromHeight(Sizes.s64.h);
  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: AppColors.canvas,
    foregroundColor: AppColors.ink,
    elevation: Sizes.zero,
    centerTitle: false,
    titleSpacing: Sizes.zero,
    leading: IconButton(
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: enabled
          ? onBack ?? () => Navigator.of(context).maybePop()
          : null,
      icon: Transform.flip(
        flipX: Directionality.of(context) == TextDirection.ltr,
        child: SvgImage.icon(AppIcons.arrow, size: Sizes.s22.w),
      ),
    ),
    title: Text(
      title,
      style: AppTextStyles.style22W700.copyWith(fontSize: Sizes.s22.sp),
    ),
  );
}
