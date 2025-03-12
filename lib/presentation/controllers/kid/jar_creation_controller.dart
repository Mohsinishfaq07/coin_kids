import 'dart:ui';

import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/remote_services/kid_service.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/screens/common/sign_in/sign_in_screen.dart';
import 'package:get/get.dart';

class JarCreationController extends GetxController {
  final appState = Get.find<AppStateController>();
  final kidService = Get.find<KidService>();
  var selectedColorIndex = 0.obs;

  var jarType = Jars.spendingJar;

  final amount = 0.0.obs;

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
}
