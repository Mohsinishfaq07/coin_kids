import 'package:get/get.dart';

class NavigationHelper {
  /// Get the current route name safely
  static String? get currentRoute => Get.currentRoute;

  /// Safe `Get.toNamed()` – Navigates only if not already on the same screen
  static void toNamed(String route, {dynamic arguments}) {
    if (currentRoute != route) {
      Get.toNamed(route, arguments: arguments);
    }
  }

  /// Safe `Get.offNamed()` – Replaces only if not already on the same screen
  static void offNamed(String route, {dynamic arguments}) {
    if (currentRoute != route) {
      Get.offNamed(route, arguments: arguments);
    }
  }

  /// Safe `Get.offAllNamed()` – Clears stack only if not already on the same screen
  static void offAllNamed(String route, {dynamic arguments}) {
    if (currentRoute != route) {
      Get.offAllNamed(route, arguments: arguments);
    }
  }
}
