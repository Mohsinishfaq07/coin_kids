import 'dart:ui';

import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

class JarCreationController extends GetxController {

  var selectedColorIndex = 0.obs;
  var jarType = Jars.spendingJar;
  final amount = 0.0.obs;
  final analytics = Get.find<AnalyticsService>();

  final List<Color> colors = [
    const Color(0xFFFF6060),
    const Color(0xFF8F60FF),
    const Color(0xFFE360FF),
    const Color(0xFFFEC61C),
    const Color(0xFF434343),
    const Color(0xFFFF9500),
    const Color(0xFF4CAF50),
    const Color(0xFF3F89FC),
    const Color(0xFF3FD9FC),
    const Color(0xFF4BD1C5),
    const Color(0xFFFF60C4),
    const Color(0xFF3F51FC),
  ];
  final appState = Get.find<AppStateController>();
  final kidService = Get.find<KidService>();
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
      analytics.screenTime(AnalyticsScreenNames.kidHomeScreen,durationInSeconds.toString());
    }
    FirebaseAnalytics.instance.logScreenView(
      screenName: AnalyticsScreenNames.kidHomeScreen,
    );
  }

}
