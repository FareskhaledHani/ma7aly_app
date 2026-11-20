import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../app_injector.dart';
import '../../../../config/routes/app_navigator.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/extensions/animate_extensions.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/app_feedback.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../core/widgets/record_skeleton.dart';
import '../../../../core/widgets/section_app_bar.dart';
import '../../domain/entities/customer_account_entity.dart';
import '../../domain/entities/customer_movement_entity.dart';
import '../cubit/customer_account_cubit.dart';
import '../cubit/customer_account_state.dart';
import '../widgets/customer_account_summary.dart';
import '../widgets/customer_movement_card.dart';
import 'customer_movement_args.dart';

class CustomerAccountArgs {
  const CustomerAccountArgs({required this.customerId});
  final String customerId;
}

class CustomerAccountScreen extends StatelessWidget {
  const CustomerAccountScreen({super.key, required this.args});
  final CustomerAccountArgs args;
  Future<void> _movement(
    BuildContext context,
    CustomerAccountEntity account,
    CustomerMovementKind kind, [
    CustomerMovementEntity? movement,
  ]) async {
    final saved = await AppNavigator.navigateNamedTo<bool>(
      AppRoutes.customerMovementScreen,
      arguments: CustomerMovementArgs(
        customer: account.customer,
        balanceMinor: account.balanceMinor,
        kind: kind,
        movement: movement,
      ),
    );
    if (context.mounted && saved == true) {
      context.read<CustomerAccountCubit>().load(args.customerId);
    }
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<CustomerAccountCubit>()..load(args.customerId),
    child: Scaffold(
      appBar: SectionAppBar(title: AppStrings.customerAccount.tr()),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizes.s20.w),
          child: BlocBuilder<CustomerAccountCubit, CustomerAccountState>(
            builder: (context, state) {
              final cubit = context.read<CustomerAccountCubit>();
              if (state is CustomerAccountFailure) {
                return AppFeedback(
                  message: state.message,
                  onRetry: () => cubit.load(args.customerId),
                );
              }
              if (state is! CustomerAccountSuccess) {
                return const SingleChildScrollView(child: RecordSkeleton());
              }
              final account = state.account;
              return RefreshIndicator(
                onRefresh: () => cubit.load(args.customerId),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Gap(Sizes.s16.h),
                          CustomerAccountSummary(account: account),
                          Gap(Sizes.s16.h),
                          Row(
                            children: [
                              Expanded(
                                child: MainButton(
                                  label: AppStrings.addWithdrawal.tr(),
                                  backgroundColor: AppColors.white,
                                  textColor: AppColors.ink,
                                  borderRadius: Sizes.s16.r,
                                  onPressed: () => _movement(
                                    context,
                                    account,
                                    CustomerMovementKind.withdrawal,
                                  ),
                                ),
                              ),
                              Gap(Sizes.s12.w),
                              Expanded(
                                child: MainButton(
                                  label: AppStrings.recordPayment.tr(),
                                  textColor: AppColors.ink,
                                  borderRadius: Sizes.s16.r,
                                  onPressed: () => _movement(
                                    context,
                                    account,
                                    CustomerMovementKind.payment,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Gap(Sizes.s24.h),
                          Text(
                            AppStrings.recentMovements.tr(),
                            style: AppTextStyles.style14W600.copyWith(
                              fontSize: Sizes.s14.sp,
                            ),
                          ),
                          Gap(Sizes.s12.h),
                        ],
                      ),
                    ),
                    PagingListener(
                      controller: cubit.paging,
                      builder: (context, page, fetch) =>
                          PagedSliverList<int, CustomerMovementEntity>(
                            state: page,
                            fetchNextPage: fetch,
                            shrinkWrapFirstPageIndicators: true,
                            builderDelegate:
                                PagedChildBuilderDelegate<
                                  CustomerMovementEntity
                                >(
                                  itemBuilder: (context, item, index) =>
                                      CustomerMovementCard(
                                        key: ValueKey(item.id),
                                        movement: item,
                                        onTap: () => _movement(
                                          context,
                                          account,
                                          item.kind,
                                          item,
                                        ),
                                      ).listItemAnimation(index),
                                  firstPageProgressIndicatorBuilder: (_) =>
                                      const RecordSkeleton(),
                                  newPageProgressIndicatorBuilder: (_) =>
                                      const RecordSkeleton(count: 1),
                                  noItemsFoundIndicatorBuilder: (_) =>
                                      const AppFeedback(
                                        message: AppStrings.movementsEmpty,
                                      ),
                                  firstPageErrorIndicatorBuilder: (_) =>
                                      AppFeedback(
                                        message: AppStrings.somethingWentWrong,
                                        onRetry: fetch,
                                      ),
                                ),
                          ),
                    ),
                    SliverToBoxAdapter(child: Gap(Sizes.s24.h)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}
