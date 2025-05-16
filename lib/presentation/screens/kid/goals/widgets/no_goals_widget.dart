import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/constants/global_keys.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/components/kid/overlay/goals_add_tutorial_overlay.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/dialogs/kid/kid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NoGoalsWidget extends StatelessWidget {
  NoGoalsWidget({super.key}) {
    _checkTutorialState();
  }

  final RxBool showPointer = true.obs;
  final AppStateController _appState = Get.find<AppStateController>();

  Future<void> _checkTutorialState() async {
    final hasSeenTutorial = SharedPreferencesHelper.getBool(SharedPreferencesHelper.hasSeenNoGoalsTutorial) ?? false;
    showPointer.value = !hasSeenTutorial;
  }

  Future<void> _dismissHandAnimation() async {
    showPointer.value = false;
    await SharedPreferencesHelper.saveBool(
      SharedPreferencesHelper.hasSeenNoGoalsTutorial,
      true,
    );
  }

  void _showCreateJarDialog() {
    KidDialog.show(
      dismissible: true,
      emoji: Assets.emojiSad,
      title: "Create Jar First",
      subtitle: "You need to create a spending jar before adding goals",
      buttons: [
        KidButton(
          text: "OK",
          onTap: () {
            Get.back();
          },
          baseColor: AppColors.btnColorGreen,
          iconPath: Assets.icCross,
          iconPosition: IconPosition.left,
        ),

      ],
    );
  }
  final analytics = Get.find<AnalyticsService>();

  Future<void> _handleAddGoal() async {
    final kid = _appState.currentKid.value;
    if (kid == null) {
      ToastUtil.showToast('Session expired');
      return;
    }

    final spendingJarColor = kid.wallet.spendingJar.color;
    if (spendingJarColor == 0) {
      _showCreateJarDialog();
      return;
    }

    _dismissHandAnimation();
    await analytics.buttonClicked(AnalyticsEventNames.noGoalClicked,AnalyticsScreenNames.kidNoGoalScreen,AnalyticsScreenNames.kidGoalsNameScreen);

    // Get.toNamed(Routes.kidAddGoalName);
// Get.toNamed(Routes.kidGoalSummary);
    Get.toNamed(Routes.kidGoalSummary, arguments: true);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create a saving goal! 🎯',
                  style: AppTextStyle.headingLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 18.h),
                KidButton(
                  key: GlobalKeys.noGoalKey,
                  baseColor: AppColors.btnColorOrange,
                  text: 'Add New Goal',
                  iconPath: Assets.icAdd,
                  iconPosition: IconPosition.left,
                  onTap: _handleAddGoal,
                ),
              ],
            ),
          ),
          
          // Tutorial Overlay
          Obx(() {
            if (showPointer.value) {
              return GoalsAddTutorialOverlay(
                targetKey: GlobalKeys.noGoalKey,
                onComplete: _dismissHandAnimation,
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
