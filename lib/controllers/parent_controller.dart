import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

class ParentController extends GetxController {
  RxString selectedChildIdForQuickTransfer = ''.obs;
  RxString selectedChildNameForQuickTransfer = ''.obs;

  // controller values  for parent quick transfer
  RxString amount = ''.obs;
  RxString message = ''.obs;
  RxString amountValidation = ''.obs;
}
