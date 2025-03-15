import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/widgets/orientation_transition.dart';
import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_appbar_component.dart';
import 'package:coin_kids/presentation/components/kid/vertical_navigation_bar.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_base_controller.dart';
import 'package:coin_kids/presentation/screens/kid/goals/kid_goals_screen.dart';
import 'package:coin_kids/presentation/screens/kid/home/kid_home_screen.dart';
import 'package:coin_kids/presentation/screens/kid/market/kids_market_screen.dart';
import 'package:coin_kids/presentation/screens/parent/parent_base/parent_base_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KidBaseScreen extends GetView<KidBaseController> {
  const KidBaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllNotifications();
    });

    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return _buildKidUI(context);
        }
        return OrientationTransition(
          toPortrait: false,
          showInstruction: Get.arguments ?? false == true,
          child: Center(
            child: Text(
              "Please rotate your device to landscape mode",
              style: TextStyle(color: Colors.red),
            ),
          ),
        );
      },
    );
  }

  Widget _buildKidUI(BuildContext context) {
    return PopScope(
      canPop: false, // Block default back behavior
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          bool shouldExit = await showExitConfirmation(context);
          if (shouldExit) Get.back();
        }
      },
      child: Scaffold(
        body: Obx(() {
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
                // Usage in UI
                KidAppBarComponent(
                  onAddMoneyTap: () {
                    final isConnected = controller.appState.currentKid.value!.isConnected;
                    //Set According to Arguments
                    Get.toNamed(
                      Routes.kidMoneyAddOrRequest,
                      arguments: isConnected ? AmountAdditionMode.requestMoney : AmountAdditionMode.addMoney,
                    );
                  },
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Row(
                    children: [
                      // Navigation Rail
                      VerticalNavBar(),

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
      ),
    );
  }

  Widget _buildMainContent(KidModel kid) {
    return Obx(() {
      switch (controller.navigationController.selectedIndex.value) {
        case 0:
          return KidHomeScreen();
        case 1:
          // return KidHomeScreen();
          return KidGoalsScreen(currentKidId: kid.kidId);
        case 2:
          return KidsMarketScreen();
        default:
          return const SizedBox.shrink();
      }
    });
  }
}
