import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/models/goal_model.dart';
import 'package:coin_kids/data/models/market_product_model.dart';
import 'package:coin_kids/data/models/notification_metadata.dart';
import 'package:coin_kids/data/models/notification_model.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/goal_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/data/remote_services/market_service.dart';
import 'package:coin_kids/data/remote_services/notification_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/dialogs/parent/app_parent_dialog.dart';
import 'package:coin_kids/presentation/screens/parent/market/parent_product_detail_screen.dart';
import 'package:flutter/material.dart' show Colors, showDialog;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class KidProfileController extends GetxController {
  final appState = Get.find<AppStateController>();
  final goalsService = Get.find<GoalService>();
  final marketService = Get.find<MarketService>();
  final Rx<KidProfileTabs> currentType = KidProfileTabs.jars.obs;

  final NotificationService _notificationService =
      Get.find<NotificationService>();
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

      final fetchedGoals =
          await goalsService.fetchUserGoals(appState.currentKid.value!.kidId);

      // Sort goals based on priority:
      // 1. In-progress goals first
      // 2. Within in-progress, modified goals (with saved amount) first
      // 3. Then other goals (completed, approved, rejected)
      fetchedGoals.sort((a, b) {
        // First priority: In-progress goals come first
        if (a.status == GoalStatus.inProgress &&
            b.status != GoalStatus.inProgress) {
          return -1;
        }
        if (a.status != GoalStatus.inProgress &&
            b.status == GoalStatus.inProgress) {
          return 1;
        }

        // Second priority: For in-progress goals, sort by modification
        if (a.status == GoalStatus.inProgress &&
            b.status == GoalStatus.inProgress) {
          if (a.savedAmount > 0 && b.savedAmount == 0) return -1;
          if (a.savedAmount == 0 && b.savedAmount > 0) return 1;
          return b.createdAt.compareTo(a.createdAt); // Then by creation date
        }

        // Third priority: For non-in-progress goals, sort by completion date
        if (a.status != GoalStatus.inProgress &&
            b.status != GoalStatus.inProgress) {
          final aDate = a.completedAt ?? a.createdAt;
          final bDate = b.completedAt ?? b.createdAt;
          return bDate.compareTo(aDate); // Most recent first
        }

        return 0;
      });

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
      final kidName = appState.currentKid.value?.name ?? "child";
      final result = await Get.dialog<bool>(
        AppParentDialog(
          iconPath: Assets.icCoinEuro,
          title: "Confirm Rejection",
          subtitle:
              "${goal.targetAmount.toMoneyFormat()} will be refunded to $kidName's wallet",
          buttons: [
            DialogButton(
              text: "Cancel",
              onPressed: () => Get.back(result: false),
              backgroundColor: AppColors.btnColorOrange,
              textColor: Colors.white,
            ),
            DialogButton(
              text: "Decline",
              onPressed: () => Get.back(result: true),
              backgroundColor: AppColors.critical,
              textColor: Colors.white,
            ),
          ],
        ),
      );

      if (result == true) {
        // Get the current kid
        final kid = appState.currentKid.value;
        if (kid == null) {
          ToastUtil.showToast('Session Expired. Login Again');
          Get.offAllNamed(Routes.signIn);
          return;
        }

        // Get the kid service
        final kidService = Get.find<KidService>();

        // Calculate new spending jar balance by adding the goal's saved amount
        final newSpendingBalance =
            kid.wallet.spendingJar.balance + goal.savedAmount;

        // Update spending jar balance to refund the amount
        await kidService.updateSpendingJar(kid.kidId, newSpendingBalance);

        // Update goal status
        await goalsService.cancelGoal(goal);

        // Update local state
        goals[goals.indexWhere((g) => g.id == goal.id)] =
            goal.copyWith(status: GoalStatus.rejected);
        goals.refresh();

        // Create notification for the kid
        final notification = NotificationModel(
          userId: goal.userId, // Send to kid
          senderId: Get.find<AuthService>().user.value?.uid ?? '',
          title: "Goal Rejected",
          type: NotificationType.goalRejected,
          isRead: false,
          timestamp: DateTime.now(),
          metadata: GoalRejectedMetadata(
            goalId: goal.id!,
            goalName: goal.title,
            targetAmount: goal.targetAmount,
            name: appState.currentParent.value?.name ?? '',
            photo: appState.currentParent.value?.imageUrl ?? '',
          ),
        );

        await _notificationService.createNotification(notification);
        ToastUtil.showToast('Goal rejected and amount refunded successfully');
      }
    } catch (e) {
      ToastUtil.showToast('Failed to reject goal');
      Get.log('Error rejecting goal: $e', isError: true);
    }
  }

  Future<void> handleApproveGoal(GoalModel goal) async {
    try {
      // Get current kid's name
      final kidName = appState.currentKid.value?.name ?? "child";

      final result = await Get.dialog<bool>(
        AppParentDialog(
          iconPath: Assets.icCoinEuro,
          title: "Confirm Approval",
          subtitle:
              "${goal.targetAmount.toMoneyFormat()} will be deducted from $kidName's wallet",

          buttons: [
            DialogButton(
              text: "Cancel",
              onPressed: () => Get.back(result: false),
              backgroundColor: AppColors.btnColorOrange,
              textColor: Colors.white,
            ),
            DialogButton(
              text: "Approve",
              onPressed: () => Get.back(result: true),
              backgroundColor: AppColors.btnColorGreen,
              textColor: Colors.white,
            ),
          ],
        ),
      );

      if (result == true) {
        await _approveGoal(goal);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to show approval dialog: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _approveGoal(GoalModel goal) async {
    try {
      await goalsService.approveGoal(goal);
      goals[goals.indexWhere((g) => g.id == goal.id)] =
          goal.copyWith(status: GoalStatus.approved);
      goals.refresh();

      // Create notification for the kid
      final notification = NotificationModel(
        userId: goal.userId, // Send to kid
        senderId: Get.find<AuthService>().user.value?.uid ?? '',
        title: "Goal Approved!",
        type: NotificationType.goalApproved,
        isRead: false,
        timestamp: DateTime.now(),
        metadata: GoalApprovedMetadata(
          goalId: goal.id!,
          goalName: goal.title,
          targetAmount: goal.targetAmount,
          name: appState.currentParent.value?.name ?? '',
          photo: appState.currentParent.value?.imageUrl ?? '',
        ),
      );

      await _notificationService.createNotification(notification);

      // Fetch the actual product details instead of creating a dummy one
      if (goal.productUrl != null) {
        final product = await marketService.fetchProductByUrl(goal.productUrl!);
        if (product != null) {
          // Navigate to product detail screen with the actual product data
          Get.toNamed(Routes.parentProductDetails, arguments: product);
        } else {
          Get.snackbar(
            'Error',
            'Product details not found',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }

      ToastUtil.showToast('Goal approved successfully');
    } catch (e) {
      ToastUtil.showToast('Failed to approve goal');
      Get.log('Error approving goal: $e', isError: true);
    }
  }

  Future<void> navigateToProductDetails(GoalModel goal) async {
    if (goal.productUrl != null) {
      try {
        final product = await marketService.fetchProductByUrl(goal.productUrl!);
        if (product != null) {
          Get.toNamed(Routes.parentProductDetails, arguments: product);
        } else {
          Get.snackbar(
            'Error',
            'Product not found',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to load product details',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
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
