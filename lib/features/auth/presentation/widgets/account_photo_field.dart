import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../app_injector.dart';
import '../../../../core/extensions/animate_extensions.dart';
import '../../../../core/extensions/text_style.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/svg_image.dart';
import '../../domain/entities/account_photo.dart';
import '../services/account_photo_picker.dart';

class AccountPhotoField extends StatefulWidget {
  const AccountPhotoField({
    super.key,
    required this.onChanged,
    this.enabled = true,
  });
  final ValueChanged<AccountPhoto?> onChanged;
  final bool enabled;
  @override
  State<AccountPhotoField> createState() => _AccountPhotoFieldState();
}

class _AccountPhotoFieldState extends State<AccountPhotoField> {
  AccountPhoto? _photo;
  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    if (profilePhotoUploadsEnabled &&
        !kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android) {
      _select(recover: true);
    }
  }

  Future<void> _select({bool recover = false}) async {
    if (_isPicking || !widget.enabled) return;
    setState(() => _isPicking = true);
    try {
      final picker = getIt<AccountPhotoPicker>();
      final photo = recover ? await picker.recover() : await picker.pick();
      if (!mounted || photo == null) return;
      setState(() => _photo = photo);
      widget.onChanged(photo);
    } on PhotoSelectionException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message.tr())));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.photoSelectionFailed.tr())),
      );
    } finally {
      if (mounted) setState(() => _isPicking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final photo = _photo;
    return Column(
      children: [
        CircleAvatar(
          radius: Sizes.s40.r,
          backgroundColor: AppColors.primary,
          backgroundImage: photo == null ? null : MemoryImage(photo.bytes),
          child: photo == null
              ? SvgImage.icon(AppIcons.profile, size: Sizes.s32.w)
              : null,
        ),
        Gap(Sizes.s8.h),
        TextButton(
          onPressed: widget.enabled && profilePhotoUploadsEnabled && !_isPicking
              ? () => _select()
              : null,
          child: Text(
            AppStrings.choosePhoto.tr(),
            style: AppTextStyles.style13W400
                .copyColorWith(AppColors.ink)
                .copyWith(fontSize: Sizes.s13.sp),
          ),
        ),
        if (!profilePhotoUploadsEnabled)
          Text(
            AppStrings.photoAvailableLater.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.style12W400
                .copyColorWith(AppColors.muted)
                .copyWith(fontSize: Sizes.s12.sp),
          ),
        if (photo != null)
          TextButton(
            onPressed: widget.enabled && !_isPicking
                ? () {
                    setState(() => _photo = null);
                    widget.onChanged(null);
                  }
                : null,
            child: Text(AppStrings.removePhoto.tr()),
          ),
      ],
    ).fadeSlideIn();
  }
}
