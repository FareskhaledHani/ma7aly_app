import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../app_injector.dart';
import '../../../../config/routes/app_navigator.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/enums/async_status.dart';
import '../../../../core/extensions/animate_extensions.dart';
import '../../../../core/helpers/amount_format.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/app_feedback.dart';
import '../../../../core/widgets/confirm_action.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../core/widgets/record_skeleton.dart';
import '../../../../core/widgets/section_app_bar.dart';
import '../../domain/entities/shop_settings_entity.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../widgets/settings_menu_item.dart';
import 'edit_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.onProducts,
    required this.onBack,
  });
  final VoidCallback onProducts;
  final VoidCallback onBack;
  Future<void> _edit(
    BuildContext context,
    ShopSettingsEntity settings,
    bool followUp,
  ) async {
    final saved = await AppNavigator.navigateNamedTo<bool>(
      AppRoutes.editSettingsScreen,
      arguments: EditSettingsArgs(settings: settings, followUp: followUp),
    );
    if (context.mounted && saved == true) context.read<SettingsCubit>().load();
  }

  Future<void> _info(BuildContext context, String title, String body) =>
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title.tr()),
          content: SingleChildScrollView(child: Text(body.tr()).fadeSlideIn()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppStrings.done.tr()),
            ),
          ],
        ),
      );
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<SettingsCubit>()..load(),
    child: BlocConsumer<SettingsCubit, SettingsState>(
      listenWhen: (a, b) => a.event != b.event || a.signedOut != b.signedOut,
      listener: (context, state) async {
        if (state.signedOut) {
          AppNavigator.navigateNamedFinishGlobal(AppRoutes.welcomeScreen);
          return;
        }
        final report = state.report;
        if (report != null) {
          if (report.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppStrings.exportEmpty.tr())),
            );
            return;
          }
          String cell(String text) {
            final safe = RegExp(r'^[=+\-@\t\r]').hasMatch(text)
                ? "'$text"
                : text;
            return '"${safe.replaceAll('"', '""')}"';
          }

          final csv = [
            [
              AppStrings.customerName.tr(),
              AppStrings.phoneLabel.tr(),
              AppStrings.currentBalance.tr(),
            ],
            ...report.map(
              (c) => [
                c.name,
                c.phone ?? '',
                formatMoney(context, c.balanceMinor),
              ],
            ),
          ].map((row) => row.map(cell).join(',')).join('\r\n');
          await Clipboard.setData(ClipboardData(text: csv));
          if (!context.mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(AppStrings.exportCopied.tr())));
        } else if (state.message != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message!.tr())));
        }
      },
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();
        final settings = state.settings;
        return Scaffold(
          appBar: SectionAppBar(
            title: AppStrings.shopSettings.tr(),
            onBack: onBack,
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Sizes.s20.r),
              child: state.status == AsyncStatus.failure
                  ? AppFeedback(
                      message: state.message ?? AppStrings.somethingWentWrong,
                      onRetry: cubit.load,
                    )
                  : settings == null
                  ? const RecordSkeleton()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.all(Sizes.s24.r),
                          decoration: BoxDecoration(
                            color: AppColors.ink,
                            borderRadius: BorderRadius.circular(Sizes.s20.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                settings.shopName.isEmpty
                                    ? AppStrings.brandName.tr()
                                    : settings.shopName,
                                style: AppTextStyles.style22W700.copyWith(
                                  fontSize: Sizes.s22.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                              Gap(Sizes.s8.h),
                              Text(
                                settings.email,
                                style: AppTextStyles.style12W400.copyWith(
                                  fontSize: Sizes.s12.sp,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ).fadeSlideIn(),
                        Gap(Sizes.s12.h),
                        if (state.busy) const RecordSkeleton(count: 1),
                        SettingsMenuItem(
                          title: AppStrings.shopData.tr(),
                          subtitle: AppStrings.shopDataHint.tr(),
                          onTap: state.busy
                              ? null
                              : () => _edit(context, settings, false),
                        ),
                        SettingsMenuItem(
                          title: AppStrings.customerFollowUp.tr(),
                          subtitle: AppStrings.customerFollowUpHint.tr(),
                          onTap: state.busy
                              ? null
                              : () => _edit(context, settings, true),
                        ),
                        SettingsMenuItem(
                          title: AppStrings.inventorySettings.tr(),
                          subtitle: AppStrings.inventorySettingsHint.tr(),
                          onTap: state.busy ? null : onProducts,
                        ),
                        SettingsMenuItem(
                          title: AppStrings.exportAccounts.tr(),
                          subtitle: AppStrings.exportAccountsHint.tr(),
                          onTap: state.busy
                              ? null
                              : () async {
                                  final confirmed = await confirmAction(
                                    context,
                                    AppStrings.exportNotice,
                                  );
                                  if (context.mounted && confirmed) {
                                    cubit.export();
                                  }
                                },
                        ),
                        SettingsMenuItem(
                          title: AppStrings.securitySettings.tr(),
                          subtitle: AppStrings.securitySettingsHint.tr(),
                          onTap: state.busy
                              ? null
                              : () async {
                                  final confirmed = await confirmAction(
                                    context,
                                    AppStrings.passwordResetAction,
                                  );
                                  if (context.mounted && confirmed) {
                                    cubit.resetPassword();
                                  }
                                },
                        ),
                        SettingsMenuItem(
                          title: AppStrings.help.tr(),
                          subtitle: AppStrings.helpHint.tr(),
                          onTap: () => _info(
                            context,
                            AppStrings.help,
                            AppStrings.helpBody,
                          ),
                        ),
                        SettingsMenuItem(
                          title: AppStrings.language.tr(),
                          subtitle: AppStrings.switchLanguage.tr(),
                          onTap: () => context.setLocale(
                            Locale(
                              context.locale.languageCode == 'ar' ? 'en' : 'ar',
                            ),
                          ),
                        ),
                        Gap(Sizes.s12.h),
                        MainButton(
                          label: AppStrings.signOut.tr(),
                          backgroundColor: AppColors.canvas,
                          textColor: AppColors.overdue,
                          isLoading: state.busy,
                          onPressed: () async {
                            final confirmed = await confirmAction(
                              context,
                              AppStrings.signOutConfirm,
                            );
                            if (context.mounted && confirmed) cubit.signOut();
                          },
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
