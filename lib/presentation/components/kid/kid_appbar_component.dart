import 'package:coin_kids/core/constants/global_keys.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_avatar_container.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/components/kid/money_widget.dart';
import 'package:coin_kids/presentation/components/parent/parent_text_field.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_appbar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart' show ShowCaseWidget, Showcase;

import 'kid_search_textfield.dart';



class KidAppBarComponent extends GetView<KidAppBarController>
    implements PreferredSizeWidget {
  final Widget? leadingWidget;
  final List<Widget>? actionWidgets;
  final VoidCallback? onAddMoneyTap;
  final VoidCallback? onBackPressed;
  final String? title;
  final Function(String)? onSearchChanged;

  const KidAppBarComponent({
    super.key,
    this.leadingWidget,
    this.actionWidgets,
    this.onAddMoneyTap,
    this.onBackPressed,
    this.title,
    this.onSearchChanged,
  });

  void _startShowcase(BuildContext mContext) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.shouldShowRequestMoneySpotlight()) {
        Future.delayed(Duration(milliseconds: 800), () {
          try {
            controller.showTotalMoneySpotlight.value = false;
            if (GlobalKeys.totalMoneyCardKey.currentState != null && 
                GlobalKeys.totalMoneyCardKey.currentContext != null) {
              ShowCaseWidget.of(GlobalKeys.totalMoneyCardKey.currentContext!)
                  .startShowCase([GlobalKeys.totalMoneyCardKey]);
            }
            SharedPreferencesHelper.saveBool(
                SharedPreferencesHelper.showTotalMoneySpotlight, false);
          } catch (e) {
            Get.log("Error starting showcase: $e");
          }
        });
      }
    });
  }

  Widget _buildBackButton() {
    return KidButton.iconOnly(
      onTap: onBackPressed ?? () => Get.back(),
      baseColor: AppColors.btnColorOrange,
      iconPath: Assets.icBack,
      size: 40.r,
      iconSize: 20.r,
    );
  }

  Widget _buildTitle() {
    return Text(
      title ?? '',
      style: AppTextStyle.headingLarge.copyWith(
        color: AppColors.textPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _startShowcase(context);
    return Obx(() {
      final kid = controller.appState.currentKid.value;
      if (kid == null) {
        ToastUtil.showToast("Session Expired");
        Get.offAllNamed(Routes.signIn);
        return SizedBox.shrink();
      }

      final shouldShowGlow = controller.showAddMoneyGlow.value;
      
      return AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 18, 0),
          child: Row(
            children: [
              // Back Button
              Visibility(
                visible: controller.showBackButton.value,
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: _buildBackButton(),
                ),
              ),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Profile Section or Title
                    Obx(
                      () {
                        if (controller.showProfile.value) {
                          return KidAvatarContainer(
                            kidName: kid.name,
                            avatarUrl: kid.avatar,
                          );
                        } else if (controller.showTitle.value) {
                          return _buildTitle();
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    // Search Bar
                    Visibility(
                      visible: controller.showSearch.value,
                      child: Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 60.w,
                          ),
                          child: KidSearchTextField(

                            hintText: "e.g Electric bike",
                            suffixIconColor: AppColors.iconPrimaryVariant,
                            suffixSvgPath: Assets.icSearch,
                            onChanged: onSearchChanged,
                          ),
                        ),
                      ),
                    ),

                    // Cards Section
                    Row(
                      children: [
                        controller.shouldShowRequestMoneySpotlight()
                            ? Showcase(
                                key: GlobalKeys.totalMoneyCardKey,
                                description: "Tap here to request money from your parent!",
                                descriptionAlignment: Alignment.center,
                                descriptionTextAlign: TextAlign.center,
                                tooltipBackgroundColor: AppColors.colorPrimary,
                                descTextStyle: AppTextStyle.headingSmall.copyWith(color: Colors.white),
                                targetPadding: EdgeInsets.all(6.h),
                                tooltipPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 0),
                                child: MoneyWidget(
                                  amount: kid.wallet.spendingJar.balance + kid.wallet.savingJar.balance,
                                  rightIconPath: Assets.icCoinEuro,
                                  showAddButton: true,
                                  iconSize: 32.w,
                                  onAddTap: onAddMoneyTap,
                                  onCardTap: onAddMoneyTap,
                                  showGlowAnimation: shouldShowGlow,
                                ),
                              )
                            : MoneyWidget(
                                amount: kid.wallet.spendingJar.balance + kid.wallet.savingJar.balance,
                                rightIconPath: Assets.icCoinEuro,
                                showAddButton: true,
                                iconSize: 32.w,
                                onAddTap: onAddMoneyTap,
                                onCardTap: onAddMoneyTap,
                                showGlowAnimation: shouldShowGlow,
                              ),
                      ],
                    ),
                  ],
                ),
              ),

              if (actionWidgets != null) ...actionWidgets!,
            ],
          ),
        ),
      );
    });
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}
