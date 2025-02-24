import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/components/parent/message_placeholder_screen.dart';
import 'package:coin_kids/presentation/controllers/app_state_controller.dart';
import 'package:coin_kids/presentation/screens/common/sign_in/login_screen.dart';
import 'package:coin_kids/presentation/screens/parent/home_screen/parent_home_screen.dart';
import 'package:coin_kids/presentation/screens/parent/parent_market/parent_market_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ParentBaseController extends GetxController {
  final appState = Get.find<AppStateController>();
  final _authService = Get.find<AuthService>();

  RxString selectedChildIdForQuickTransfer = ''.obs;
  RxString selectedChildNameForQuickTransfer = ''.obs;

  final RxString customAvatarPath = ''.obs;
  final RxString networkImageUrl = ''.obs;

  final isLoading = false.obs;
  var currentIndex = 0.obs;

  @override
  void onInit() async {
    super.onInit();

    final parentId = _authService.user.value?.uid;
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
    const MessagePlaceholderScreen(),
    ParentMarketScreen(),
  ];

  var selectedAvatar = 0.obs;

  final selectedAvatarPath = ''.obs;
}
