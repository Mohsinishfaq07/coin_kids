import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/presentation/components/kid/vertical_navigation_bar.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/controllers/common/role_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/jar_creation_controller.dart';
import 'package:get/get.dart';

class KidBaseController extends GetxController {
  // Dependencies
  final AppStateController _appStateController = Get.find<AppStateController>();
  final RoleController _roleController = Get.find<RoleController>();
  final VerticalNavBarController navigationController = Get.find<VerticalNavBarController>();

  final AppStateController appState = Get.find<AppStateController>();

  // Observables
  final Rx<KidModel?> currentKid = Rx<KidModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeKid();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void _initializeKid() {
    currentKid.value = _appStateController.currentKid.value;
    ever(_appStateController.currentKid, (KidModel? kid) {
      currentKid.value = kid;
    });
  }

  void switchToParentMode() {
    _roleController.switchToParentMode(true);
  }

  bool get hasValidSpendingJar {
    return currentKid.value?.wallet.spendingJar.color != 0;
  }

  void startJarCreation(Jars jarType) {
    final JarCreationController jarCreationController = Get.find<JarCreationController>();
    jarCreationController.jarType = jarType;
  }
}
