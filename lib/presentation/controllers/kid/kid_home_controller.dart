import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/presentation/components/kid/vertical_navigation_bar.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:get/get.dart';

class KidHomeController extends GetxController {
  // Dependencies
  final AppStateController _appStateController = Get.find<AppStateController>();
  final VerticalNavBarController navigationController = Get.find<VerticalNavBarController>();

  // Observables
  final Rx<KidModel?> currentKid = Rx<KidModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeKid();
  }

  void _initializeKid() {
    currentKid.value = _appStateController.currentKid.value;
    // Listen to changes in AppStateController
    ever(_appStateController.currentKid, (KidModel? kid) {
      currentKid.value = kid;
    });
  }

  bool get hasValidSpendingJar {
    return currentKid.value?.wallet.spendingJar.color != 0;
  }
}
