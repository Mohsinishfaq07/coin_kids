import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/utils/orientation_utils.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/data/models/notification_model.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/data/remote_services/notification_service.dart';
import 'package:coin_kids/presentation/components/kid/kid_notification_dialog.dart';
import 'package:coin_kids/presentation/components/kid/vertical_navigation_bar.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/controllers/common/role_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/jar_creation_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_appbar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KidBaseController extends GetxController {
  // Dependencies
  final AppStateController _appStateController = Get.find<AppStateController>();
  final RoleController _roleController = Get.find<RoleController>();
  final VerticalNavBarController navigationController = Get.find<VerticalNavBarController>();
  final NotificationService _notificationService = NotificationService();

  final AppStateController appState = Get.find<AppStateController>();
  final KidAppBarController appBarController = Get.find<KidAppBarController>();

  // Observables
  final Rx<KidModel?> currentKid = Rx<KidModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<NotificationModel> unreadNotifications = <NotificationModel>[].obs;
  final RxBool isProcessingNotifications = false.obs;
  final RxInt unreadNotificationCount = 0.obs;

  var showJarShowcase = true.obs;

  @override
  void onInit() {
    super.onInit();
    OrientationUtils.lockToLandscape();
    _initializeKid();
  }

  @override
  void onReady() {
    super.onReady();
    fetchAllNotifications();
  }

  void _initializeKid() {
    currentKid.value = _appStateController.currentKid.value;
    ever(_appStateController.currentKid, (KidModel? kid) {
      currentKid.value = kid;
      if (kid != null) {
        fetchAllNotifications();
      }
    });
  }

  Future<void> fetchAllNotifications() async {
    if (currentKid.value == null) return;

    try {
      isProcessingNotifications.value = true;

      // Get all notifications for the current kid using the stream
      final notifications = await _notificationService.getAllUnreadNotifications(currentKid.value!.kidId);

      // Filter to only unread notifications and sort by timestamp (newest first)
      unreadNotifications.value = notifications;

      unreadNotificationCount.value = unreadNotifications.length;

      Get.log("Fetched ${unreadNotifications.length} unread notifications");

      // Show notifications if there are any
      bool shouldShowNotification = SharedPreferencesHelper.getBool(SharedPreferencesHelper.showKidsNotifications) ?? true;
      if (unreadNotifications.isNotEmpty && shouldShowNotification) {
        SharedPreferencesHelper.saveBool(SharedPreferencesHelper.showKidsNotifications, false);
        showNotificationsDialog();
      }
    } catch (e) {
      Get.log("Error fetching notifications: $e");
    } finally {
      isProcessingNotifications.value = false;
    }
  }

  bool shouldShowJarSpotLight() {
    final jarCreated = appState.currentKid.value!.wallet.spendingJar.color != 0;
    final isParentOpened = appState.currentKid.value!.isConnected;
    final hasShownEarlier = SharedPreferencesHelper.getBool(SharedPreferencesHelper.showcaseMoneyJarKey) ?? false;
    final hasBalance = appState.currentKid.value!.wallet.spendingJar.balance != 0;

    Get.log('$jarCreated, $isParentOpened, $hasShownEarlier, $hasBalance');

    if (showJarShowcase.value == false) return false;
    //Jar Exists - Return
    if (jarCreated) return false;

    //Jar Not Exist, But Spotlight already show - Return
    if (hasShownEarlier) return false;
    //ar Not Exist, Spotlight Not Shown, has Parent and Balance
    if (isParentOpened && !hasBalance) return false;

    return true;
  }

  void showNotificationsDialog() {
    if (unreadNotifications.isEmpty) return;

    if (appBarController.shouldShowRequestMoneySpotlight()) return;

    if (shouldShowJarSpotLight()) return;

    final BuildContext context = Get.context!;

    // Use a transparent barrier
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      barrierDismissible: false,
      barrierLabel: "Notifications",
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return SafeArea(
          child: Material(
            type: MaterialType.transparency,
            child: Center(
              child: KidNotificationDialog(
                notifications: unreadNotifications,
                onDismissSingle: (notification) {
                  // Mark single notification as read
                  _notificationService.markAsRead(notification.id!);
                  SharedPreferencesHelper.saveBool(SharedPreferencesHelper.showKidsNotifications, true);
                },
                onDismissAll: () {
                  // Mark all as read and close dialog
                  if (currentKid.value != null) {
                    _notificationService.markAllAsRead(currentKid.value!.kidId);
                    unreadNotifications.clear();
                    unreadNotificationCount.value = 0;
                    Navigator.of(context).pop();
                  }

                  SharedPreferencesHelper.saveBool(SharedPreferencesHelper.showKidsNotifications, true);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void markNotificationAsRead(String notificationId) {
    _notificationService.markAsRead(notificationId);
    unreadNotifications.removeWhere((notification) => notification.id == notificationId);
    unreadNotificationCount.value = unreadNotifications.length;
  }

  void markAllNotificationsAsRead() {
    if (currentKid.value != null) {
      _notificationService.markAllAsRead(currentKid.value!.kidId);
      unreadNotifications.clear();
      unreadNotificationCount.value = 0;
    }
  }

  void switchToParentMode() {
    final isKidConnected = currentKid.value?.isConnected ?? false;
    if (!isKidConnected) {
      final kidService = Get.find<KidService>();
      kidService.updateKid(
        currentKid.value!.kidId,
        currentKid.value!.copyWith(isConnected: true),
      );
    }

    _roleController.switchToParentMode(true);
  }

  void startJarCreation(Jars jarType) {
    final JarCreationController jarCreationController = Get.find<JarCreationController>();
    jarCreationController.jarType = jarType;
  }

  @override
  void onClose() {
    SharedPreferencesHelper.saveBool(SharedPreferencesHelper.showKidsNotifications, true);
    super.onClose();
  }
}
