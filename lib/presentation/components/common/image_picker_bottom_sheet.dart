import 'package:coin_kids/core/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagePickerBottomSheet {
  static void show({
    required VoidCallback onCameraTap,
    required VoidCallback onGalleryTap,
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Choose Image Source",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: Text(
                "Take Photo",
                style: AppTextStyle.bodyLarge,
              ),
              onTap: () {
                Get.back();
                onCameraTap();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: Text(
                "Choose from Gallery",
                style: AppTextStyle.bodyLarge,
              ),
              onTap: () {
                Get.back();
                onGalleryTap();
              },
            ),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }
}
