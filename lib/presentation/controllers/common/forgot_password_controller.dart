import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final authService = Get.find<AuthService>();

  final email = ''.obs;
}
