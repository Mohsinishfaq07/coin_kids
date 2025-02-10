import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/toast_widget.dart';
import 'package:get/get.dart';

class MessagesController extends GetxController {
  // Example list of messages

  // Handle button actions
  void onButtonPressed(String action) {
    ToastUtil.showToast('$action button pressed');
  }
}
