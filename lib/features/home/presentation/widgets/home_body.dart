import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../config/routes/app_navigator.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/enums/async_status.dart';
import '../../../../core/extensions/animate_extensions.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/app_feedback.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../core/widgets/record_skeleton.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'home_balance_summary.dart';
import 'home_follow_up_card.dart';
import 'home_header.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key, required this.onOpenCustomer});
  final Future<void> Function(String) onOpenCustomer;
  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final _followUpKey = GlobalKey();
  Future<void> _add() async {
    final saved = await AppNavigator.navigateNamedTo<bool>(
      AppRoutes.addCustomerScreen,
    );
    if (mounted && saved == true) await context.read<HomeCubit>().load();
  }

  Future<void> _open(String id) async {
    await widget.onOpenCustomer(id);
    if (mounted) await context.read<HomeCubit>().load();
  }

  void _notifications() {
    final target = _followUpKey.currentContext;
    if (target != null) Scrollable.ensureVisible(target);
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final overview = state.overview;
        final cubit = context.read<HomeCubit>();
        return RefreshIndicator(
          onRefresh: cubit.load,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(Sizes.s20.r),
                sliver: SliverList.list(
                  children: [
                    if (state.status == AsyncStatus.loading ||
                        state.status == AsyncStatus.initial)
                      const RecordSkeleton()
                    else if (state.status == AsyncStatus.failure)
                      AppFeedback(
                        message:
                            state.errorMessage ?? AppStrings.somethingWentWrong,
                        onRetry: cubit.load,
                      )
                    else if (overview != null) ...[
                      HomeHeader(
                        identity: overview.identity,
                        onNotifications: _notifications,
                      ),
                      Gap(Sizes.s16.h),
                      HomeBalanceSummary(overview: overview),
                      Gap(Sizes.s16.h),
                      Text(
                        AppStrings.homeFollowUp.tr(),
                        key: _followUpKey,
                        style: AppTextStyles.style14W600.copyWith(
                          fontSize: Sizes.s14.sp,
                          height: 1.55,
                          fontWeight: FontWeight.w700,
                        ),
                      ).fadeSlideIn(),
                      Gap(Sizes.s16.h),
                      if (overview.followUp.isEmpty)
                        const AppFeedback(message: AppStrings.homeNoFollowUp),
                      ...overview.followUp.asMap().entries.map(
                        (entry) => Padding(
                          key: ValueKey(entry.value.id),
                          padding: EdgeInsets.only(bottom: Sizes.s16.h),
                          child: HomeFollowUpCard(
                            item: entry.value,
                            onTap: () => _open(entry.value.id),
                          ).listItemAnimation(entry.key),
                        ),
                      ),
                      MainButton(
                        label: AppStrings.homeAddCustomer.tr(),
                        onPressed: _add,
                        textColor: AppColors.ink,
                        textStyle: AppTextStyles.style14W600.copyWith(
                          fontSize: Sizes.s14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                          height: 1.55,
                        ),
                        height: Sizes.s52.h,
                        borderRadius: Sizes.s16.r,
                      ).fadeSlideIn(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
