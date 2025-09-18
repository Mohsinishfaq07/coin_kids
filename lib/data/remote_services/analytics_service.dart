import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:flutter/painting.dart';

class AnalyticsService extends GetxService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Role Selection Events
  Future<void> logRoleSelected(String role, String screen, String nextScreen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.roleSelected,
      parameters: {
        AnalyticsParameterNames.role: role,
        AnalyticsParameterNames.screenName: screen,
        AnalyticsParameterNames.nextScreenName: nextScreen
      },
    );
  }
  Future<void> logGoalCreatedSuccessfully(String goalId, String goalTitle, double targetAmount, String screen) async {
    print('🔥 ANALYTICS: Logging goal created successfully');
    print('📊 Goal ID: $goalId');
    print('📊 Goal Title: $goalTitle');
    print('📊 Target Amount: $targetAmount');
    print('📊 Screen: $screen');

    await _analytics.logEvent(
      name: AnalyticsEventNames.goalCreatedSuccessfully,
      parameters: {
        AnalyticsParameterNames.goalId: goalId,
        AnalyticsParameterNames.productName: goalTitle, // Using productName for goal title
        AnalyticsParameterNames.targetAmount: targetAmount,
        AnalyticsParameterNames.screenName: screen,
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
    print('✅ ANALYTICS: Goal created successfully logged');
  }

  Future<void> logGoalCreatedFromWishlist(String goalId, String goalTitle, double targetAmount, String productId, String productName, double productPrice, String screen) async {
    print('🔥 ANALYTICS: Logging goal created from wishlist');
    print('📊 Goal ID: $goalId');
    print('📊 Goal Title: $goalTitle');
    print('📊 Target Amount: $targetAmount');
    print('📊 Product ID: $productId');
    print('📊 Product Name: $productName');
    print('📊 Product Price: $productPrice');
    print('📊 Screen: $screen');

    await _analytics.logEvent(
      name: AnalyticsEventNames.goalCreatedFromWishlist,
      parameters: {
        AnalyticsParameterNames.goalId: goalId,
        AnalyticsParameterNames.productName: goalTitle,
        AnalyticsParameterNames.targetAmount: targetAmount,
        AnalyticsParameterNames.productId: productId,
        'wishlist_product_name': productName,
        'wishlist_product_price': productPrice,
        AnalyticsParameterNames.screenName: screen,
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
    print('✅ ANALYTICS: Goal created from wishlist logged');
  }

  // Auth Events
  Future<void> logSignUpAttempt(String screen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.signUpAttempt,
      parameters: {AnalyticsParameterNames.screenName: screen},
    );
  }

  Future<void> logSignUpSuccess(
    String email,
    String screen,
  ) async {
    await _analytics.logSignUp(signUpMethod: 'email');
    await _analytics.logEvent(
      name: AnalyticsEventNames.signUpSuccess,
      parameters: {
        AnalyticsParameterNames.email: email,
        AnalyticsParameterNames.screenName: screen,
      },
    );
  }

  Future<void> logSignUpFailure(String error, String screen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.signUpFailure,
      parameters: {
        AnalyticsParameterNames.screenName: screen,
        AnalyticsParameterNames.error: error,
      },
    );
  }

  Future<void> logSignUpValidationFailure(String screen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.signUpValidationFailure,
      parameters: {
        AnalyticsParameterNames.screenName: screen,
      },
    );
  }

  // Goal Events
  Future<void> logGoalCreated(String goalId, double targetAmount, String screen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.goalCreated,
      parameters: {
        AnalyticsParameterNames.goalId: goalId,
        AnalyticsParameterNames.targetAmount: targetAmount,
        AnalyticsParameterNames.screenName: screen
      },
    );
  }

  Future<void> logGoalCompleted(String goalId, double savedAmount, String screen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.goalCompleted,
      parameters: {
        AnalyticsParameterNames.goalId: goalId,
        AnalyticsParameterNames.savedAmount: savedAmount,
        AnalyticsParameterNames.screenName: screen
      },
    );
  }

  // Jar Events
  Future<void> logJarCreated(String jarType, String screen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.jarCreated,
      parameters: {
        AnalyticsParameterNames.jarType: jarType,
        AnalyticsParameterNames.screenName: screen,
      },
    );
  }

  Future<void> logJarCreationStarted(String jarType, String screen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.jarCreationStarted,
      parameters: {AnalyticsParameterNames.jarType: jarType, AnalyticsParameterNames.screenName: screen},
    );
  }

  Future<void> logMoneyAdded(String jarType, double amount, String screen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.moneyAdded,
      parameters: {AnalyticsParameterNames.jarType: jarType, AnalyticsParameterNames.amount: amount, AnalyticsParameterNames.screenName: screen},
    );
  }

  // Screen tracking
  // Future<void> logScreenView({
  //   required String screenName,
  //   String? screenClass,
  // }) async {
  //   await _analytics.logEvent(
  //     name: AnalyticsEventNames.screenView,
  //     parameters: {
  //       AnalyticsParameterNames.screenName: screenName,
  //       AnalyticsParameterNames.screenClass: screenClass ?? '',
  //       AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
  //     },
  //   );
  // }

  // User Properties
  // Future<void> setUserProperties({
  //   String? userRole,
  //   String? userId,
  //   int? userAge,
  // }) async {
  //   if (userRole != null) {
  //     await _analytics.setUserProperty(name: 'user_role', value: userRole);
  //   }
  //   if (userId != null) {
  //     await _analytics.setUserId(id: userId);
  //   }
  //   if (userAge != null) {
  //     await _analytics.setUserProperty(name: 'user_age', value: userAge.toString());
  //   }
  // }

  // Market Events
  // Future<void> logProductView(String productId, String productName, double price) async {
  //   await _analytics.logViewItem(
  //     items: [
  //       AnalyticsEventItem(
  //         itemId: productId,
  //         itemName: productName,
  //         price: price,
  //       ),
  //     ],
  //     currency: 'EUR',
  //   );
  // }

  Future<void> logAddToWishlist(String productId, String productName, double price) async {
    await _analytics.logAddToWishlist(
      items: [
        AnalyticsEventItem(
          itemId: productId,
          itemName: productName,
          price: price,
        ),
      ],
      currency: 'EUR',
    );
  }

  // Sign-in analytics

  Future<void> logSignInSuccess(String email, String screen, String previousScreen, String nextScreen) async {
    await _analytics.logLogin(loginMethod: AnalyticsParameterNames.email);
    await _analytics.logEvent(
      name: AnalyticsEventNames.signInSuccess,
      parameters: {
        AnalyticsParameterNames.email: email,
        AnalyticsParameterNames.screenName: screen,
        AnalyticsParameterNames.previousScreen: previousScreen,
        AnalyticsParameterNames.nextScreenName: nextScreen,
      },
    );
  }

  Future<void> logSignInFailure(String error, String screen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.signInValidationFailure,
      parameters: {'error': error, AnalyticsParameterNames.screenName: screen},
    );
  }

  Future<void> logGoogleSignInAttempt(String screen) async {
    await _analytics.logLogin(loginMethod: 'google');
    await _analytics.logEvent(
      name: AnalyticsEventNames.signInAttempt,
      parameters: {'method': 'google', AnalyticsParameterNames.screenName: screen},
    );
  }

  Future<void> logGoogleSignInSuccess(String screen, String userType) async {
    await _analytics.logSignUp(signUpMethod: AnalyticsParameterNames.google);
    await _analytics.logEvent(
      name: AnalyticsEventNames.signInSuccess,
      parameters: {
        AnalyticsParameterNames.signInMethod: AnalyticsParameterNames.google,
        AnalyticsParameterNames.screenName: screen,
        AnalyticsParameterNames.userType: userType
      },
    );
  }

  Future<void> screenTime(String screen, String durationInSeconds) async {
    final String deviceLocale = Get.deviceLocale?.languageCode ?? 'en';
    await _analytics.logEvent(
      name: AnalyticsEventNames.screenTimeSpent,
      parameters: {
        AnalyticsParameterNames.screenName: screen,
        AnalyticsParameterNames.screenTime: durationInSeconds,
      },
    );
    await FirebaseAnalytics.instance.setUserProperty(
      value: deviceLocale,
      name: AnalyticsEventNames.userLanguage,
    );
  }

  Future<void> logGoogleSignInFailure(String error, String screen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.signInFailure,
      parameters: {
        AnalyticsParameterNames.screenName: screen,
        'method': 'google',
        'error': error,
      },
    );
  }

  // App Launch Analytics
  Future<void> logAppLaunch() async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.appLaunch,
      parameters: {
        AnalyticsParameterNames.screenName: AnalyticsScreenNames.splash,
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logSplashScreenView({required bool isFirstLaunch}) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.splashScreenView,
      parameters: {
        AnalyticsParameterNames.screenName: AnalyticsScreenNames.splash,
        AnalyticsParameterNames.isFirstLaunch: isFirstLaunch,
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
  }

  // Intro/Onboarding Analytics
  Future<void> logIntroPageView(int pageIndex, String pageTitle) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.introPageView,
      parameters: {
        AnalyticsParameterNames.screenName: AnalyticsScreenNames.intro,
        AnalyticsParameterNames.pageIndex: pageIndex,
        AnalyticsParameterNames.pageTitle: pageTitle,
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logIntroAction(String action) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.introAction,
      parameters: {
        AnalyticsParameterNames.screenName: AnalyticsScreenNames.intro,
        AnalyticsParameterNames.action: action,
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logIntroComplete() async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.introComplete,
      parameters: {
        AnalyticsParameterNames.screenName: AnalyticsScreenNames.intro,
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
  }

  // Navigation Analytics
  Future<void> logSplashNavigation(String destination, bool userExists) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.splashNavigation,
      parameters: {
        AnalyticsParameterNames.screenName: AnalyticsScreenNames.splash,
        AnalyticsParameterNames.destination: destination,
        'user_exists': userExists,
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logSplashError(String error) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.splashError,
      parameters: {
        AnalyticsParameterNames.screenName: AnalyticsScreenNames.splash,
        AnalyticsParameterNames.error: error,
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
  }

  // Money Addition Analytics
  Future<void> logMoneyAddNextClicked(String mode, double amount) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.moneyNextClicked,
      parameters: {
        AnalyticsParameterNames.screenName: AnalyticsScreenNames.kidAddMoney,
        AnalyticsParameterNames.mode: mode,
        AnalyticsParameterNames.amount: amount,
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logMoneyAddValidationFailure(String reason) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.moneyAddValidationFailure,
      parameters: {
        AnalyticsParameterNames.screenName: AnalyticsScreenNames.kidAddMoney,
        AnalyticsParameterNames.validationReason: reason,
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logMoneyRequestSent(double amount) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.moneyRequestSent,
      parameters: {
        AnalyticsParameterNames.screenName: AnalyticsScreenNames.kidAddMoney,
        AnalyticsParameterNames.amount: amount,
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logMoneyRequestFailure(String error) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.moneyRequestFailure,
      parameters: {
        AnalyticsParameterNames.screenName: AnalyticsScreenNames.kidAddMoney,
        AnalyticsParameterNames.error: error,
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logMoneyAddBackClicked(String mode) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.moneyAddBackClicked,
      parameters: {
        AnalyticsParameterNames.screenName: AnalyticsScreenNames.kidAddMoney,
        AnalyticsParameterNames.mode: mode,
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
  }

  // Jar Color Selection Analytics
  Future<void> logJarColorSelected(String jarType, int colorIndex, Color selectedColor) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.jarColorSelected,
      parameters: {
        AnalyticsParameterNames.screenName: AnalyticsScreenNames.kidJarColorSelection,
        AnalyticsParameterNames.jarType: jarType,
        AnalyticsParameterNames.colorIndex: colorIndex,
        AnalyticsParameterNames.selectedColor: selectedColor.value.toString(),
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logJarColorSelectionBackClicked(String jarType) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.jarColorSelectionBackClicked,
      parameters: {
        AnalyticsParameterNames.screenName: AnalyticsScreenNames.kidJarColorSelection,
        AnalyticsParameterNames.jarType: jarType,
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logJarColorSelectionNextClicked(String jarType, bool isConnected, double balance) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.jarColorSelectionNextClicked,
      parameters: {
        AnalyticsParameterNames.screenName: AnalyticsScreenNames.kidJarColorSelection,
        AnalyticsParameterNames.jarType: jarType,
        AnalyticsParameterNames.isConnected: isConnected,
        AnalyticsParameterNames.amount: balance,
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logSignInAttempt(String screen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.signInAttempt,
      parameters: {AnalyticsParameterNames.screenName: screen},
    );
  }

  Future<void> logDrawerClick(String screen, String previousScreen, String nextScreen) async {
    await _analytics.getSessionId();
    print("sessionId${_analytics.getSessionId()}");
    await _analytics.logEvent(
      name: AnalyticsEventNames.drawerButtonClicked,
      parameters: {
        AnalyticsParameterNames.screenName: screen,
        AnalyticsParameterNames.previousScreen: previousScreen,
        AnalyticsParameterNames.nextScreenName: nextScreen
      },
    );
  }

  Future<void> logAddChildAttempt(String screen, String previousScreen, String nextScreen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.addChildAttemptClicked,
      parameters: {
        AnalyticsParameterNames.screenName: screen,
        AnalyticsParameterNames.previousScreen: previousScreen,
        AnalyticsParameterNames.nextScreenName: nextScreen
      },
    );
  }

  Future<void> logQuickTransferButtonClick(String screen, String nextScreen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.quickTransferButtonClicked,
      parameters: {AnalyticsParameterNames.screenName: screen, AnalyticsParameterNames.nextScreenName: nextScreen},
    );
  }

  Future<void> logAlreadyAddedChildAttempt(String screen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.alreadyAddChildClicked,
      parameters: {AnalyticsParameterNames.screenName: screen},
    );
  }

  Future<void> logKidProfileClicked(String screen, String nextScreen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.kidProfileClicked,
      parameters: {AnalyticsParameterNames.screenName: screen, AnalyticsParameterNames.nextScreenName: nextScreen},
    );
  }

  Future<void> logAddChildClickSuccessFull(String screen) async {
    print("sessionId${_analytics.getSessionId()}");
    await _analytics.logEvent(
      name: AnalyticsEventNames.addChildSuccessfulClicked,
      parameters: {AnalyticsParameterNames.screenName: screen},
    );
  }

  Future<void> logAddChildFailures(String screen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.addChildFailed,
      parameters: {AnalyticsParameterNames.screenName: screen},
    );
  }

  Future<void> logAddChildDiscard(String screen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.addChildDiscard,
      parameters: {AnalyticsParameterNames.screenName: screen},
    );
  }

  Future<void> logParentHomeTabClicked(String screen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.parentHomeTabClicked,
      parameters: {AnalyticsParameterNames.screenName: screen},
    );
  }

  Future<void> logParentNotificationTabClicked(String screen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.parentNotificationTabClicked,
      parameters: {AnalyticsParameterNames.screenName: screen},
    );
  }

  Future<void> logSwitchToKidZoneClicked(String screen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.parentKidZoneTabClicked,
      parameters: {AnalyticsParameterNames.screenName: screen},
    );
  }

  Future<void> logParentMarketClicked(String screen) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.parentMarketTabClicked,
      parameters: {AnalyticsParameterNames.screenName: screen},
    );
  }

  Future<void> backPressClicked(String screen, [String? nextScreen]) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.backButtonClicked,
      parameters: {AnalyticsParameterNames.screenName: screen,
        if (nextScreen != null) 'next_screen': nextScreen,},
    );
  }

  Future<void> buttonClicked(String eventName, String screen, [String? nextScreen]) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: {AnalyticsParameterNames.screenName: screen,
        if (nextScreen != null) 'next_screen': nextScreen,
      },
    );
  }

  Future<void> logEvent(
    String name, 
    Map<String, Object> parameters,
  ) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }
}
