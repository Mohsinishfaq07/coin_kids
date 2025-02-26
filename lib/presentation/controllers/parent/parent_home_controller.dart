import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/presentation/controllers/app_state_controller.dart';
import 'package:coin_kids/utils/dummy_data_generator.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ParentHomeController extends GetxController {
  final _kidService = Get.find<KidService>();
  final _authService = Get.find<AuthService>();
  final appState = Get.find<AppStateController>();

  final isLoading = false.obs;
  final kidsList = <KidModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    if (appState.hasKid.value) {
      fetchKidsList();
    }

    if (kDebugMode) {
      //TODO: comment
      insertTestData();
    }
  }

  Future<void> fetchKidsList() async {
    try {
      isLoading.value = true;
      final parentId = _authService.user.value?.uid;
      if (parentId != null) {
        final kids = await _kidService.fetchKidsByParentId(parentId);
        kidsList.add(kids.first);
      }
    } catch (e) {
      print('Error fetching kids list: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Clean up worker when controller is destroyed
  @override
  void onClose() {
    super.onClose();
  }

  void insertTestData() async {
    final userId = Get.find<AuthService>().user.value?.uid;
    if (userId != null) {
      await DummyDataGenerator.insertDummyNotifications(userId);
      await DummyDataGenerator.insertDummyGoals(appState.currentKid.value!.kidId);
    }
  }
}
