import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/utils.dart';
import '../../../../core/widgets/brand_header.dart';
import '../widgets/welcome_card.dart';
import '../widgets/welcome_heading.dart';
import '../widgets/login_section.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.s20.w,
            vertical: Sizes.s20.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BrandHeader(),
              Gap(Sizes.s16.h),
              const WelcomeHeading(),
              Gap(Sizes.s16.h),
              const WelcomeCard(),
              Gap(Sizes.s16.h),
              const LoginSection(),
            ],
          ),
        ),
      ),
    );
  }
}
