// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:io';
//
// class KidGoalsController extends GetxController {
//   // ... existing code ...
//
//   // Add method to load saved image
//   Future<void> loadSavedImage(String goalId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final savedImagePath = prefs.getString('goal_image_$goalId');
//       if (savedImagePath != null && savedImagePath.isNotEmpty) {
//         // Check if file exists before setting
//         if (await File(savedImagePath).exists()) {
//           goalImage.value = savedImagePath;
//         } else {
//           goalImage.value = "";
//           // Clean up invalid preference
//           await prefs.remove('goal_image_$goalId');
//         }
//       }
//     } catch (e) {
//       print('Error loading saved image: $e');
//       goalImage.value = "";
//     }
//   }
//
//   // ... rest of existing code ...
// }