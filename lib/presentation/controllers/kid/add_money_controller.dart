import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/models/notification_metadata.dart';
import 'package:coin_kids/data/models/notification_model.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/data/remote_services/notification_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/drag_and_drop_money_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/jar_creation_controller.dart';
import 'package:coin_kids/presentation/dialogs/common/loading_dialog.dart';
import 'package:coin_kids/presentation/dialogs/kid/kid_dialog.dart';
import 'package:get/get.dart';

class AddMoneyController extends GetxController {
  final appState = Get.find<AppStateController>();
  final jarCreationController = Get.find<JarCreationController>();

  final amount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // If coming from jar creation, initialize with existing amount
    if (Get.arguments == AmountAdditionMode.jarCreation) {
      amount.value = jarCreationController.amount.value;
    }
  }

  Future<void> handleNextButton(AmountAdditionMode mode) async {
    if (!_validateAmount()) return;

    Get.log("mode: $mode");
    switch (mode) {
      case AmountAdditionMode.jarCreation:
        // Update jar creation controller amount
        jarCreationController.amount.value = amount.value;
        Get.toNamed(
          Routes.kidDragAndDrop,
          arguments: {
            'mode': DragAndDropMode.jarCreation,
          },
        );
        break;

      case AmountAdditionMode.requestMoney:
        await _handleMoneyRequest();
        break;

      case AmountAdditionMode.addMoney:
        _handleAddMoney();
        break;
    }
  }

  void _handleAddMoney() {
    try {
      final kidService = Get.find<KidService>();
      showLoadingDialog("Adding Money");
      final kid = appState.currentKid.value;
      if (kid == null) {
        ToastUtil.showToast("Session Expired");
        Get.offAllNamed(Routes.signIn);
        return;
      }

      final newBalance = kid.wallet.spendingJar.balance + amount.value;
      kidService.updateSpendingJar(kid.kidId, newBalance);
      ToastUtil.showToast("Money added");
    } catch (e) {
      Get.log("Failed to add money $e");
      ToastUtil.showToast("Failed to Add money");
    } finally {
      Get.until((route) => route.settings.name == Routes.kidBase);
    }
  }

  bool _validateAmount() {
    if (amount.value == 0.0) {
      ToastUtil.showToast("Please add Valid amount");
      return false;
    }

    return true;
  }

  Future<void> _handleMoneyRequest() async {
    final notificationService = Get.find<NotificationService>();
    final currentKid = appState.currentKid.value;

    if (currentKid == null) {
      ToastUtil.showToast("Session Expired");
      Get.offAllNamed(Routes.signIn);
      return;
    }
    try {
      await notificationService.createNotification(
        NotificationModel(
          userId: currentKid.parentId,
          senderId: currentKid.kidId,
          title: "Money Request",
          type: NotificationType.transactionPending,
          timestamp: DateTime.now(),
          isRead: false,
          metadata: TransactionPendingMetadata(amount: amount.value, name: currentKid.name, photo: currentKid.avatar, status: TransactionPendingStatus.pending),
        ),
      );
      Get.back();
      KidDialog.show(
        emoji: Assets.icCoinEuro,
        title: "Money Requested",
        subtitle: "Go to Parent zone to Accept request.",
        buttons: [
          KidButton(
            onTap: () {
              Get.back();
            },
            baseColor: AppColors.btnColorGreen,
            text: "Got it",
          )
        ],
      );
    } catch (e) {
      Get.log("error is $e");
      ToastUtil.showToast("Failed to request. Check Internet");
    }
  }
}
