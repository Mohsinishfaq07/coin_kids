import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/presentation/controllers/app_state_controller.dart';
import 'package:get/get.dart';

class JarCreationController extends GetxController {
  final appState = Get.find<AppStateController>();
  final kidService = Get.find<KidService>();

  final amount = ''.obs;
}
