import 'dart:async';
import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/utils/orientation_utils.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/data/models/notification_model.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/data/remote_services/notification_service.dart';
import 'package:coin_kids/generated/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_notification_dialog.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/controllers/common/role_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/jar_creation_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_appbar_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/vertical_navigationbar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';

class KidBaseController extends GetxController {
  // Dependencies
  final RoleController _roleController = Get.find<RoleController>();
  final VerticalNavBarController navigationController =
      Get.find<VerticalNavBarController>();
  final NotificationService _notificationService = NotificationService();
  final AppStateController appState = Get.find<AppStateController>();
  final appBarController = Get.find<KidAppBarController>();
  final kidService = Get.find<KidService>();
  final analytics = Get.find<AnalyticsService>();
  RxBool isNotificationShowing = true.obs;
  final Rx<Offset?> pointerPosition = Rx<Offset?>(null);
  RxBool showSavingJar = false.obs;

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
  final RxBool showGoalsTutorial = true.obs;
  final RxBool showTransferPointer = true.obs;



  KidBaseController() {
    _initialize();
  }

  void _initialize() {
    OrientationUtils.lockToLandscape();
    _initializeKid();
    _initializeGoalsTutorial();
   // _initializeTransferTutorial();
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

  Future<void> _initializeGoalsTutorial() async {
    final hasSeenTutorial = SharedPreferencesHelper.getBool(
            SharedPreferencesHelper.hasSeenGoalsTutorial) ??
        false;
    showGoalsTutorial.value = !hasSeenTutorial;
  }

  Future<void> _initializeTransferTutorial() async {
    final hasSeenTutorial = SharedPreferencesHelper.getBool(
            SharedPreferencesHelper.hasSeenTransferTutorial) ??
        false;
    showTransferPointer.value = !hasSeenTutorial;
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
        await showNotificationsDialog();
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
   // final isParentOpened = appState.currentKid.value!.isConnected;
    // final hasShownEarlier = SharedPreferencesHelper.getBool(
    //         SharedPreferencesHelper.showcaseMoneyJarKey) ??
    //     false;
    final hasBalance =
        appState.currentKid.value!.wallet.spendingJar.balance != 0;

   // Get.log('$jarCreated, $isParentOpened, $hasShownEarlier, $hasBalance');

    if (showJarShowcase.value == false) return false;
    //Jar Exists - Return
    if (jarCreated) return false;

    //Jar Not Exist, But Spotlight already show - Return
    // if (hasShownEarlier) return false;
    //ar Not Exist, Spotlight Not Shown, has Parent and Balance
   /// if (isParentOpened && !hasBalance) return false;

    return true;
  }

  final GlobalKey moneyJarShowcaseKey = GlobalKey();

  void startShowcase(BuildContext context) async {
    if (shouldShowJarSpotLight() && !isNotificationShowing.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          ShowCaseWidget.of(context).startShowCase([moneyJarShowcaseKey]);
          showJarShowcase.value = false;
          //await markMoneyJarShowcaseAsShown();
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




  Future<void> showNotificationsDialog() async {
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
    if (!context.mounted) return;

    isNotificationShowing.value = true;

    try {
      // Show the notifications dialog first
      await showGeneralDialog(
        barrierColor: Colors.transparent,
        context: context,
        barrierDismissible: false,
        barrierLabel: "Notifications",
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return WillPopScope(
            onWillPop: () async {
              isNotificationShowing.value = false;
              if (unreadNotifications.isNotEmpty) {
                markAllNotificationsAsRead();
              }
              
              // Show animation before proceeding
             // await _showDismissAnimation();
              
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
                    onDismissSingle: (notification) async {
                      // Mark single notification as read
                      _notificationService.markAsRead(notification.id!);
                      unreadNotifications.removeWhere((n) => n.id == notification.id);
                      unreadNotificationCount.value = unreadNotifications.length;

                      // For single notification or final notification
                      if (unreadNotifications.isEmpty) {
                        SharedPreferencesHelper.saveBool(
                            SharedPreferencesHelper.showKidsNotifications, true);
                        isNotificationShowing.value = false;
                        Get.back(); // Close notification dialog
                        // if (notification.type == NotificationType.balanceAdded) {
                        //   await _showDismissForMoneyAddedAnimation();
                        // } else if (notification.type == NotificationType.balanceRemoved) {
                        //   await _showDismissForMoneyRemovedAnimation();
                        // }
                        if (shouldShowJarSpotLight()) {
                          startShowcase(Get.context!);
                        }
                      }
                    },
                    onDismissAll: () async {
                      // Mark all as read and close dialog
                      if (currentKid.value != null) {
                        _notificationService.markAllAsRead(currentKid.value!.kidId);
                        unreadNotifications.clear();
                        unreadNotificationCount.value = 0;
                      }

                      SharedPreferencesHelper.saveBool(
                          SharedPreferencesHelper.showKidsNotifications, true);
                      isNotificationShowing.value = false;
                      Get.back(); // Close notification dialog
                      // final lastNotification = currentNotifications.last;
                      // if (lastNotification.type == NotificationType.balanceAdded) {
                      //   await _showDismissForMoneyAddedAnimation();
                      // } else if (lastNotification.type == NotificationType.balanceRemoved) {
                      //   await _showDismissForMoneyRemovedAnimation();
                      // }
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
      );
    } catch (e) {
      Get.log("Error showing notifications dialog: $e");
      isNotificationShowing.value = false;
    }
  }

  // Helper method to show appropriate animation based on type
  Future<void> _showAppropriateAnimation(NotificationType type) async {
    switch (type) {
      case NotificationType.balanceAdded:
      case NotificationType.transactionApproved:
        await _showDismissForMoneyAddedAnimation();
        break;
      case NotificationType.balanceRemoved:
      case NotificationType.transactionRejected:
        await _showDismissForMoneyRemovedAnimation();
        break;
      default:
        // No animation for other notification types
        break;
    }
  }

  Future<void> _showDismissForMoneyAddedAnimation() async {
    try {
      // Add half second delay before showing animation
      await Future.delayed(const Duration(milliseconds: 500));
      
      await Get.dialog(
        Material(
          type: MaterialType.transparency,
          color: Colors.green,
          child: Container(
            height: Get.height,
            color: Colors.transparent,
            child: Center(
              child: Transform.rotate(
                angle: 20 * pi / 180,
                child: Lottie.asset(
                  Assets.animationsReceivedMoney,
                  fit: BoxFit.contain,
                  repeat: false,
                  frameRate: FrameRate(60),
                  onLoaded: (composition) {
                    Future.delayed(composition.duration, () {
                      if (Get.isDialogOpen!) {
                        Get.back();
                      }
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        barrierColor: Colors.transparent,
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 200),
        useSafeArea: false,
      );
      
    } catch (e) {
      Get.log("Error showing money added animation: $e");
    }
  }

  Future<void> _showDismissForMoneyRemovedAnimation() async {
    try {
      // Add half second delay before showing animation
      await Future.delayed(const Duration(milliseconds: 500));
      
      await Get.dialog(
        Material(
          type: MaterialType.transparency,
          color: Colors.red,
          child: Container(
            height: Get.height,
            color: Colors.transparent,
            child: Center(
              child: Transform.rotate(
                angle: 20 * pi / 180,
                child: Lottie.asset(
                  'assets/animations/money_goes.json',
                  fit: BoxFit.contain,
                  repeat: false,
                  frameRate: FrameRate(60),
                  onLoaded: (composition) {
                    Future.delayed(composition.duration, () {
                      if (Get.isDialogOpen!) {
                        Get.back();
                      }
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        barrierColor: Colors.transparent,
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 200),
        useSafeArea: false,
      );
      
    } catch (e) {
      Get.log("Error showing money removed animation: $e");
    }
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

  Future<void> completeGoalsTutorial() async {
    Get.log("Completing goals tutorial");
    showGoalsTutorial.value = false;
    navigationController.completeGoalsTutorial();
    await SharedPreferencesHelper.saveBool(
        SharedPreferencesHelper.hasSeenGoalsTutorial, true);
  }

  Future<void> markTransferTutorialAsShown() async {
    await SharedPreferencesHelper.saveBool(
      SharedPreferencesHelper.hasSeenTransferTutorial,
      true,
    );
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

