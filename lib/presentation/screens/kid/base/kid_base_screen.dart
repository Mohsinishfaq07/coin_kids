import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/widgets/orientation_transition.dart';
import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart' show IconPosition, KidButton;
import 'package:coin_kids/presentation/components/kid/overlay/goals_nav_tutorial_overlay.dart';
import 'package:coin_kids/presentation/components/kid/kid_exit_dialog.dart';
import 'package:coin_kids/presentation/components/kid/kid_appbar_component.dart';
import 'package:coin_kids/presentation/components/kid/vertical_navigation_bar.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_base_controller.dart';
import 'package:coin_kids/presentation/dialogs/kid/kid_dialog.dart';
import 'package:coin_kids/presentation/screens/kid/goals/kid_goals_screen.dart';
import 'package:coin_kids/presentation/screens/kid/home/kid_home_screen.dart';
import 'package:coin_kids/presentation/screens/kid/market/kid_market_screen.dart';
import 'package:coin_kids/core/constants/global_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class KidBaseScreen extends GetView<KidBaseController> {
  const KidBaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.log("UI_TAG Kid Base");

    bool args;
    try {
      args = Get.arguments as bool;
    } catch (e) {
      args = false;
    }

    return OrientationBuilder(
      builder: (context, orientation) {
        return OrientationTransition(
          toPortrait: false,
          showInstruction: args == true,
          child: orientation == Orientation.portrait
              ? _buildEmptyPortraitUI(context)
              : _buildKidUI(context),
        );
      },
    );
  }

  Widget _buildKidUI(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.appBarController.configureForHome();
    });
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          bool shouldExit = await KidExitDialog.show(context);
          if (shouldExit) Get.back();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Obx(() {
              final kid = controller.currentKid.value;
              if (kid == null) {
                return const Center(child: Text("No kid data found"));
              }

              return Container(
                decoration: BoxDecoration(
                  gradient: AppColors.background,
                  image: const DecorationImage(
                    image: AssetImage(Assets.kidBg),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    KidAppBarComponent(
                      onSearchChanged: (query) =>
                          controller.appBarController.updateSearchQuery(query),
                      // onAddMoneyTap: () {
                      //   final kid = controller.appState.currentKid.value;
                      //   if (kid == null) return;
                      //
                      //   // Check if spending jar exists
                      //   if (kid.wallet.spendingJar.color == 0) {
                      //     showCreateJarDialog();                          return;
                      //   }
                      //
                      //   final isConnected = kid.isConnected;
                      //   Get.toNamed(
                      //     Routes.kidMoneyAddOrRequest,
                      //     arguments: isConnected
                      //         ? AmountAdditionMode.requestMoney
                      //         : AmountAdditionMode.requestMoney
                      //         // : AmountAdditionMode.addMoney,
                      //   );
                      // },
                      onAddMoneyTap: ()async {
                        final isConnected =
                            controller.appState.currentKid.value!.isConnected;
                        Get.toNamed(
                            Routes.kidMoneyAddOrRequest,
                            arguments: isConnected
                                ? AmountAdditionMode.requestMoney
                                : AmountAdditionMode.requestMoney
                          // : AmountAdditionMode.addMoney,

                        );
                        await controller.analytics.logEvent(AnalyticsEventNames.kidClickRequestMoney, {
                          AnalyticsParameterNames.roleChild: AnalyticsScreenNames.kidHomeScreen,
                        });
                      },
                    ),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: Row(
                        children: [
                          // Navigation Rail
                          Container(
                            key: GlobalKeys.goalsNavKey,
                            child: VerticalNavBar(),
                          ),

                          // Content Area
                          Expanded(
                            child: _buildMainContent(kid),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            // Goals Tutorial Overlay
            Obx(() {
              final kid = controller.currentKid.value;
              if (kid == null) return const SizedBox.shrink();

              if (!controller.showGoalsTutorial.value) {
                return const SizedBox.shrink();
              }

              // Check if spending jar exists and has a color
              final spendingJarColor = kid.wallet.spendingJar.color;
              if (spendingJarColor == 0) {
                Get.log(
                    "Spending jar not created yet, keeping tutorial hidden");
                return const SizedBox.shrink();
              }

              // Check if kid already has goals (coinKidsBalance > 0)
              if (kid.coinKidsBalance > 0) {
                Get.log("Kid already has goals, keeping tutorial hidden");
                return const SizedBox.shrink();
              }

              Get.log("Showing goals tutorial overlay");
              return GoalsNavTutorialOverlay(
                targetKey: GlobalKeys.goalsNavKey,
                onComplete: () => controller.completeGoalsTutorial(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(KidModel kid) {
    return Obx(() {
      switch (controller.navigationController.selectedIndex.value) {
        case 0:
          return KidHomeScreen();
        case 1:
          return KidGoalsScreen(currentKidId: kid.kidId);
        case 2:
          return KidMarketScreen();
        default:
          return KidHomeScreen();
      }
    });
  }

  Widget _buildEmptyPortraitUI(BuildContext context) {
    return PopScope(
      canPop: false, // Block default back behavior
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          bool shouldExit = await KidExitDialog.show(context);
          if (shouldExit) Get.back();
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: AppColors.background,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.icRotateLandscape,
                  width: 100.w,
                  height: 100.w,
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Please rotate your device to landscape mode',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showCreateJarDialog() {
    KidDialog.show(
      dismissible: true,
      emoji: Assets.emojiSad,
      title: "Create Jar First",
      subtitle: "Please create a Spending Jar before requesting money",
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
}
