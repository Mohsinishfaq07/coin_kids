import 'package:coin_kids/data/remote_services/parent_service.dart';
import 'package:coin_kids/presentation/controllers/app_state_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdateProfileController extends GetxController {
  final appState = Get.find<AppStateController>();
  final parentService = Get.find<ParentService>();

  final selectedGender = ''.obs;
  final birthday = Rxn<DateTime>();
  final parentName = ''.obs;

  final isLoading = false.obs;

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  String formatDate(DateTime date) {
    return DateFormat('d MMM, y').format(date);
  }
}
