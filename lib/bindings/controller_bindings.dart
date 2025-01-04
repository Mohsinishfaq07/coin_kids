import 'package:coin_kids/firebase/firebase_authentication/firebase_auth.dart';
import 'package:coin_kids/pages/roles/kid/kid_bottom_nav/kid_nav_controller.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:coin_kids/pages/splash_screen/splash_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    // Lazy load controllers
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<ParentHomeController>(() => ParentHomeController(), fenix: true);
    }
}
