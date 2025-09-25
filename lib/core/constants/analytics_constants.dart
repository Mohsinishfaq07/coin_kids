class AnalyticsEventNames {
  // App Launch Events
  static const String appLaunch = 'app_launch';
  static const String splashScreenView = 'splash_screen_view';
  static const String splashNavigation = 'splash_navigation';
  static const String splashError = 'splash_error';

  static const String goalCreatedSuccessfully = 'goal_created_successfully';
  static const String goalCreatedFromWishlist = 'goal_created_wishlist';
  static const String marketProductDetailAddToGoalClicked ='goal_created_store';


  // Intro/Onboarding Events
  static const String introPageView = 'intro_page_view';
  static const String introAction = 'intro_action';
  static const String introComplete = 'intro_complete';
  static const String screenView = 'screen_view';
  static const String screenTimeSpent = 'screen_time';

  // Auth Events
  static const String signUpAttempt = 'sign_up_attempt';
  static const String signUpSuccess = 'sign_up_success';
  static const String signUpFailure = 'sign_up_failure';
  static const String signUpValidationFailure = 'sign_up_validation_failure';

  // Sign In Events
  static const String signInAttempt = 'sign_in_attempt';
  static const String signInSuccess = 'sign_in_success';
  static const String signInFailure = 'sign_in_failure';
  static const String signInValidationFailure = 'sign_in_validation_failure';
  static const String signInWithGoogle = 'sign_in_with_google';

  // Role Selection Events
  static const String roleSelected = 'role_selected';

  // Kid Onboarding Events
  // static const String kidOnBoardingSteps = 'kid_onboarding_steps';
  static const String kidOnBoardingNameStepsClicked = 'kid_onboarding_name_steps';
  static const String kidOnBoardingAgeStepsClicked = 'kid_onboarding_age_steps';
  static const String kidOnBoardingAvatarClicked = 'kid_onboarding_image_steps';

  // Goal Events
  static const String goalCreated = 'goal_created';
  static const String goalCompleted = 'goal_completed';

  static const String goalDetailClicked = 'goal_detail_clicked';

  // Jar Events
  static const String jarCreated = 'jar_created';
  static const String moneyAdded = 'money_added';
  static const String jarCreationAttempt = 'jar_creation_attempt';
  static const String jarCreationValidationFailure = 'jar_creation_validation_failure';
  static const String jarCreationStarted = 'jar_creation_started';
  static const String jarColorSelected = 'jar_color_selected';
  static const String jarColorSelectionBackClicked = 'jar_color_selection_back_clicked';
  static const String jarColorSelectionNextClicked = 'jar_color_selection_next_clicked';

  // Money Events
  static const String moneyNextClicked = 'money_add_next_clicked';
  static const String moneyAddValidationFailure = 'money_add_validation_failure';
  static const String moneyRequestSent = 'money_request_sent';
  static const String moneyRequestFailure = 'money_request_failure';
  static const String moneyAddBackClicked = 'money_add_back_clicked';

  //drawer
  static const String drawerButtonClicked = 'drawer_button_clicked';
  // add child
  static const String addChildAttemptClicked = 'add_child_attempt_clicked';
  static const String addChildSuccessfulClicked = 'add_child_successful_clicked';
  static const String addChildFailed = 'add_child_failed';
  static const String addChildDiscard = 'add_child_discard';
  static const String alreadyAddChildClicked = 'already_added_child';
  static const String kidProfileClicked = 'kid_profile_clicked';
  static const String parentHomeTabClicked = 'parent_home_tab_clicked';
  static const String parentNotificationTabClicked = 'parent_notification_tab_clicked';
  static const String parentMarketTabClicked = 'parent_market_tab_clicked';
  static const String parentKidZoneTabClicked = 'parent_kid_zone_tab_clicked';
  static const String backButtonClicked = "back_button_clicked";
  static const String sendMoneyButtonClicked = "pt_clicked_send_money";
  static const String removeMoneyButtonClicked= "pt_clicked_remove_money";
  static const String quickTransferButtonClicked= "quick_transfer_button_clicked";
  static const String scheduleAllowanceButtonClicked= "schedule_allowance_button_clicked";
  static const String kidEditProfileClicked= "kid_edit_profile_button_clicked";
  static const String jarsTabClicked= "jar_tab_clicked";
  static const String goalsTabClicked= "goal_tab_clicked";
  static const String goalsRefreshClicked= "goal_refresh_clicked";
  static const String saveKidProfileClicked= "save_kid_profile_clicked";

  static const String parentMessageRefreshClicked = 'parent_message_refresh_clicked';
  static const String messageSeeDetailsClicked = 'message_see_details_clicked';
  static const String goalApproveClicked = 'goal_approve_clicked';
  static const String goalRejectClicked = 'goal_reject_clicked';
  static const String productDetailClicked = 'product_detail_clicked';
  static const String parentWishlistIconClicked = 'pt_wishlist_icon_clicked';
  static const String parentWishlistClicked = 'pt_wishlist_clicked';
  static const String parentDrawerBackButtonClicked = 'pt_drawer_back_clicked';
  static const String parentLogoutClicked = 'pt_logout_clicked';
  static const String privacyPolicyClicked = 'privacy_policy_clicked';
  static const String feedbackClicked = 'feed_back_clicked';
  static const String shareAppClicked = 'share_app_clicked';
  static const String parentEditClicked = 'parent_edit_clicked';
  static const String parentImagePickerClicked = 'parent_image_picker_clicked';
  static const String updateParentProfileClicked = 'update_parent_profile_clicked';
  //kid side
  static const String kidHomeNavigationClicked = 'kd_clk_button_home';
  static const String kidGoalsNavigationClicked = 'kd_clk_button_goal';
  static const String kidMarketNavigationClicked = 'kd_clk_button_shop';


  static const String kidMoneyJarCreatedClicked = 'spending_jar_creation_clicked';
  static const String kidSavingJarCreatedClicked = 'saving_jar_creation_clicked';


  static const String kidMoneyJarClicked = 'spending_jar_clicked';
  static const String kidSavingJarClicked = 'saving_jar_clicked';

  static const String kidTransferButtonClicked = 'kid_transfer_button_clicked';
  static const String switchToParentClicked = 'switch_to_parent_clicked';

  static const String noGoalClicked = 'switch_to_parent_clicked';
  static const String goalNameScreenClicked = 'goal_name_screen_clicked';

  static const String goalNameNextButtonClicked = 'goal_name_next_button_clicked';
  static const String goalAmountNextButtonClicked ='goal_amount_next_button_clicked';
  static const String goalImageNextButtonClicked ='goal_image_next_button_clicked';
  static const String goalMinusButtonClicked ='goal_minus_button_clicked';
  static const String goalPlusButtonClicked ='goal_plus_button_clicked';
  static const String goalProgressSliderClicked ='goal_progress_slider_button_clicked';
  static const String goalProgressEditButtonClicked ='goal_progress_edit_button_clicked';
  static const String goalProgressDeleteButtonClicked ='goal_progress_delete_button_clicked';
  static const String goalProgressDoneButtonClicked ='goal_progress_done_button_clicked';
  static const String marketAllFilterClicked ='goal_market_all_filter_clicked';
  static const String marketAgeFilterClicked ='goal_market_age_filter_clicked';
  static const String marketBudgetFilterClicked ='goal_market_budget_filter_clicked';
  static const String marketRatingsFilterClicked ='goal_market_ratings_filter_clicked';
  static const String marketProductCardClicked ='goal_market_product_card_clicked';
  static const String marketProductAddToWishlistClicked ='goal_progress_add_to_wishlist_clicked';
  static const String marketProductWishlistScreenClicked ='goal_progress_wishlist_navigation_clicked';
  // market detail
  static const String marketProductDetailCrossClicked ='goal_product_detail_cross_clicked';
  static const String marketProductDetailAmazonCardClicked ='goal_product_detail_amazon_clicked';
  ///wishlist screen events

  static const String wishlistProductDetailClicked ='wishlist_product_detail_clicked';

  //
  static const String addOrRequestMoneyNextButtonClickedClicked ='wishlist_product_detail_clicked';
  static const String userLanguage ='user_language';

  // Video Player Events
  static const String videoSkipped = 'video_skipped';
  static const String videoCompleted = 'video_completed';




  // new events
  static const String signupGoogle = 'signup_method_google';
  static const String signupApple = 'signup_method_apple';
  static const String signupForm = 'signup_form_completed';

  static const String kidProfileCreated = 'kd_created_profile_successful';
  static const String kidJarCreated = 'kd_created_jar_successful';
  static const String kidClickHomeButton = 'kd_clk_button_home';
  static const String kidClickGoalButton = 'kd_clk_button_goal';
  static const String kidClickShopButton = 'kd_clk_button_shop';
  static const String kidClickAgeButton = 'kd_enter_age';
  static const String kidClickEnterNameButton = 'kd_enter_name';
  static const String kidClickRequestMoney = 'kd_clk_button_request_money';
  static const String kidClickParentZoneButton = 'kd_clk_button_parent_zone';

  static const String userTypeChooseButtonParent = 'user_type_chosen_parent';
  static const String userTypeChooseButtonKid = 'user_type_chosen_kid';

  static const String parentClickQuickTransferHome = 'pt_clk_quickTransfer_home';
  static const String parentClickQuickTransfer = 'pt_clk_quickTransfer';
  static const String parentClickShopButton = 'pt_clk_shop_button_home';
  static const String parentClickMessageButton = 'pt_clk_message_button_home';
  static const String parentClickKidZone = 'pt_clk_kidZone';
  static const String parentClickKidProfile = 'pt_clk_kid_profile';
  static const String parentClickAffiliateLink = 'parent_clicked_affiliatelink_shop';
   static const String kidClickGoalCreatedButton = 'kd_clk_create_goal_button';
  static const String kidClickGoalCreatedShopButton = 'kd_clk_create_goal_button_shop';

  static const String parentViewShopPage = 'pt_viewed_shop_page';
  static const String parentViewMessagePage = 'pt_viewed_messages_page';
  static const String parentViewKidProfilePage = 'pt_viewed_kid_profile_page';

  static const String parentClickApproveGoal = 'pt_clicked_approve_goal';









}

