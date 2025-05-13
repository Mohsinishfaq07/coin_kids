import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';

class AnalyticsController extends GetxController with WidgetsBindingObserver {
  final AnalyticsService _analytics = Get.find<AnalyticsService>();
  
  // Map to track screen view times
  final Map<String, DateTime> _screenStartTimes = <String, DateTime>{};
  
  // Current screen being viewed
  String? _currentScreen;
  
  @override
  void onInit() {
    super.onInit();
    // Register for app lifecycle events
    WidgetsBinding.instance.addObserver(this);
  }
  
  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App going to background - log current screen time
      _logCurrentScreenTime();
    } else if (state == AppLifecycleState.resumed) {
      // App coming to foreground - restart timer for current screen
      if (_currentScreen != null) {
        _screenStartTimes[_currentScreen!] = DateTime.now();
      }
    }
  }
  
  /// Track when a screen is opened
  void trackScreenView(String screenName) {
    // Log previous screen if exists
    _logCurrentScreenTime();
    
    // Set new current screen
    _currentScreen = screenName;
    _screenStartTimes[screenName] = DateTime.now();
    
    // Log screen view event
    FirebaseAnalytics.instance.logScreenView(screenName: screenName);
  }
  
  /// Log screen time for the current screen
  void _logCurrentScreenTime() {
    if (_currentScreen != null && _screenStartTimes.containsKey(_currentScreen!)) {
      final startTime = _screenStartTimes[_currentScreen!];
      final endTime = DateTime.now();
      final durationInSeconds = endTime.difference(startTime!).inSeconds;
      
      // Only log if duration is meaningful (more than 1 second)
      if (durationInSeconds > 1) {
        _analytics.screenTime(_currentScreen!, durationInSeconds.toString());
      }
      
      // Remove from tracking map
      _screenStartTimes.remove(_currentScreen);
    }
  }
  
  /// Call this when leaving a screen manually (if not using route observer)
  void trackScreenExit(String screenName) {
    if (_screenStartTimes.containsKey(screenName)) {
      final startTime = _screenStartTimes[screenName];
      final endTime = DateTime.now();
      final durationInSeconds = endTime.difference(startTime!).inSeconds;
      
      if (durationInSeconds > 1) {
        _analytics.screenTime(screenName, durationInSeconds.toString());
      }
      
      _screenStartTimes.remove(screenName);
      
      // If this was the current screen, clear it
      if (_currentScreen == screenName) {
        _currentScreen = null;
      }
    }
  }
  
  /// Manual tracking for dialogs and other non-route screens
  void trackDialogView(String dialogName) {
    FirebaseAnalytics.instance.logEvent(
      name: 'dialog_view',
      parameters: <String, Object>{
        'dialog_name': dialogName,
      },
    );
  }
  
  /// Track dialog dismissal with time spent
  void trackDialogDismissal(String dialogName, DateTime openTime) {
    final durationInSeconds = DateTime.now().difference(openTime).inSeconds;
    if (durationInSeconds > 1) {
      _analytics.logEvent(
        'dialog_dismissed',
        <String, Object>{
          'dialog_name': dialogName,
          'duration_seconds': durationInSeconds.toString(),
        },
      );
    }
  }
} 