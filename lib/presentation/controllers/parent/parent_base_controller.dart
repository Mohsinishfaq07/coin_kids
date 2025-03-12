import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/controllers/common/role_controller.dart';
import 'package:coin_kids/presentation/screens/common/sign_in/sign_in_screen.dart';
import 'package:coin_kids/presentation/screens/parent/home_screen/parent_home_screen.dart';
import 'package:coin_kids/presentation/screens/parent/market/parent_market_screen.dart';
import 'package:coin_kids/presentation/screens/parent/messages_screen/messages_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ParentBaseController extends GetxController {
  final KidService _kidService = Get.find<KidService>();
  final RoleController roleController = Get.find<RoleController>();

  @override
  void onClose() {
    super.onClose();
  }

  final appState = Get.find<AppStateController>();
  final authService = Get.find<AuthService>();
  final kidService = Get.find<KidService>();

  RxString selectedChildIdForQuickTransfer = ''.obs;
  RxString selectedChildNameForQuickTransfer = ''.obs;

  final RxString customAvatarPath = ''.obs;
  final RxString networkImageUrl = ''.obs;

  final isLoading = false.obs;
  var currentIndex = 0.obs;

  var hasShownKidsZoneShowcase = true.obs;
  var hasAssignedGlobalKeyForShowcase = false.obs;

  @override
  void onInit() async {
    super.onInit();

    hasShownKidsZoneShowcase.value = await SharedPreferencesHelper.getBool(SharedPreferencesHelper.hasShownKidsZoneShowcase) ?? false;

    final parentId = authService.user.value?.uid;
    if (parentId == null) {
      ToastUtil.showToast("user session expired, Login Again");
      Get.offAll(() => SignInScreen());
      return;
    }
  }

   // Default to no selection
  RxBool isSelected = false.obs; //

  // Update Spending Jar Color in Firebase

  final List<Widget> screens = [
    ParentsHomeScreen(),
    MessagesScreen(),
    ParentMarketScreen(),
  ];

  var selectedAvatar = 0.obs;

  final selectedAvatarPath = ''.obs;

  Stream<bool> shouldShowKidsZoneShowcase(String parentId) {
    return _kidService.streamKids(parentId).map((kids) {
      if (kids.isEmpty) return false;

      // Check if any kid has a spending jar color that's not #000000
      return kids.any((kid) => kid.wallet.spendingJar.color != 0);
    });
  }
}
