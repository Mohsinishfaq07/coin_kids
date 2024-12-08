import 'package:coin_kids/features/roles/parents/authentication/parent_auth_controller/parent_auth_controller.dart';
import 'package:coin_kids/features/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:get/get.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ParentAuthController(),
        fenix: true); // Add your controllers or services here
    Get.lazyPut(() => HomeController(), fenix: true);
  }
}
