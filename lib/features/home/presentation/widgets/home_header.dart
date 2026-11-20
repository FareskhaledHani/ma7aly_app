import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/animate_extensions.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/svg_image.dart';
import '../../domain/entities/home_identity_entity.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.identity,
    required this.onNotifications,
  });
  final HomeIdentityEntity identity;
  final VoidCallback onNotifications;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              identity.ownerName.isEmpty
                  ? AppStrings.homeWelcome.tr()
                  : AppStrings.homeGreeting.tr(
                      namedArgs: {'name': identity.ownerName},
                    ),
              style: AppTextStyles.style11W700.copyWith(
                fontSize: Sizes.s11.sp,
                height: 1.55,
                fontWeight: FontWeight.w400,
                color: AppColors.muted,
              ),
            ),
            Text(
              identity.shopName.isEmpty
                  ? AppStrings.homeShopFallback.tr()
                  : identity.shopName,
              style: AppTextStyles.style22W700.copyWith(fontSize: Sizes.s22.sp),
            ),
          ],
        ),
      ),
      IconButton(
        onPressed: onNotifications,
        tooltip: AppStrings.homeFollowUp.tr(),
        icon: SizedBox(
          width: Sizes.s22.w,
          height: Sizes.s22.w,
          child: SvgImage(AppIcons.homeBell),
        ),
      ),
    ],
  ).fadeSlideIn();
}