class AnalyticsParameterNames {
  // Role Selection
  static const String role = 'role';
  static const String roleParent = 'pt';
  static const String roleChild = 'kd';

  // Auth
  static const String email = 'email';
  static const String error = 'error';

  //user type
  static const String userType = 'user_type';

  // Goals
  static const String goalId = 'goal_id';
  static const String goalTitle = 'goal_title';
  static const String targetAmount = 'target_amount';
  static const String savedAmount = 'saved_amount';

  // Jars
  static const String jarType = 'jar_type';
  static const String amount = 'amount';
  static const String isConnected = 'is_connected';
  static const String hasBalance = 'has_balance';
  static const String validationReason = 'validation_reason';
  static const String selectedColor = 'selected_color';
  static const String colorIndex = 'color_index';

  // Products
  static const String productId = 'product_id';
  static const String productName = 'product_name';
  static const String price = 'price';

  // Screen Parameters
  static const String screenName = 'screen_name';
  static const String previousScreen = 'from_screen';
  static const String nextScreenName = 'to_screen';
  static const String screenTime = 'screen_time';
  static const String screenClass = 'screen_class';
  static const String timestamp = 'timestamp';
  static const String pageIndex = 'page_index';
  static const String pageTitle = 'page_title';
  static const String action = 'action';
  static const String destination = 'destination';
  static const String isFirstLaunch = 'is_first_launch';
  static const String userLanguage = 'user_language';

// new perameters
  static const String signInMethod = 'sign_in_method';
  static const String signInGoogle = "google_signup";
  static const String signInApple = "apple_signup";
  static const String signUpFormCompleted = "form_completed_signup";
  static const String kidProfileCreated = 'kid_profile_created';







