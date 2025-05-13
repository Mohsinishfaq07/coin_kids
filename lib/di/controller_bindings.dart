import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/goal_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/data/remote_services/market_service.dart';
import 'package:coin_kids/data/remote_services/notification_service.dart';
import 'package:coin_kids/data/remote_services/parent_service.dart';
import 'package:coin_kids/data/remote_services/transaction_service.dart';
import 'package:coin_kids/presentation/components/kid/vertical_navigation_bar.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/controllers/common/forgot_password_controller.dart';
import 'package:coin_kids/presentation/controllers/common/role_selection_controller.dart';
import 'package:coin_kids/presentation/controllers/common/sign_in_controller.dart';
import 'package:coin_kids/presentation/controllers/common/signup_controller.dart';
import 'package:coin_kids/presentation/controllers/common/splash_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/add_money_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/jar_creation_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_appbar_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_base_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_goals_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_market_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_onboarding_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_transfer_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_wishlist_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/change_language_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/edit_child_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/kid_profile_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/messages_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_base_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_change_pin_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_feedback_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_home_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_market_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_wishlist_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/quick_transfer_controller.dart';
import 'package:coin_kids/presentation/controllers/parent/update_profile_controller.dart';
import 'package:get/get.dart';

import '../data/remote_services/wishlist_service.dart';
import '../presentation/controllers/common/intro_controller.dart';
import '../presentation/controllers/common/role_controller.dart';
import '../presentation/controllers/kid/drag_and_drop_money_controller.dart';
import '../presentation/controllers/parent/add_child_controller.dart';
import '../presentation/controllers/parent/parent_drawer_controller.dart';
import '../data/remote_services/analytics_service.dart';
import '../presentation/controllers/common/analytics_controller.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    // First register AnalyticsService since AnalyticsController depends on it
    Get.put<AnalyticsService>(AnalyticsService(), permanent: true);
    
    // Then register AnalyticsController
    Get.put<AnalyticsController>(AnalyticsController(), permanent: true);

    //Firebase Services
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<ParentService>(ParentService(), permanent: true);
    Get.put<KidService>(KidService(), permanent: true);
    Get.put<GoalService>(GoalService(), permanent: true);
    Get.put<WishlistService>(WishlistService(), permanent: true);
    Get.put<MarketService>(MarketService(), permanent: true);
    Get.put<TransactionService>(TransactionService(), permanent: true);
    Get.put<NotificationService>(NotificationService(), permanent: true);

    //Common
    Get.put(AppStateController(), permanent: true);
    Get.put<RoleController>(RoleController(), permanent: true);
    Get.put<SharedPreferencesHelper>(SharedPreferencesHelper(), permanent: true);
    Get.put<RoleSelectionController>(RoleSelectionController(), permanent: true);

    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<IntroController>(() => IntroController(), fenix: true);
    Get.lazyPut<SignupController>(() => SignupController(), fenix: true);
    Get.lazyPut<SignInController>(() => SignInController(), fenix: true);
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController(), fenix: true);

    //Parent
    Get.lazyPut<ParentBaseController>(() => ParentBaseController(), fenix: true);
    Get.lazyPut<ParentHomeController>(() => ParentHomeController(), fenix: true);
    Get.lazyPut<AddChildController>(() => AddChildController(), fenix: true);
    Get.lazyPut<QuickTransferController>(() => QuickTransferController(), fenix: true);
    Get.lazyPut<ParentDrawerController>(() => ParentDrawerController(), fenix: true);
    Get.lazyPut<UpdateProfileController>(() => UpdateProfileController(), fenix: true);
    Get.lazyPut<MessagesController>(() => MessagesController(), fenix: true);
    Get.lazyPut<KidProfileController>(() => KidProfileController(), fenix: true);
    Get.lazyPut<ParentMarketController>(() => ParentMarketController(), fenix: true);
    Get.lazyPut<EditChildController>(() => EditChildController(), fenix: true);
    Get.lazyPut<ParentWishlistController>(() => ParentWishlistController(), fenix: true);
    Get.lazyPut<ParentChangePinController>(() => ParentChangePinController(), fenix: true);
    Get.lazyPut<ParentFeedbackController>(() => ParentFeedbackController(), fenix: true);
    Get.lazyPut<ChangeLanguageController>(() => ChangeLanguageController(),
        fenix: true);

    //KID
    Get.lazyPut<KidOnboardingController>(() => KidOnboardingController(), fenix: true);
    Get.lazyPut<VerticalNavBarController>(() => VerticalNavBarController(Get.find<KidAppBarController>()), fenix: true);
    Get.lazyPut<KidAppBarController>(() => KidAppBarController(), fenix: true);
    Get.lazyPut<KidBaseController>(() => KidBaseController(), fenix: true);
    Get.lazyPut<DragAndDropMoneyController>(() => DragAndDropMoneyController(), fenix: true);
    Get.lazyPut<KidMarketController>(() => KidMarketController(), fenix: true);
    Get.lazyPut<KidWishlistController>(() => KidWishlistController(), fenix: true);
    Get.lazyPut<JarCreationController>(() => JarCreationController(), fenix: true);
    Get.lazyPut<KidTransferController>(() => KidTransferController(), fenix: true);
    Get.lazyPut<AddMoneyController>(() => AddMoneyController(), fenix: true);
    Get.lazyPut<KidGoalsController>(() => KidGoalsController(), fenix: true);
  }
}
