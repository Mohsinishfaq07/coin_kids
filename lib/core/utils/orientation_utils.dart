import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OrientationUtils {
  // Lock to portrait mode (for parent side)
  static void lockToPortrait() {
    Get.log("orientation is orientationBuilder portrait");
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  // Lock to landscape mode (for kid side)
  static void lockToLandscape() {
    Get.log("orientation is orientationBuilder landscape");
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  // Check if screen size exceeds parent app max width
  static bool shouldCenterParentUI(double screenWidth) {
    const double maxParentWidth = 500.0; // Maximum width before centering
    return screenWidth > maxParentWidth;
  }
}
