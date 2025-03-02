import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/controllers/app_state_controller.dart';
import 'package:coin_kids/presentation/screens/common/sign_in/login_screen.dart';
import 'package:coin_kids/presentation/screens/parent/home_screen/parent_home_screen.dart';
import 'package:coin_kids/presentation/screens/parent/messages_screen/messages_screen.dart';
import 'package:coin_kids/presentation/screens/parent/market/parent_market_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ParentBaseController extends GetxController {
  final GlobalKey kidsZoneShowcaseKey = GlobalKey();
  final KidService _kidService = Get.find<KidService>();
  @override
  void onClose() {
    // Clean up any streams, animations, or other resources
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

  @override
  void onInit() async {
    super.onInit();

    final parentId = authService.user.value?.uid;
    if (parentId == null) {
      ToastUtil.showToast("user session expired, Login Again");
      Get.offAll(() => LoginScreen());
      return;
    }
  }

  var selectedColorIndex = (-1).obs; // Default to no selection
  RxBool isSelected = false.obs; //

  // Update Spending Jar Color in Firebase

  final List<Widget> screens = [
    ParentsHomeScreen(),
    MessagesScreen(),
    ParentMarketScreen(),
  ];

  var selectedAvatar = 0.obs;

  final selectedAvatarPath = ''.obs;
  var isShowcaseShown = false.obs; // Flag to check if the showcase has been shown

  // Other controller code...

  void showShowcase() {
    if (!isShowcaseShown.value) {
      // Logic to show the showcase
      // For example: Show dialog, animation, or any custom widget to highlight the section
      isShowcaseShown.value = true;
    }
  }
  Stream<bool> shouldShowKidsZoneShowcase(String parentId) {
    return _kidService.streamKids(parentId).map((kids) {
      if (kids.isEmpty) return false;
      
      // Check if any kid has a spending jar color that's not #000000
      return kids.any((kid) => 
        kid.wallet.spendingJar.color != '#000000'
      );
    });
  }
}
