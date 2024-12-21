import 'package:coin_kids/pages/roles/parents/authentication/parent_auth_controller/parent_auth_controller.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:coin_kids/pages/splash_screen/splash_controller.dart';
import 'package:get/get.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController(), fenix: true);

    Get.lazyPut(() => HomeController(), fenix: true);
  }
}
