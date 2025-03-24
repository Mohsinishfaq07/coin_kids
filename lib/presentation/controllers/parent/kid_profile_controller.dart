import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/models/goal_model.dart';
import 'package:coin_kids/data/models/notification_model.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/goal_service.dart';
import 'package:coin_kids/data/remote_services/notification_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/dialogs/parent/app_parent_dialog.dart';
import 'package:flutter/material.dart' show Colors, showDialog;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class KidProfileController extends GetxController {
  final appState = Get.find<AppStateController>();
  final goalsService = Get.find<GoalService>();
  final Rx<KidProfileTabs> currentType = KidProfileTabs.jars.obs;

  final NotificationService _notificationService = Get.find<NotificationService>();
  final notifications = <NotificationModel>[].obs;
  final isNotificationLoading = true.obs;
  final isGoalsLoading = true.obs;

  final RxList<GoalModel> goals = RxList();

  @override
  void onInit() {
    fetchNotifications();
    fetchGoals();

    final args = Get.arguments;
    if (args != null) {
      currentType.value = Get.arguments as KidProfileTabs;
    }

    super.onInit();
  }

  void fetchGoals() async {
    try {
      final kid = appState.currentKid.value;
      if (kid == null) {
        ToastUtil.showToast("Session Expired. Login Again");
        Get.offAllNamed(Routes.signIn);
        return;
      }

      final fetchedGoals = await goalsService.fetchUserGoals(appState.currentKid.value!.kidId);
      goals.clear();
      goals.assignAll(fetchedGoals);
    } catch (e) {
      Get.log('Error fetching goals: $e');
      ToastUtil.showToast('Failed to fetch goals');
    } finally {
      isGoalsLoading.value = false;
    }
  }

  Future<void> fetchNotifications() async {
    try {
      final userId = Get.find<AuthService>().user.value?.uid;
      if (userId == null) return;

      final result = await _notificationService.getNotificationsPaginated(
        userId,
        lastDocument: null,
      );

      if (result.notifications.isEmpty) {
      } else {
        notifications.clear();
        notifications.addAll(result.notifications);
      }
    } catch (e) {
      Get.log('Error fetching notifications: $e');
      ToastUtil.showToast('Failed to load notifications');
    } finally {
      isNotificationLoading.value = false;
    }
  }

  Future<void> handleRejectGoal(GoalModel goal) async {
    try {
      await goalsService.cancelGoal(goal);
      // Update local state
      goals.remove(goal);
      Get.snackbar(
        'Success',
        'Goal rejected and money transferred to spending wallet',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reject goal: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> handleBuyGoal(GoalModel goal) async {
    final result = await showDialog<bool>(
      context: Get.context!,
      builder: (context) => AppParentDialog(
        iconPath: Assets.icCoinEuro,
        title: "Confirm Purchase",
        subtitle: "This will deduct ${goal.targetAmount.toMoneyFormat()} from your kid's spending wallet. Do you want to proceed?",
        buttons: [
          DialogButton(
            text: "Cancel",
            onPressed: () => Get.back(result: false),
            backgroundColor: AppColors.btnColorOrange,
            textColor: Colors.white,
          ),
          DialogButton(
            text: "Proceed",
            onPressed: () => Get.back(result: true),
            backgroundColor: AppColors.btnColorGreen,
            textColor: Colors.white,
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        final goalService = Get.find<GoalService>();
        await goalService.updateGoalProgressWithRewards(goal.id!, goal.targetAmount);

        // Update local state
        goals.remove(goal);

        // Navigate to market or open product link
        if (goal.productUrl != null) {
          // If goal was added from market, open product link
          if (await canLaunchUrl(Uri.parse(goal.productUrl!))) {
            await launchUrl(Uri.parse(goal.productUrl!));
          }
        } else {
          // If goal was custom, search on Amazon
          final searchQuery = Uri.encodeComponent(goal.title);
          final amazonUrl = "https://www.amazon.com/s?k=$searchQuery";
          if (await canLaunchUrl(Uri.parse(amazonUrl))) {
            await launchUrl(Uri.parse(amazonUrl));
          }
        }

        Get.snackbar(
          'Success',
          'Goal completed and money deducted from spending wallet',
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to complete goal: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  void refresh() {
    fetchGoals();
    fetchNotifications();
  }
}
