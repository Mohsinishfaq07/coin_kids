import 'dart:async';
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
import 'package:showcaseview/showcaseview.dart';

class KidBaseController extends GetxController {
  // Dependencies
  final RoleController _roleController = Get.find<RoleController>();
  final VerticalNavBarController navigationController =
      Get.find<VerticalNavBarController>();
  final NotificationService _notificationService = NotificationService();

  final AppStateController appState = Get.find<AppStateController>();
  final KidAppBarController appBarController = Get.find<KidAppBarController>();

  RxBool isNotificationShowing = true.obs;

  // Observables
  final Rx<KidModel?> currentKid = Rx<KidModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<NotificationModel> unreadNotifications =
      <NotificationModel>[].obs;
  final RxBool isProcessingNotifications = false.obs;
  final RxInt unreadNotificationCount = 0.obs;

//observable variable
  var showJarShowcase = true.obs;
  var hasInitializedShowcase = false.obs;

  @override
  void onInit() {
    super.onInit();
    OrientationUtils.lockToLandscape();
    _initializeKid();
  }

  Future<void> _initializeKid() async {
    currentKid.value = appState.currentKid.value;
    // Setup listener initially if kid exists
    if (currentKid.value != null) {
      await fetchAllNotifications();
    }

    ever(appState.currentKid, (KidModel? kid) async {
      currentKid.value = kid;
      if (kid != null) {
        await fetchAllNotifications();
      }
    });
  }

  Future<void> fetchAllNotifications() async {
    if (currentKid.value == null) return;

    try {
      isProcessingNotifications.value = true;

      // Get all notifications for the current kid using the stream
      final notifications = await _notificationService
          .getAllUnreadNotifications(currentKid.value!.kidId);

      // Filter to only unread notifications and sort by timestamp (newest first)
      unreadNotifications.value = notifications;

      unreadNotificationCount.value = unreadNotifications.length;

      Get.log("Fetched ${unreadNotifications.length} unread notifications");

      // Show notifications if there are any
      bool shouldShowNotification = SharedPreferencesHelper.getBool(
              SharedPreferencesHelper.showKidsNotifications) ??
          true;
      if (unreadNotifications.isNotEmpty && shouldShowNotification) {
        SharedPreferencesHelper.saveBool(
            SharedPreferencesHelper.showKidsNotifications, false);
        showNotificationsDialog();
      } else {
        isNotificationShowing.value = false;
        if (shouldShowJarSpotLight()) {
          startShowcase(Get.context!);
        }
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
    final hasShownEarlier = SharedPreferencesHelper.getBool(
            SharedPreferencesHelper.showcaseMoneyJarKey) ??
        false;
    final hasBalance =
        appState.currentKid.value!.wallet.spendingJar.balance != 0;

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

  final GlobalKey moneyJarShowcaseKey = GlobalKey();

  void startShowcase(BuildContext context) async {
    if (shouldShowJarSpotLight() && !isNotificationShowing.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          ShowCaseWidget.of(context).startShowCase([moneyJarShowcaseKey]);
          showJarShowcase.value = false;
          markMoneyJarShowcaseAsShown();
        } catch (e) {
          Get.log("Error starting showcase: $e");
          // Reset initialization state on error
          hasInitializedShowcase.value = false;
        }
      });
    }
  }

  void resetShowcaseState() {
    hasInitializedShowcase.value = false;
  }

  Future<void> markMoneyJarShowcaseAsShown() async {
    await SharedPreferencesHelper.saveBool(
        SharedPreferencesHelper.showcaseMoneyJarKey, true);
  }

  void showNotificationsDialog() {
    if (unreadNotifications.isEmpty) return;

    // Only show notifications in kid mode
    final currentRole = SharedPreferencesHelper.getString(
        SharedPreferencesHelper.lastLoggedInRole);
    if (currentRole != UserRole.child.name) return;

    // Prevent showing dialog if it's already open
    if (Get.isDialogOpen!) return;

    // Add a safety check here to ensure we have notifications and they are valid
    if (unreadNotifications.isEmpty || unreadNotifications.first == null) {
      Get.log("No valid notifications to show");
      return;
    }

    // Create a local copy of notifications to prevent concurrent modification
    final List<NotificationModel> currentNotifications =
        List.from(unreadNotifications);
    if (currentNotifications.isEmpty) {
      Get.log("Notifications list became empty");
      return;
    }

    final BuildContext context = Get.context!;

    isNotificationShowing.value = true;

    // Show the notifications dialog first
    showGeneralDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      barrierLabel: "Notifications",
      transitionDuration: Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return WillPopScope(
          onWillPop: () async {
            isNotificationShowing.value = false;
            // Handle back button press
            if (unreadNotifications.isNotEmpty) {
              markAllNotificationsAsRead();
            }
            if (shouldShowJarSpotLight()) {
              startShowcase(Get.context!);
            }
            return true;
          },
          child: SafeArea(
            child: Material(
              type: MaterialType.transparency,
              child: Center(
                child: KidNotificationDialog(
                  notifications: currentNotifications,
                  onDismissSingle: (notification) {
                    // Mark single notification as read
                    _notificationService.markAsRead(notification.id!);
                    unreadNotifications
                        .removeWhere((n) => n.id == notification.id);
                    unreadNotificationCount.value = unreadNotifications.length;

                    if (unreadNotifications.isEmpty) {
                      SharedPreferencesHelper.saveBool(
                          SharedPreferencesHelper.showKidsNotifications, true);
                      Get.back(); // Use Get.back() instead of Navigator.pop
                      isNotificationShowing.value = false;
                      if (shouldShowJarSpotLight()) {
                        startShowcase(Get.context!);
                      }
                    }
                  },
                  onDismissAll: () {
                    // Mark all as read and close dialog
                    if (currentKid.value != null) {
                      _notificationService
                          .markAllAsRead(currentKid.value!.kidId);
                      unreadNotifications.clear();
                      unreadNotificationCount.value = 0;
                      Get.back(); // Use Get.back() instead of Navigator.pop
                    }

                    SharedPreferencesHelper.saveBool(
                        SharedPreferencesHelper.showKidsNotifications, true);
                    isNotificationShowing.value = false;
                    if (shouldShowJarSpotLight()) {
                      startShowcase(Get.context!);
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      // This will run after dialog is dismissed
      if (unreadNotifications.isNotEmpty) {
        markAllNotificationsAsRead();
      }
    });
  }

  void markAllNotificationsAsRead() {
    if (currentKid.value != null) {
      _notificationService.markAllAsRead(currentKid.value!.kidId);
      unreadNotifications.clear();
      unreadNotificationCount.value = 0;
      SharedPreferencesHelper.saveBool(
          SharedPreferencesHelper.showKidsNotifications, true);
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
    final JarCreationController jarCreationController =
        Get.find<JarCreationController>();
    jarCreationController.jarType = jarType;
  }

  @override
  void onClose() {
    // _notificationSubscription?.cancel();
    SharedPreferencesHelper.saveBool(
        SharedPreferencesHelper.showKidsNotifications, true);
    resetShowcaseState();
    super.onClose();
  }
}
