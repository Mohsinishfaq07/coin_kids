import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_appbar_controller.dart';
import 'package:coin_kids/presentation/components/kid/overlay/hand_pointer_overlay.dart';
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
  final  analytics = Get.find<AnalyticsService>();

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

  Future<void> onTabSelected(int index) async {
    selectedIndex.value = index;
    await analytics.logEvent(AnalyticsEventNames.kidClickHomeButton, {
      AnalyticsParameterNames.roleParent: AnalyticsScreenNames.kidHomeScreen,
    });
    if (index == 1) {
      _initializeGoalsIfNeeded();
      completeGoalsTutorial();
      await analytics.buttonClicked(AnalyticsEventNames.kidGoalsNavigationClicked,AnalyticsScreenNames.kidBaseScreen);
      await analytics.logEvent(AnalyticsEventNames.kidClickGoalButton, {
        AnalyticsParameterNames.roleParent: AnalyticsScreenNames.kidHomeScreen,
      });
      appBarController.configureForHome();
    } else if (index == 2) {
      appBarController.configureForMarket();
      await analytics.buttonClicked(AnalyticsEventNames.kidMarketNavigationClicked,AnalyticsScreenNames.kidBaseScreen);
      await analytics.logEvent(AnalyticsEventNames.kidClickShopButton, {
        AnalyticsParameterNames.roleParent: AnalyticsScreenNames.kidHomeScreen,
      });

    } else {
      appBarController.configureForHome();
      await analytics.buttonClicked(AnalyticsEventNames.kidHomeNavigationClicked,AnalyticsScreenNames.kidBaseScreen);

    }
  }
}
