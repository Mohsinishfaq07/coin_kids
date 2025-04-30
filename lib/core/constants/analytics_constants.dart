class AnalyticsEventNames {
  // App Launch Events
  static const String appLaunch = 'app_launch';
  static const String splashScreenView = 'splash_screen_view';
  static const String splashNavigation = 'splash_navigation';
  static const String splashError = 'splash_error';

  // Intro/Onboarding Events
  static const String introPageView = 'intro_page_view';
  static const String introAction = 'intro_action';
  static const String introComplete = 'intro_complete';
  static const String screenView = 'screen_view';

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
  static const String kidOnBoardingSteps = 'kid_onboarding_steps';
  static const String kidOnBoardingComplete = 'kid_onboarding_complete';

  // Goal Events
  static const String goalCreated = 'goal_created';
  static const String goalCompleted = 'goal_completed';

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
  static const String sendMoneyButtonClicked = "send_button_clicked";
  static const String removeMoneyButtonClicked= "remove_button_clicked";
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
}

class AnalyticsParameterNames {
  // Role Selection
  static const String role = 'role';
  static const String roleParent = 'pt';
  static const String roleChild = 'kd';

  // Auth
  static const String email = 'email';
  static const String error = 'error';
  static const String signInMethod = 'sign_in_method';

  // Goals
  static const String goalId = 'goal_id';
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
  static const String screenClass = 'screen_class';
  static const String timestamp = 'timestamp';
  static const String pageIndex = 'page_index';
  static const String pageTitle = 'page_title';
  static const String action = 'action';
  static const String destination = 'destination';
  static const String isFirstLaunch = 'is_first_launch';

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
  static const String kidOnboardingName = 'kid_onboarding_name_screen';
  static const String kidOnboardingAge = 'kid_onboarding_age_screen';
  static const String kidOnboardingAvatar = 'kid_onboarding_avatar_screen';

  // Kid Main Screens
  static const String kidBase = 'kid_base_screen';
  static const String kidHome = 'kid_home_screen';
  static const String kidGoals = 'kid_goals_screen';
  static const String kidMarket = 'kid_market_screen';
  static const String kidWishlist = 'kid_wishlist_screen';
  static const String kidAddMoney = 'kid_add_money_screen';
  static const String kidJarColorSelection = 'kid_jar_color_selection_screen';

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
  static const String parentDrawerScreen = 'parent_drawer_screen';
}
