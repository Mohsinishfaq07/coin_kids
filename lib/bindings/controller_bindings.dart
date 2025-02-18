import 'package:coin_kids/controllers/favorite_controller.dart';
import 'package:coin_kids/firebase/firebase_authentication/firebase_auth.dart';
import 'package:coin_kids/pages/onboard/onboard_controller.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/add_money_controller.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/vertical_navigation_bar.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/services/wishlist_service.dart';
import 'package:coin_kids/pages/roles/parents/add_child/add_child_controller.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/bottom_navigationbar_controller.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:coin_kids/pages/splash_screen/splash_controller.dart';
import 'package:get/get.dart';

import '../pages/roles/kid_landscape_section/kid_market/market_controller.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    // Lazy load controllers
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<ParentController>(() => ParentController(), fenix: true);

    Get.lazyPut<ParentNavigationBarController>(
        () => ParentNavigationBarController(),
        fenix: true);
    Get.lazyPut<AddChildController>(() => AddChildController(), fenix: true);
    Get.lazyPut<FirebaseAuthController>(() => FirebaseAuthController(),
        fenix: true);
    Get.lazyPut<OnboardingController>(() => OnboardingController(),
        fenix: true);
    Get.lazyPut<FavoriteController>(() => FavoriteController(), fenix: true);
    Get.lazyPut<AddMoneyController>(() => AddMoneyController(), fenix: true);
    Get.lazyPut<MarketController>(
      () => MarketController(),
      fenix: true,
    );
    Get.lazyPut<WishlistService>(() => WishlistService(), fenix: true);
    Get.lazyPut<VerticalNavBarController>(() => VerticalNavBarController(),
        fenix: true);
  }
}
