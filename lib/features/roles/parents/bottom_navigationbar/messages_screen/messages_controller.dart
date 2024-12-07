
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesController extends GetxController {
  // Example list of messages
 

  // Handle button actions
  void onButtonPressed(String action) {
    Get.snackbar('Action', '$action button pressed');
  }
}