import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_base_controller.dart';
import 'package:get/get.dart';

class ParentHomeController extends GetxController {
  final parentBaseController = Get.find<ParentBaseController>();
  final _kidService = Get.find<KidService>();
  final _authService = Get.find<AuthService>();

  final isLoading = false.obs;
  final kidsList = <KidModel>[].obs;

  // Change type to Worker
  Worker? _hasKidsWorker;

  @override
  void onInit() {
    super.onInit();
    // Listen to hasKids changes from ParentBaseController
    _hasKidsWorker = ever(parentBaseController.hasKids, (bool hasKids) {
      if (hasKids) {
        fetchKidsList();
      } else {
        kidsList.clear();
      }
    });

    // Initial fetch if hasKids is already true
    if (parentBaseController.hasKids.value) {
      fetchKidsList();
    }
  }

  Future<void> fetchKidsList() async {
    try {
      isLoading.value = true;
      final parentId = _authService.user.value?.uid;
      if (parentId != null) {
        final kids = await _kidService.fetchKidsByParentId(parentId);
        kidsList.assignAll(kids);
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
    _hasKidsWorker?.dispose();
    super.onClose();
  }
}