  // Money Parameters
  static const String mode = 'mode';
}

class AnalyticsScreenNames {
  // Auth Screens
  static const String splash = 'splash_screen';
  static const String intro = 'intro_screen';
  static const String signIn = 'sign_in_screen';
  static const String signUp = 'sign_up_screen';
  static const String roleSelection = 'role_selection_screen';

  // Kid Onboarding Screens
  static const String kidOnboardingNameScreen = 'kid_onboarding_name_screen';
  static const String kidOnboardingAgeScreen = 'kid_onboarding_age_screen';
  static const String kidOnboardingAvatarScreen = 'kid_onboarding_avatar_screen';

  // Kid Main Screens
  static const String kidBaseScreen = 'kid_base_screen';
  static const String kidHomeScreen = 'kid_home_screen';
  static const String kidGoalsScreen = 'kid_goals_screen';
  static const String kidMarketScreen = 'kid_market_screen';


  //kid goal screen
  static const String kidGoalsNameScreen = 'kid_goals_name_screen';
  static const String kidNameScreen = 'kid_name_screen';
  static const String kidAgeScreen = 'kid_age_screen';
  static const String kidGoalsAmountScreen = 'kid_goals_amount_screen';
  static const String kidGoalsImageScreen = 'kid_goals_image_screen';
  static const String kidGoalsSummaryScreen = 'kid_goals_summary_screen';
  static const String kidGoalsProgressScreen = 'kid_goals_progress_screen';
  static const String kidGoalCreateScreen = 'kid_goals_create_screen';
  static const String kidGoalCreateShop = 'kid_goals_create_shop';
  static const String kidNoGoalScreen = 'kid_no_goal_screen';
  static const String kidWishlistScreen = 'kid_wishlist_screen';
  static const String kidAddMoney = 'kid_add_money_screen';
  static const String kidJarColorSelection = 'kid_jar_color_screen';
  static const String kidJarAmountScreen = 'kid_jar_amount_screen';
  static const String kidTransferAmountScreen = 'kid_transfer_amount_screen';
  //kid market
  static const String kidMarketProductDetailScreenDialog = 'kid_market_product_detail_screen_dialog';
  //wishlist
  static const String wishlistProductDetailScreenDialog = 'wishlist_product_detail_screen_dialog';

//add or request money
  static const String addOrRequestMoney = 'add_or_requestMoney_screen';


  // Parent Main Screens
  static const String parentBase = 'parent_base_screen';
  static const String parentHome = 'parent_home_screen';
  static const String parentMarket = 'parent_market_screen';
  static const String parentWishlist = 'parent_wishlist_screen';
  static const String parentMessageScreen = 'parent_message_screen';
  static const String parentProfile = 'parent_profile_screen';
  static const String parentAddKidScreen = 'parent_add_kid_screen';
  static const String parentQuickTransferScreen = 'parent_Quick_transfer_screen';
  static const String kidProfileScreen = 'kid_profile_screen';
  static const String productDetailScreen = 'product_detail_screen';
  static const String kidEditProfileScreen = 'kid_edit_profile_screen';
  static const String parentDrawerScreen = 'parent_drawer_screen';
  static const String parentChangePinScreen = 'parent_change_pin_screen';
  static const String parentChangeLanguageScreen = 'parent_change_language_screen';
  static const String parentForgotPasswordScreen = 'parent_forgot_password_screen';






}
