import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/drag_and_drop_money_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_appbar_controller.dart';
import 'package:get/get.dart';

class KidTransferController extends GetxController {
  final appState = Get.find<AppStateController>();
  final appBarController = Get.find<KidAppBarController>();
  final RxBool showPointer = true.obs;


  static const String _transferShowcaseKey = 'transfer_showcase_shown';
  RxBool isShowcaseVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkShowcaseStatus();
  }

  Future<void> checkShowcaseStatus() async {
    final hasShown = SharedPreferencesHelper.getBool(_transferShowcaseKey) ?? false;
    isShowcaseVisible.value = !hasShown;
  }

  Future<void> markShowcaseAsShown() async {
    await SharedPreferencesHelper.saveBool(_transferShowcaseKey, true);
    isShowcaseVisible.value = false;
  }

  @override
  void onReady() {
    appBarController.configureForTransfer();

    super.onReady();
  }

  void handleTransfer({
    required String sourceJar,
    required String targetJar,
    required double availableAmount,
  }) {
    if (availableAmount <= 0) {
      ToastUtil.showToast('Not enough funds in jar');
      return;
    }

    Get.toNamed(
      Routes.kidDragAndDrop,
      arguments: {
        'mode': DragAndDropMode.transferMoney,
        'sourceJarId': sourceJar,
        'targetJarId': targetJar,
        'amount': availableAmount,
      },
    );
  }

  @override
  void onClose() {
    appBarController.resetToDefault();
    super.onClose();
  }
}
