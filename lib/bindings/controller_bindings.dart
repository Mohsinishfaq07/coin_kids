import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:coin_kids/pages/splash_screen/splash_controller.dart';
import 'package:get/get.dart';


class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    // Lazy load controllers
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<ParentHomeController>(() => ParentHomeController(), fenix: true);
    }
}
