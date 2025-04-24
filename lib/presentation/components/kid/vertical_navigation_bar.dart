import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_appbar_controller.dart';
import 'package:coin_kids/presentation/components/common/hand_pointer_overlay.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/core/constants/global_keys.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_goals_controller.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class VerticalNavBarController extends GetxController {
  final KidAppBarController appBarController;
  final KidGoalsController goalsController = Get.find<KidGoalsController>();
  final AppStateController appStateController = Get.find<AppStateController>();

  VerticalNavBarController(this.appBarController);

  final RxInt selectedIndex = 0.obs;
  final RxBool showGoalsTutorial = false.obs;
  bool _isInitialized = false;

  @override
  void onInit() {
    super.onInit();
    _initTutorialState();
  }

  void _initializeGoalsIfNeeded() {
    if (!_isInitialized) {
      final currentKid = appStateController.currentKid.value;
      if (currentKid != null) {
        goalsController.startListeningToGoals(currentKid.kidId);
        _isInitialized = true;
      }
    }
  }

  Future<void> _initTutorialState() async {
    final hasSeenGoalsTutorial = SharedPreferencesHelper.getBool(SharedPreferencesHelper.hasSeenGoalsTutorial) ?? false;
    showGoalsTutorial.value = !hasSeenGoalsTutorial;
  }

  Future<void> completeGoalsTutorial() async {
    showGoalsTutorial.value = false;
    await SharedPreferencesHelper.saveBool(SharedPreferencesHelper.hasSeenGoalsTutorial, true);
  }

  void onTabSelected(int index) {
    selectedIndex.value = index;
    if (index == 1) {
      _initializeGoalsIfNeeded();
      completeGoalsTutorial();
      appBarController.resetToDefault();
    } else if (index == 2) {
      appBarController.configureForMarket();
    } else {
      appBarController.resetToDefault();
    }
  }
}

class VerticalNavBar extends GetView<VerticalNavBarController> {
  const VerticalNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF3FCFF),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: NavigationRail(
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: controller.onTabSelected,
            minWidth: 80.w,
            backgroundColor: Colors.transparent,
            labelType: NavigationRailLabelType.all,
            useIndicator: false,
            groupAlignment: 0,
            destinations: [
              _buildDestination(
                Assets.icKidHome,
                'HOME',
                controller.selectedIndex.value == 0,
              ),
              _buildDestination(
                Assets.icKidGoal,
                'GOALS',
                controller.selectedIndex.value == 1,
                isGoals: true,
              ),
              _buildDestination(
                Assets.icKidMarket,
                'SHOP',
                controller.selectedIndex.value == 2,
              ),
            ],
          ),
        ),
      );
    });
  }

  NavigationRailDestination _buildDestination(String iconPath,
      String label,
      bool isSelected, {
        bool isGoals = false,
      }) {
    Widget icon = SvgPicture.asset(iconPath);
    Widget labelWidget = Text(
      label,
      key: isGoals ? GlobalKeys.goalsLabelKey : null,
      style: AppTextStyle.labelSmall.copyWith(
        fontWeight: MyFontWeight.extraBold.fontWeight,
        color: isSelected ? AppColors.colorPrimary : AppColors.iconDisabled,
      ),
    );

    return NavigationRailDestination(
      icon: icon,
      label: labelWidget,
    );
  }
}
