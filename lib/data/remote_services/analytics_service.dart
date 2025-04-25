import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:flutter/painting.dart';

class AnalyticsService extends GetxService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Role Selection Events
  Future<void> logRoleSelected(String role) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.roleSelected,
      parameters: {
        AnalyticsParameterNames.role: role,
      },
    );
  }

  // Auth Events
  Future<void> logSignUpAttempt(String email) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.signUpAttempt,
      parameters: {
        AnalyticsParameterNames.email: email,
      },
    );
  }

  Future<void> logSignUpSuccess(String email) async {
    await _analytics.logSignUp(signUpMethod: 'email');
    await _analytics.logEvent(
      name: AnalyticsEventNames.signUpSuccess,
      parameters: {
        AnalyticsParameterNames.email: email,
      },
    );
  }

  Future<void> logSignUpFailure(String email, String error) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.signUpFailure,
      parameters: {
        AnalyticsParameterNames.email: email,
        AnalyticsParameterNames.error: error,
      },
    );
  }

  Future<void> logSignUpValidationFailure(String email) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.signUpValidationFailure,
      parameters: {
        AnalyticsParameterNames.email: email,
      },
    );
  }

  // Goal Events
  Future<void> logGoalCreated(String goalId, double targetAmount) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.goalCreated,
      parameters: {
        AnalyticsParameterNames.goalId: goalId,
        AnalyticsParameterNames.targetAmount: targetAmount,
      },
    );
  }

  Future<void> logGoalCompleted(String goalId, double savedAmount) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.goalCompleted,
      parameters: {
        AnalyticsParameterNames.goalId: goalId,
        AnalyticsParameterNames.savedAmount: savedAmount,
      },
    );
  }

  // Jar Events
  Future<void> logJarCreated(String jarType) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.jarCreated,
      parameters: {
        AnalyticsParameterNames.jarType: jarType,
        AnalyticsParameterNames.screenName: AnalyticsScreenNames.kidHome,
      },
    );
  }

  Future<void> logJarCreationStarted(String jarType) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.jarCreationStarted,
      parameters: {
        AnalyticsParameterNames.jarType: jarType,
        AnalyticsParameterNames.screenName: AnalyticsScreenNames.kidHome,
      },
    );
  }

  Future<void> logMoneyAdded(String jarType, double amount) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.moneyAdded,
      parameters: {
        AnalyticsParameterNames.jarType: jarType,
        AnalyticsParameterNames.amount: amount,
      },
    );
  }

  // Screen tracking
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.screenView,
      parameters: {
        AnalyticsParameterNames.screenName: screenName,
        AnalyticsParameterNames.screenClass: screenClass ?? '',
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
  }

  // User Properties
  Future<void> setUserProperties({
    String? userRole,
    String? userId,
    int? userAge,
  }) async {
    if (userRole != null) {
      await _analytics.setUserProperty(name: 'user_role', value: userRole);
    }
    if (userId != null) {
      await _analytics.setUserId(id: userId);
    }
    if (userAge != null) {
      await _analytics.setUserProperty(name: 'user_age', value: userAge.toString());
    }
  }

  // Market Events
  Future<void> logProductView(String productId, String productName, double price) async {
    await _analytics.logViewItem(
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
  Future<void> logSignInAttempt(String email) async {
    await _analytics.logEvent(
      name: 'sign_in_attempt',
      parameters: {
        'method': 'email',
        'email': email,
      },
    );
  }

  Future<void> logSignInSuccess(String email) async {
    await _analytics.logEvent(
      name: 'sign_in_success',
      parameters: {
        'method': 'email',
        'email': email,
      },
    );
  }

  Future<void> logSignInFailure(String email, String error) async {
    await _analytics.logEvent(
      name: 'sign_in_failure',
      parameters: {
        'method': 'email',
        'email': email,
        'error': error,
      },
    );
  }

  Future<void> logGoogleSignInAttempt() async {
    await _analytics.logEvent(
      name: 'sign_in_attempt',
      parameters: {
        'method': 'google',
      },
    );
  }

  Future<void> logGoogleSignInSuccess() async {
    await _analytics.logEvent(
      name: 'sign_in_success',
      parameters: {
        'method': 'google',
      },
    );
  }

  Future<void> logGoogleSignInFailure(String error) async {
    await _analytics.logEvent(
      name: 'sign_in_failure',
      parameters: {
        'method': 'google',
        'error': error,
      },
    );
  }

  // Kid Onboarding Analytics
  Future<void> logOnboardingStepComplete(String stepName, {Map<String, dynamic>? parameters}) async {
    await _analytics.logEvent(
      name: 'onboarding_step_complete',
      parameters: {
        'step_name': stepName,
        ...?parameters,
      },
    );
  }

  Future<void> logOnboardingComplete() async {
    await _analytics.logEvent(
      name: 'onboarding_complete',
    );
  }

  // App Launch Analytics
  Future<void> logAppLaunch() async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.appLaunch,
      parameters: {
        AnalyticsParameterNames.screenName: 'splash_screen',
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logSplashScreenView({required bool isFirstLaunch}) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.splashScreenView,
      parameters: {
        AnalyticsParameterNames.screenName: 'splash_screen',
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
        AnalyticsParameterNames.screenName: 'intro_screen',
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
        AnalyticsParameterNames.screenName: 'intro_screen',
        AnalyticsParameterNames.action: action,
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
  }

  Future<void> logIntroComplete() async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.introComplete,
      parameters: {
        AnalyticsParameterNames.screenName: 'intro_screen',
        AnalyticsParameterNames.timestamp: DateTime.now().toIso8601String(),
      },
    );
  }

  // Navigation Analytics
  Future<void> logSplashNavigation(String destination, bool userExists) async {
    await _analytics.logEvent(
      name: AnalyticsEventNames.splashNavigation,
      parameters: {
        AnalyticsParameterNames.screenName: 'splash_screen',
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
        AnalyticsParameterNames.screenName: 'splash_screen',
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
}