import 'package:get/get.dart';

class ParentController extends GetxController {
  RxString selectedChildIdForQuickTransfer = ''.obs;

  // controller values  for parent quick transfer
  RxString amount = ''.obs;
  RxString message = ''.obs;
  RxString amountValidation = ''.obs;
}
