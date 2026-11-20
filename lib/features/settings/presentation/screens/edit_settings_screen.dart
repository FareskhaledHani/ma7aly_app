import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app_injector.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/section_app_bar.dart';
import '../../domain/entities/shop_settings_entity.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../widgets/shop_settings_form.dart';

class EditSettingsArgs {
  const EditSettingsArgs({required this.settings, required this.followUp});
  final ShopSettingsEntity settings;
  final bool followUp;
}

class EditSettingsScreen extends StatelessWidget {
  const EditSettingsScreen({super.key, required this.args});
  final EditSettingsArgs args;
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<SettingsCubit>(),
    child: BlocConsumer<SettingsCubit, SettingsState>(
      listenWhen: (a, b) => a.event != b.event,
      listener: (context, state) {
        if (state.message == AppStrings.settingsSaved) {
          Navigator.pop(context, true);
        } else if (state.message != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message!.tr())));
        }
      },
      builder: (context, state) => PopScope(
        canPop: !state.busy,
        child: Scaffold(
          appBar: SectionAppBar(
            title:
                (args.followUp
                        ? AppStrings.customerFollowUp
                        : AppStrings.shopData)
                    .tr(),
            enabled: !state.busy,
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Sizes.s20.r),
              child: ShopSettingsForm(
                settings: args.settings,
                followUp: args.followUp,
                isLoading: state.busy,
                onSave: context.read<SettingsCubit>().save,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
