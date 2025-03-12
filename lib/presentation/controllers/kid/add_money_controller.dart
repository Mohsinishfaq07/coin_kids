import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/models/notification_metadata.dart';
import 'package:coin_kids/data/models/notification_model.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/data/remote_services/notification_service.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/drag_and_drop_money_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/jar_creation_controller.dart';
import 'package:coin_kids/presentation/dialogs/common/loading_dialog.dart';
import 'package:coin_kids/presentation/screens/common/sign_in/sign_in_screen.dart';
import 'package:coin_kids/presentation/screens/kid/jars/drag_and_drop_money_screen.dart';
import 'package:get/get.dart';

class AddMoneyController extends GetxController {
  final appState = Get.find<AppStateController>();
  final jarCreationController = Get.find<JarCreationController>();
  final kidService = Get.find<KidService>();

  final amount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // If coming from jar creation, initialize with existing amount
    if (Get.arguments?['mode'] == AmountAdditionMode.jarCreation) {
      amount.value = jarCreationController.amount.value;
    }
  }

  Future<void> handleNextButton(AmountAdditionMode mode) async {
    if (!_validateAmount()) return;

    print("mode: $mode");
    switch (mode) {
      case AmountAdditionMode.jarCreation:
        // Update jar creation controller amount
        jarCreationController.amount.value = amount.value;
        Get.to(
          () => DragAndDropMoneyScreen(),
          arguments: {'mode': DragAndDropMode.jarCreation},
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
      showLoadingDialog("Adding Money");
      final kid = appState.currentKid.value;
      if (kid == null) {
        ToastUtil.showToast("Session Expired");
        Get.offAll(() => SignInScreen());
        return;
      }

      final newBalance = kid.wallet.spendingJar.balance + amount.value;
      kidService.updateSpendingJar(kid.kidId, newBalance);
      ToastUtil.showToast("Money added");
    } catch (e) {
      Get.log("Failed to add money $e");
      ToastUtil.showToast("Failed to Add money");
    } finally {
      Get.close(2);
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

    if (currentKid != null) {
      await notificationService.createNotification(
        NotificationModel(
          userId: currentKid.parentId,
          senderId: currentKid.kidId,
          message: "Money Request",
          type: NotificationType.transaction_pending,
          timestamp: DateTime.now(),
          isRead: false,
          metadata: TransactionPendingMetadata(amount: amount.value),
        ),
      );
      Get.back();
      ToastUtil.showToast("Money request sent to parent!");
    }
  }
}
