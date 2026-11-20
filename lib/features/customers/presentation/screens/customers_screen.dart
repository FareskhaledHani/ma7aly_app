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
import '../../../../core/extensions/text_style.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../core/widgets/svg_image.dart';
import '../../domain/entities/customer_entity.dart';
import '../cubit/customers_cubit.dart';
import '../cubit/customers_state.dart';
import '../widgets/customer_card.dart';
import '../widgets/customer_filters.dart';
import '../widgets/customers_feedback.dart';
import '../widgets/customers_skeleton.dart';
import 'customer_account_screen.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key, this.onBack});
  final VoidCallback? onBack;
  Future<void> _openAccount(
    BuildContext context,
    CustomerEntity customer,
  ) async {
    await AppNavigator.navigateNamedTo<void>(
      AppRoutes.customerAccountScreen,
      arguments: CustomerAccountArgs(customerId: customer.id),
    );
    if (context.mounted) context.read<CustomersCubit>().refresh();
  }

  Future<void> _add(BuildContext context) async {
    final saved = await AppNavigator.navigateNamedTo<bool>(
      AppRoutes.addCustomerScreen,
    );
    if (context.mounted && saved == true) {
      context.read<CustomersCubit>().refresh();
    }
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<CustomersCubit>(),
    child: Builder(
      builder: (context) {
        final cubit = context.read<CustomersCubit>();
        return SafeArea(
          bottom: false,
          child: BlocBuilder<CustomersCubit, CustomersState>(
            builder: (context, state) => Padding(
              padding: EdgeInsets.symmetric(horizontal: Sizes.s20.w),
              child: Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async => cubit.refresh(),
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Gap(Sizes.s20.h),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: onBack,
                                      icon: SvgImage.icon(
                                        AppIcons.arrow,
                                        size: Sizes.s22.w,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        AppStrings.customersTab.tr(),
                                        style: AppTextStyles.style22W700
                                            .copyWith(fontSize: Sizes.s22.sp),
                                      ),
                                    ),
                                  ],
                                ).fadeSlideIn(),
                                Gap(Sizes.s16.h),
                                Text(
                                  AppStrings.customersSubtitle.tr(),
                                  style: AppTextStyles.style11W700
                                      .copyColorWith(AppColors.muted)
                                      .copyWith(
                                        fontSize: Sizes.s11.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                                Gap(Sizes.s16.h),
                                TextField(
                                  onChanged: cubit.search,
                                  maxLength: 100,
                                  style: AppTextStyles.style13W400
                                      .copyColorWith(AppColors.ink)
                                      .copyWith(fontSize: Sizes.s13.sp),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    labelText: AppStrings.customerSearch.tr(),
                                    hintText: AppStrings.customerSearchHint
                                        .tr(),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        Sizes.s4.r,
                                      ),
                                      borderSide: const BorderSide(
                                        color: AppColors.fieldOutline,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: Sizes.s16.w,
                                      vertical: Sizes.s16.h,
                                    ),
                                  ),
                                ),
                                Gap(Sizes.s16.h),
                                CustomerFilters(
                                  filter: state.filter,
                                  totalCount: state.totalCount,
                                  onChanged: cubit.filter,
                                ),
                                Gap(Sizes.s16.h),
                              ],
                            ),
                          ),
                          PagingListener(
                            controller: cubit.paging,
                            builder: (context, page, fetch) =>
                                PagedSliverList<
                                  CustomerPageKey,
                                  CustomerEntity
                                >.separated(
                                  state: page,
                                  fetchNextPage: fetch,
                                  shrinkWrapFirstPageIndicators: true,
                                  separatorBuilder: (_, _) => Gap(Sizes.s16.h),
                                  builderDelegate:
                                      PagedChildBuilderDelegate<CustomerEntity>(
                                        itemBuilder: (context, item, index) =>
                                            CustomerCard(
                                              key: ValueKey(item.id),
                                              customer: item,
                                              today: DateTime.now(),
                                              onTap: () =>
                                                  _openAccount(context, item),
                                            ).listItemAnimation(index),
                                        firstPageProgressIndicatorBuilder: (
                                          _,
                                        ) => const CustomersSkeleton(),
                                        newPageProgressIndicatorBuilder: (_) =>
                                            const CustomersSkeleton(count: 1),
                                        noItemsFoundIndicatorBuilder: (_) =>
                                            CustomersFeedback(
                                              message:
                                                  state.query.isEmpty &&
                                                      state.filter ==
                                                          CustomerFilter.all
                                                  ? AppStrings.customersEmpty
                                                  : AppStrings
                                                        .customersNoResults,
                                            ),
                                        firstPageErrorIndicatorBuilder: (_) =>
                                            CustomersFeedback(
                                              message:
                                                  page.error
                                                      is CustomersPageException
                                                  ? (page.error
                                                            as CustomersPageException)
                                                        .failure
                                                        .message
                                                  : AppStrings
                                                        .somethingWentWrong,
                                              onRetry:
                                                  cubit.paging.fetchNextPage,
                                            ),
                                        newPageErrorIndicatorBuilder: (_) =>
                                            CustomersFeedback(
                                              message:
                                                  AppStrings.somethingWentWrong,
                                              onRetry:
                                                  cubit.paging.fetchNextPage,
                                            ),
                                      ),
                                ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: Sizes.s16.h,
                              ),
                              child: MainButton(
                                label: AppStrings.addCustomer.tr(),
                                onPressed: () => _add(context),
                                height: Sizes.s52.h,
                                borderRadius: Sizes.s16.r,
                                textColor: AppColors.ink,
                                textStyle: AppTextStyles.style14W600
                                    .copyColorWith(AppColors.ink)
                                    .copyWith(fontSize: Sizes.s14.sp),
                                elevation: Sizes.zero,
                              ).fadeSlideIn(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
