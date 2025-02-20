import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:get/get.dart';

class MessagesController extends GetxController {
  // Example list of messages

  // Handle button actions
  void onButtonPressed(String action) {
    ToastUtil.showToast('$action button pressed');
  }
}
