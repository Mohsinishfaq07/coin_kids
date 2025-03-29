import 'package:coin_kids/core/extensions/number_extensions.dart';
import 'package:coin_kids/data/models/notification_metadata.dart';
import 'package:coin_kids/data/models/notification_model.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/data/remote_services/notification_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_base_controller.dart';
import 'package:coin_kids/presentation/dialogs/common/loading_dialog.dart';
import 'package:coin_kids/presentation/dialogs/parent/app_parent_dialog.dart';
import 'package:get/get.dart';

enum TransferMode {
  sendMoney,
  requestedMoney,
}

class QuickTransferController extends GetxController {
  final appState = Get.find<AppStateController>();
  final kidService = Get.find<KidService>();
  final notificationService = Get.find<NotificationService>();
  final parentBaseController = Get.find<ParentBaseController>();

  RxString amount = ''.obs;
  RxString message = ''.obs;
  RxString amountValidation = ''.obs;
  TransferMode mode = TransferMode.sendMoney;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args != null) {
      amount.value = (args['amount'] ?? '').toString();
      mode = (args['mode'] ?? TransferMode.sendMoney) as TransferMode;
    }

    super.onInit();
  }

  void sendMoney() async {
    if (amount.value.isEmpty) {
      amountValidation.value = 'Enter valid amount';
    } else {
      showLoadingDialog("Sending Money");
      try {
        double enteredAmount = double.parse(amount.value);
        final kid = appState.currentKid.value!;
        var newBalance = kid.wallet.spendingJar.balance + enteredAmount;

        await kidService.updateSpendingJar(kid.kidId, newBalance).timeout(Duration(seconds: 15), onTimeout: () {
          throw Exception("Request Timeout");
        });

        if (mode == TransferMode.sendMoney) {
          await notificationService.createNotification(
            NotificationModel(
              userId: kid.kidId,
              senderId: kid.parentId,
              type: NotificationType.balanceAdded,
              title: "Received Money",
              timestamp: DateTime.now(),
              metadata: BalanceMetadata(amount: enteredAmount, type: NotificationType.balanceAdded, message: message.value),
            ),
          );
        } else {
          await notificationService.createNotification(
            NotificationModel(
              userId: kid.kidId,
              senderId: kid.parentId,
              type: NotificationType.transactionApproved,
              title: "Request Approved",
              timestamp: DateTime.now(),
              metadata: TransactionMetadata(amount: enteredAmount, type: NotificationType.transactionApproved),
            ),
          );
        }

        await Get.dialog(
          AppParentDialog(
            iconPath: Assets.icSuccessDialog,
            title: "Transfer Successful",
            subtitle: "€$enteredAmount Transferred to ${kid.name}",
            buttons: [
              DialogButton(
                text: "Close",
                onPressed: () async {
                  parentBaseController.showKidsZoneShowcase.value = true;
                  Get.close(3);
               //   Get.offNamed(Routes.parentBase);
                  // Get.until((route) => route.settings.name == Routes.parentBase);
                },
              ),
            ],
          ),
        );
      } on Exception catch (e) {
        Get.log("Exception $e");
      }
    }
  }

  void removeMoney() async {
    if (amount.value.isEmpty) {
      amountValidation.value = 'Enter valid amount';
      return;
    }
    double enteredAmount = double.parse(amount.value);
    final kid = appState.currentKid.value!;
    var newBalance = kid.wallet.spendingJar.balance - enteredAmount;

    if (newBalance < 0) {
      amountValidation.value = '${kid.name} don\'t have enough money';
      return;
    }

    showLoadingDialog("Deducting Money");
    try {
      await kidService.updateSpendingJar(kid.kidId, newBalance).timeout(Duration(seconds: 15), onTimeout: () {
        throw Exception("Request Timeout");
      });

      await notificationService.createNotification(
        NotificationModel(
          userId: kid.kidId,
          senderId: kid.parentId,
          type: NotificationType.balanceRemoved,
          title: "Deducted Money",
          timestamp: DateTime.now(),
          metadata: BalanceMetadata(amount: enteredAmount, type: NotificationType.balanceRemoved, message: message.value.trim()),
        ),
      );

      await Get.dialog(
        AppParentDialog(
          iconPath: Assets.icSuccessDialog,
          title: "Deduction Successful",
          subtitle: "${enteredAmount.toMoneyFormat()} Deducted from ${kid.name}",
          buttons: [
            DialogButton(
              text: "Close",
              onPressed: () async {
                parentBaseController.showKidsZoneShowcase.value = true;
                Get.offNamed(Routes.parentBase);
                // Get.until((route) => route.settings.name == Routes.parentBase);
              },
            ),
          ],
        ),
      );
    } on Exception catch (e) {
      Get.log("Exception $e");
    }
  }
}
