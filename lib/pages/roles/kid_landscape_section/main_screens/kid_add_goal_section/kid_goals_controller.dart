import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class KidGoalsController extends GetxController {
  final ImagePicker picker = ImagePicker();

  RxString goalName = ''.obs;
  RxString goalAmount = ''.obs;
  RxString goalImage = ''.obs;

  pickImageFromGallery() async {
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      goalImage.value = pickedImage.path;
    }
  }

  pickImageFromCamera() async {
    XFile? pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      goalImage.value = pickedImage.path;
    }
  }
}
