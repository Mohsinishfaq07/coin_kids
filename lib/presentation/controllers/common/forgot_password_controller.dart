import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final authService = Get.find<AuthService>();
  final analytics = Get.find<AnalyticsService>();

  final email = ''.obs;
  DateTime? _screenStartTime;
  @override
  void onInit() {
    super.onInit();
    _screenStartTime = DateTime.now();
    logScreenTime();
  }

  @override
  void onClose() {
    logScreenTime();
    super.onClose();
  }

  Future<void> logScreenTime() async {
    if (_screenStartTime != null) {
      final endTime = DateTime.now();
      final durationInSeconds = endTime.difference(_screenStartTime!).inSeconds;
      analytics.screenTime(AnalyticsScreenNames.parentForgotPasswordScreen,durationInSeconds.toString());
    }
    FirebaseAnalytics.instance.logScreenView(
      screenName: AnalyticsScreenNames.parentForgotPasswordScreen,
    );
  }

}
