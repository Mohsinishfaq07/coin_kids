import 'package:coin_kids/presentation/screens/common/forgot_password.dart';
import 'package:coin_kids/presentation/screens/common/intro/intro_screen.dart';
import 'package:coin_kids/presentation/screens/common/role_selection/role_selection_screen.dart';
import 'package:coin_kids/presentation/screens/common/sign_in/sign_in_screen.dart';
import 'package:coin_kids/presentation/screens/common/signup/signup_screen.dart';
import 'package:coin_kids/presentation/screens/common/splash/splash_screen.dart';
import 'package:coin_kids/presentation/screens/kid/base/kid_base_screen.dart';
import 'package:coin_kids/presentation/screens/kid/goals/goal_details_screen.dart';
import 'package:coin_kids/presentation/screens/kid/goals/goal_summary_screen.dart';
import 'package:coin_kids/presentation/screens/kid/goals/new_goal/add_goal_amount.dart';
import 'package:coin_kids/presentation/screens/kid/goals/new_goal/add_goal_image.dart';
import 'package:coin_kids/presentation/screens/kid/goals/new_goal/add_goal_name.dart';
import 'package:coin_kids/presentation/screens/kid/jars/Jar_color_selection_screen.dart';
import 'package:coin_kids/presentation/screens/kid/jars/add_money_screen.dart';
import 'package:coin_kids/presentation/screens/kid/jars/drag_and_drop_money_screen.dart';
import 'package:coin_kids/presentation/screens/kid/market/kid_wishlist_screen.dart';
import 'package:coin_kids/presentation/screens/kid/onboarding/kid_onboarding_screen.dart';
import 'package:coin_kids/presentation/screens/kid/transfer_between_jars/transfer_between_jars_screen.dart';
import 'package:coin_kids/presentation/screens/parent/add_child/add_child_screen.dart';
import 'package:coin_kids/presentation/screens/parent/drawer/parent_change_pin_screen.dart';
import 'package:coin_kids/presentation/screens/parent/drawer/parent_drawer_screen.dart';
import 'package:coin_kids/presentation/screens/parent/drawer/parent_feedback_screen.dart';
import 'package:coin_kids/presentation/screens/parent/drawer/update_parent_profile_screen.dart';
import 'package:coin_kids/presentation/screens/parent/edit_child/edit_child_screen.dart';
import 'package:coin_kids/presentation/screens/parent/kids_profile/kid_profile_screen.dart';
import 'package:coin_kids/presentation/screens/parent/market/parent_product_detail_screen.dart';
import 'package:coin_kids/presentation/screens/parent/market/parent_wishlist_screen.dart';
import 'package:coin_kids/presentation/screens/parent/messages_screen/messages_screen.dart';
import 'package:coin_kids/presentation/screens/parent/parent_base/parent_base_screen.dart';
import 'package:coin_kids/presentation/screens/parent/transfer/quick_transfer.dart';
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    //COMMON
    GetPage(name: Routes.splash, page: () => SplashScreen()),
    GetPage(name: Routes.intro, page: () => IntroScreen()),
    GetPage(name: Routes.signIn, page: () => SignInScreen()),
    GetPage(name: Routes.signUp, page: () => SignupScreen()),
    GetPage(name: Routes.roleSelection, page: () => RoleSelectionScreen()),
    GetPage(name: Routes.forgetPassword, page: () => ForgotPasswordScreen()),

    //Parents
    GetPage(name: Routes.parentBase, page: () => ParentBaseScreen()),
    GetPage(name: Routes.parentDrawer, page: () => ParentDrawer()),
    GetPage(name: Routes.parentEditProfile, page: () => UpdateParentProfile()),
    GetPage(name: Routes.parentKidProfile, page: () => KidProfileScreen()),
    GetPage(name: Routes.parentAddChild, page: () => AddChildScreen()),
    GetPage(name: Routes.parentUpdateChild, page: () => EditChildScreen()),
    GetPage(name: Routes.parentQuickTransfer, page: () => QuickTransferPage()),
    // GetPage(name: Routes.parentScheduleAllowances, page: () => ParentDrawer()),
    GetPage(name: Routes.parentWishlist, page: () => ParentWishlistScreen()),
    GetPage(name: Routes.parentProductDetails, page: () => ParentProductDetailScreen()),
    GetPage(name: Routes.parentChangePin, page: () => ParentChangePinScreen()),
    GetPage(name: Routes.parentFeedback, page: () => ParentFeedbackScreen()),
    GetPage(name: Routes.parentMessages, page: () => MessagesScreen()),

    //Kids
    GetPage(name: Routes.kidBase, page: () => KidBaseScreen()),
    GetPage(name: Routes.kidOnboarding, page: () => KidOnboardingScreen()),
    GetPage(name: Routes.kidDragAndDrop, page: () => DragAndDropMoneyScreen()),
    GetPage(name: Routes.kidWishlist, page: () => KidWishlistScreen()),
    GetPage(name: Routes.kidMoneyTransfer, page: () => TransferBetweenJarsScreen()),
    GetPage(name: Routes.kidMoneyAddOrRequest, page: () => AddMoneyScreen()),
    GetPage(name: Routes.kidAddGoalName, page: () => AddGoalNameScreen()),
    GetPage(name: Routes.kidAddGoalAmount, page: () => AddGoalAmountScreen()),
    GetPage(name: Routes.kidJarColorSelection, page: () => JarColorSelectionScreen()),
    GetPage(name: Routes.kidGoalSummary, page: () => GoalSummaryScreen()),
    GetPage(name: Routes.kidGoalDetailsScreen, page: () => GoalDetailsScreen()),
    GetPage(name: Routes.kidAddGoalImage, page: () => AddGoalImageScreen()),
  ];
}

class Routes {
  //Common
  static const splash = '/splash';
  static const intro = '/intro';
  static const signIn = '/signIn';
  static const signUp = '/signUp';
  static const roleSelection = '/roleSelection';
  static const forgetPassword = '/forgetPassword';

  //Parent
  static const parentBase = '/parentBaseScreen';
  static const parentDrawer = '/parentDrawer';
  static const parentEditProfile = '/parentEditProfile';
  static const parentKidProfile = '/parentKidProfile';
  static const parentAddChild = '/parentAddChild';
  static const parentUpdateChild = '/parentUpdateChild';
  static const parentQuickTransfer = '/parentQuickTransfer';
  static const parentScheduleAllowances = '/parentScheduleAllowances';
  static const parentWishlist = '/parentWishlist';
  static const parentProductDetails = '/parentProductDetails';
  static const parentChangePin = '/parentChangePin';
  static const parentFeedback = '/parentFeedback';
  static const parentMessages = '/parentMessages';

  //Kid
  static const kidBase = '/kidBase';
  static const kidOnboarding = '/kidOnboarding';
  static const kidDragAndDrop = '/kidDragAndDrop';
  static const kidWishlist = '/kidWishlist';
  static const kidMoneyTransfer = '/kidMoneyTransfer';
  static const kidMoneyAddOrRequest = '/kidMoneyAddOrRequest';
  static const kidAddGoalName = '/kidAddGoalName';
  static const kidAddGoalAmount = '/kidAddGoalAmount';
  static const kidAddGoalImage = '/kidAddGoalImage';
  static const kidJarColorSelection = '/kidJarColorSelection';
  static const kidGoalSummary = '/kidGoalSummary';
  static const kidGoalDetailsScreen = '/kidGoalDetailsScreen';
}
