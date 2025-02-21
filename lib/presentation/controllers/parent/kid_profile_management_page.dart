import 'package:coin_kids/data/models/kid_model.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:get/get.dart';


class KidProfileManagementPageController extends GetxController {
  final KidService _kidService = Get.find();
  Rx<KidModel?> currentKid = Rx<KidModel?>(null);
  Rx<bool> isLoading = Rx<bool>(false);

  Future<void> loadKidData(String parentId) async {
    try {
      isLoading.value = true;
      // Fetch kids by parentId
      List<KidModel> kids = await _kidService.fetchKidsByParentId(parentId);
      // Assuming we want to load the first kid for the profile management page
      if (kids.isNotEmpty) {
        currentKid.value = kids.first;
      } else {
        currentKid.value = null; // No kids found
      }
    } catch (e) {
      print('Error loading kid data: $e');
    } finally {
      isLoading.value = false;
    }
  }
} 