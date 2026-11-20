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
import '../../domain/entities/product_entity.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';
import '../widgets/product_card.dart';
import '../widgets/product_filters.dart';

class ProductsArgs {
  const ProductsArgs({required this.selectMode});
  final bool selectMode;
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key, required this.args, this.onBack});
  final ProductsArgs args;
  final VoidCallback? onBack;
  Future<void> _add(BuildContext context) async {
    final saved = await AppNavigator.navigateNamedTo<bool>(
      AppRoutes.addProductScreen,
    );
    if (context.mounted && saved == true) {
      context.read<ProductsCubit>().refresh();
    }
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<ProductsCubit>(),
    child: Builder(
      builder: (context) => Scaffold(
        appBar: SectionAppBar(
          title:
              (args.selectMode
                      ? AppStrings.selectProduct
                      : AppStrings.productsTab)
                  .tr(),
          onBack: onBack,
        ),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.s20.w),
            child: BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                final cubit = context.read<ProductsCubit>();
                return RefreshIndicator(
                  onRefresh: () async => cubit.refresh(),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Gap(Sizes.s12.h),
                            Text(
                              AppStrings.productsSubtitle.tr(),
                              style: AppTextStyles.style11W700.copyWith(
                                fontSize: Sizes.s11.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.muted,
                              ),
                            ),
                            Gap(Sizes.s16.h),
                            TextField(
                              onChanged: cubit.search,
                              maxLength: 100,
                              style: AppTextStyles.style13W400.copyWith(
                                fontSize: Sizes.s13.sp,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                labelText: AppStrings.productSearch.tr(),
                              hintText: AppStrings.productSearchHint.tr(),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    Sizes.s4.r,
                                  ),
                                ),
                              ),
                            ),
                            Gap(Sizes.s16.h),
                            ProductFilters(
                              value: state.filter,
                              onChanged: cubit.filter,
                            ),
                            Gap(Sizes.s16.h),
                          ],
                        ).fadeSlideIn(),
                      ),
                      PagingListener(
                        controller: cubit.paging,
                        builder: (context, page, fetch) =>
                            PagedSliverList<
                              ProductPageKey,
                              ProductEntity
                            >.separated(
                              state: page,
                              fetchNextPage: fetch,
                              shrinkWrapFirstPageIndicators: true,
                              separatorBuilder: (_, _) => Gap(Sizes.s16.h),
                              builderDelegate:
                                  PagedChildBuilderDelegate<ProductEntity>(
                                    itemBuilder: (context, item, index) =>
                                        ProductCard(
                                          key: ValueKey(item.id),
                                          product: item,
                                          onTap: args.selectMode
                                              ? () =>
                                                    Navigator.pop(context, item)
                                              : null,
                                        ).listItemAnimation(index),
                                    firstPageProgressIndicatorBuilder: (_) =>
                                        const RecordSkeleton(),
                                    newPageProgressIndicatorBuilder: (_) =>
                                        const RecordSkeleton(count: 1),
                                    noItemsFoundIndicatorBuilder: (_) =>
                                        const AppFeedback(
                                          message: AppStrings.productsEmpty,
                                        ),
                                    firstPageErrorIndicatorBuilder: (_) =>
                                        AppFeedback(
                                          message:
                                              page.error is ProductPageException
                                              ? (page.error
                                                        as ProductPageException)
                                                    .failure
                                                    .message
                                              : AppStrings.somethingWentWrong,
                                          onRetry: fetch,
                                        ),
                                    newPageErrorIndicatorBuilder: (_) =>
                                        AppFeedback(
                                          message:
                                              AppStrings.somethingWentWrong,
                                          onRetry: fetch,
                                        ),
                                  ),
                            ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: Sizes.s16.h),
                          child: MainButton(
                            label: AppStrings.addProduct.tr(),
                            onPressed: () => _add(context),
                            textColor: AppColors.ink,
                            borderRadius: Sizes.s16.r,
                            height: Sizes.s52.h,
                          ).fadeSlideIn(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
}
