import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/main.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class KidOnboardingBaseScreen extends StatelessWidget {
  final Widget body;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final String? title;

  const KidOnboardingBaseScreen({
    super.key,
    required this.body,
    this.showBackButton = true,
    this.onBackPressed,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationAwareBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.landscape ? _buildContent() : const SizedBox.shrink();
      },
    );
  }

  Widget _buildContent() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.background,
          image: const DecorationImage(
            image: AssetImage(Assets.kidBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: Get.height - MediaQuery.of(Get.context!).padding.top - MediaQuery.of(Get.context!).padding.bottom,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: showBackButton,
                    maintainAnimation: true,
                    maintainState: true,
                    maintainSize: true,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 16),
                      child: KidButton.iconOnly(
                        onTap: () {
                          onBackPressed!();
                        },
                        baseColor: AppColors.iconSecondaryVariant,
                        iconPath: Assets.icBack,
                        size: 40.r,
                        iconSize: 20.r,
                      ),
                    ),
                  ),
                  if (title != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          title!,
                          style: AppTextStyle.headingLarge,
                        ),
                      ),
                    ),
                  Expanded(child: body),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
