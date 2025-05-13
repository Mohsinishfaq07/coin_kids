import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/presentation/controllers/common/analytics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenTrackingObserver extends NavigatorObserver {
  // Don't initialize immediately - get it lazily when needed
  AnalyticsController? _analyticsController;
  final Map<Route<dynamic>, String> _routeNameMap = {};
  
  // Lazy getter for analytics controller
  AnalyticsController get analyticsController {
    _analyticsController ??= Get.find<AnalyticsController>();
    return _analyticsController!;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    // Only track if controller is available
    if (Get.isRegistered<AnalyticsController>()) {
      _trackScreen(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (!Get.isRegistered<AnalyticsController>()) return;
    
    if (oldRoute != null) {
      _trackScreenExit(oldRoute);
    }
    if (newRoute != null) {
      _trackScreen(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (!Get.isRegistered<AnalyticsController>()) return;
    
    _trackScreenExit(route);
    if (previousRoute != null) {
      _trackScreen(previousRoute);
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    if (!Get.isRegistered<AnalyticsController>()) return;
    
    _trackScreenExit(route);
    if (previousRoute != null) {
      _trackScreen(previousRoute);
    }
  }

  void _trackScreen(Route<dynamic> route) {
    String? screenName = _getScreenName(route);
    if (screenName != null) {
      _routeNameMap[route] = screenName;
      analyticsController.trackScreenView(screenName);
    }
  }

  void _trackScreenExit(Route<dynamic> route) {
    String? screenName = _routeNameMap[route];
    if (screenName != null) {
      analyticsController.trackScreenExit(screenName);
      _routeNameMap.remove(route);
    }
  }

  String? _getScreenName(Route<dynamic> route) {
    // Try to get name from route settings
    if (route.settings.name != null) {
      return route.settings.name;
    }
    
    // If route settings name is null, try to get it from the route's widget
    if (route is MaterialPageRoute) {
      return route.builder.runtimeType.toString();
    }
    
    if (route is GetPageRoute) {
      return route.routeName;
    }
    
    return null;
  }
} 