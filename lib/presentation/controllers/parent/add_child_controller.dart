import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/presentation/dialogs/common/loading_dialog.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddChildController extends GetxController {
  final kidsService = Get.find<KidService>();
  final authService = Get.find<AuthService>();
  final ImagePicker _picker = ImagePicker();
  final analytics = Get.find<AnalyticsService>();


  final childName = ''.obs;
  final childAge = ''.obs;

  final selectedAvatar = 0.obs;
  final selectedAvatarPath = ''.obs;
  final avatars = <String>[].obs;
  final kidImagePath = ''.obs;

  final isLoading = false.obs;
  final isLoadingAvatars = true.obs;
  DateTime? _screenStartTime;


  @override
  void onInit() {
    super.onInit();
    _screenStartTime = DateTime.now();
    logScreenTime();
    loadAvatars();
  }

  Future<void> loadAvatars() async {
    try {
      isLoadingAvatars.value = true;
      final urls = await kidsService.fetchPredefinedAvatars();
      avatars.value = urls;
      selectedAvatarPath.value = urls.first;
    } catch (e) {
      ToastUtil.showToast('Failed to load avatars: $e');
    } finally {
      isLoadingAvatars.value = false;
    }
  }

  Future<void> pickImage({required ImageSource source}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        kidImagePath.value = pickedFile.path;
        selectedAvatarPath.value = '';
        selectedAvatar.value = -1;
      }
    } catch (e) {
      ToastUtil.showToast("Failed to pick image: $e");
    }
  }

  void selectAvatar(int index) {
    selectedAvatar.value = index;
    kidImagePath.value = ''; // Clear custom avatar selection
    selectedAvatarPath.value = avatars[index];
  }

  Future<void> createKid(bool isConnected) async {
    if (isLoading.value) return; // Add early return if already loading
    isLoading.value = true;
    
    showLoadingDialog("Adding Child");
    try {
      // Validate inputs
      if (childName.value.isEmpty) {
        ToastUtil.showToast("Please enter child name");
        return;
      }

      if (childAge.value.isEmpty) {
        ToastUtil.showToast("Please enter child age");
        return;
      }

      if (kidImagePath.value.isEmpty && selectedAvatarPath.value.isEmpty) {
        ToastUtil.showToast("Please select an avatar or upload an image");
        return;
      }

      isLoading.value = true;

      final parentId = authService.user.value?.uid;
      if (parentId == null) {
        ToastUtil.showToast("User Session Expired");
        Get.offAllNamed(Routes.signIn);
        return;
      }

      // Handle the "14+" case
      int age;
      if (childAge.value == "14+") {
        age = 14;
      } else {
        age = int.parse(childAge.value);
      }

      await kidsService.createKid(
        name: childName.value,
        age: age,
        parentId: parentId,
        customImagePath: kidImagePath.value,
        selectedAvatarUrl: selectedAvatarPath.value,
        isConnected: isConnected,
      );

      ToastUtil.showToast("Child added successfully");
      await analytics.logAddChildClickSuccessFull(AnalyticsScreenNames.parentAddKidScreen);
      Get.until((route) => route.settings.name == Routes.parentBase);

    } catch (e) {
      await analytics.logAddChildFailures(AnalyticsScreenNames.parentAddKidScreen);
      Get.log("Failed to add child: $e");
      ToastUtil.showToast("Failed to add child: $e");
    } finally {
      isLoading.value = false;
    }
  }


  @override
  void onClose() {
    logScreenTime();
    super.onClose();
  }

  Future<void> logScreenTime() async {
    if (_screenStartTime != null) {
      final endTime = DateTime.now();
      final durationInSeconds = endTime.difference(_screenStartTime!).inSeconds;
      analytics.screenTime(AnalyticsScreenNames.parentAddKidScreen,durationInSeconds.toString());
    }
    FirebaseAnalytics.instance.logScreenView(
      screenName: AnalyticsScreenNames.parentAddKidScreen,
    );
  }

}
