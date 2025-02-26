import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/goal_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/data/remote_services/market_service.dart';
import 'package:coin_kids/data/remote_services/notification_service.dart';
import 'package:coin_kids/data/remote_services/parent_service.dart';
import 'package:coin_kids/data/remote_services/transaction_service.dart';
import 'package:coin_kids/firebase/firebase_authentication/authentication_controller.dart';
import 'package:coin_kids/presentation/components/kid/vertical_navigation_bar.dart';
import 'package:coin_kids/presentation/controllers/app_state_controller.dart';
import 'package:coin_kids/presentation/controllers/common/role_selection_controller.dart';
import 'package:coin_kids/presentation/controllers/common/sign_in_controller.dart';
import 'package:coin_kids/presentation/controllers/common/signup_controller.dart';
import 'package:coin_kids/presentation/controllers/common/splash_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/DrawerController.dart';
import 'package:coin_kids/presentation/controllers/parent/favorite_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/kid_profile_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/messages_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_base_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_home_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/quick_transfer_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/update_profile_controller.dart';
import 'package:get/get.dart';

import '../data/remote_services/wishlist_service.dart';
import '../presentation/controllers/common/intro_controller.dart';
import '../presentation/controllers/kid/add_money_controller.dart';
import '../presentation/controllers/kid/market_controller.dart';
import '../presentation/controllers/parent/add_child_controller.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    //Firebase Services
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<ParentService>(ParentService(), permanent: true);
    Get.put<KidService>(KidService(), permanent: true);
    Get.lazyPut<GoalService>(() => GoalService(), fenix: true);
    Get.lazyPut<WishlistService>(() => WishlistService(), fenix: true);
    Get.lazyPut<MarketService>(() => MarketService(), fenix: true);
    Get.lazyPut<TransactionService>(() => TransactionService(), fenix: true);
    Get.lazyPut<NotificationService>(() => NotificationService(), fenix: true);

    //Controllers
    Get.put(AppStateController(), permanent: true);
    Get.put<SharedPreferencesHelper>(SharedPreferencesHelper(), permanent: true);
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<SignupController>(() => SignupController(), fenix: true);
    Get.lazyPut<SignInController>(() => SignInController(), fenix: true);
    Get.lazyPut<RoleSelectionController>(() => RoleSelectionController());
    Get.put<AuthenticationController>(AuthenticationController(), permanent: true);
    Get.lazyPut<ParentBaseController>(() => ParentBaseController(), fenix: true);
    Get.lazyPut<ParentHomeController>(() => ParentHomeController(), fenix: true);
    Get.lazyPut<AddChildController>(() => AddChildController(), fenix: true);
    Get.lazyPut<QuickTransferController>(() => QuickTransferController(), fenix: true);
    Get.lazyPut<ParentDrawerController>(() => ParentDrawerController(), fenix: true);
    Get.lazyPut<UpdateProfileController>(() => UpdateProfileController(), fenix: true);
    Get.lazyPut<MessagesController>(() => MessagesController(), fenix: true);
    Get.lazyPut<KidProfileController>(() => KidProfileController(), fenix: true);

    Get.lazyPut<IntroController>(() => IntroController(), fenix: true);
    Get.lazyPut<FavoriteController>(() => FavoriteController(), fenix: true);
    Get.lazyPut<AddMoneyController>(() => AddMoneyController(), fenix: true);
    Get.lazyPut<MarketController>(() => MarketController(), fenix: true);
    Get.put<VerticalNavBarController>(VerticalNavBarController(), permanent: true);
  }
}
