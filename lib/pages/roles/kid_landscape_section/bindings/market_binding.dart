import 'package:get/get.dart';
import '../kid_market/market_controller.dart';

class MarketBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MarketController());
  }
}
