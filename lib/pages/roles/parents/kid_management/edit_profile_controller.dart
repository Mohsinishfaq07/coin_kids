import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  // RxString selectedGrade = 'Grade 1'.obs;
  // RxString updatedName = ''.obs;
  final String childAge;
  final String childName;

  EditProfileController({
    required this.childAge,
    required this.childName,
  });
  RxBool childUpdate = false.obs;
  Rx<TextEditingController> childAgeController = TextEditingController().obs;
  Rx<TextEditingController> childNameController = TextEditingController().obs;
  setValues({
    required String childAge,
    required String childName,
  }) {
    childAgeController.value.text = childAge.trim();
    childNameController.value.text = childName.trim();
    Get.log('updating controllers');
  }

  @override
  void onInit() {
    super.onInit();
    setValues(childAge: childAge, childName: childName);
  }
}
