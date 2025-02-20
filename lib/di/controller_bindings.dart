import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/firebase/firebase_authentication/firebase_auth.dart';
import 'package:coin_kids/presentation/components/kid/vertical_navigation_bar.dart';
import 'package:coin_kids/presentation/controllers/common/splash_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/favorite_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_home_controller.dart';
import 'package:get/get.dart';
import '../data/remote_services/wishlist_service.dart';
import '../presentation/controllers/common/intro_controller.dart';
import '../presentation/controllers/kid/add_money_controller.dart';
import '../presentation/controllers/kid/market_controller.dart';
import '../presentation/controllers/parent/add_child_controller.dart';
import '../presentation/controllers/parent/bottom_navigationbar_controller.dart';

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
    Get.lazyPut<IntroController>(() => IntroController(),
        fenix: true);
    Get.lazyPut<FavoriteController>(() => FavoriteController(), fenix: true);
    Get.lazyPut<AddMoneyController>(() => AddMoneyController(), fenix: true);
    Get.lazyPut<MarketController>(
      () => MarketController(),
      fenix: true,
    );
    Get.lazyPut<WishlistService>(() => WishlistService(), fenix: true);
    // Get.lazyPut<VerticalNavBarController>(() => VerticalNavBarController(),
    //     fenix: true);
    Get.put<VerticalNavBarController>(VerticalNavBarController(),
        permanent: true);

    Get.put<MarketController>(MarketController(), permanent: true);

    Get.put<AuthService>(AuthService(), permanent: true);
  }
}
