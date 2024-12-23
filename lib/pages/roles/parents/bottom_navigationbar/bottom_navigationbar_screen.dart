import 'package:coin_kids/dialogues/custom_dialogues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'bottom_navigationbar_controller.dart'; // Adjust this import as needed

class BottomNavigationBarScreen extends StatelessWidget {
  BottomNavigationBarScreen({super.key});
  final BottomNavigationbarController controller =
      Get.put(BottomNavigationbarController());

  bool _isOnHomeScreen = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.currentIndex.value != 0) {
          controller.currentIndex.value = 0;
          _isOnHomeScreen = true;
          return false;
        }

        if (_isOnHomeScreen) {
          bool shouldExit = await _showExitConfirmation(context);
          return shouldExit;
        }

        return false;
      },
      child: Scaffold(
        body: Obx(() => controller.screens[controller.currentIndex.value]),
        bottomNavigationBar: Obx(() {
          return BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: (index) {
              if (index == 3) {
                showKidsZoneDialog(
                  context,
                  purpleBgPath: 'assets/bottomSheetIcons/bottomSheetBg.svg',
                  coinIconPath: 'assets/bottomSheetIcons/kidZoneCoinIcon.svg',
                  closeIconPath: 'assets/bottomSheetIcons/closeButton.svg',
                  greenButtonBgPath: 'assets/bottomSheetIcons/okBtnBg.svg',
                  tickIconPath: 'assets/bottomSheetIcons/tickIcon.svg',
                );
              } else {
                controller.currentIndex.value = index;
                _isOnHomeScreen = index == 0;
              }
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.purple,
            unselectedItemColor: Colors.grey,
            items: [
              _buildNavBarItem(
                iconPath: 'assets/home_icon.svg',
                label: 'Home',
                index: 0,
              ),
              _buildNavBarItem(
                iconPath: 'assets/messages_icon.svg',
                label: 'Messages',
                index: 1,
              ),
              _buildNavBarItem(
                iconPath: 'assets/cart_icon.svg',
                label: 'Shop',
                index: 2,
              ),
              _buildNavBarItem(
                iconPath: 'assets/Coin.svg',
                label: 'Kid Zone',
                index: controller.currentIndex.value,
              ),
            ],
          );
        }),
      ),
    );
  }

  BottomNavigationBarItem _buildNavBarItem({
    required String iconPath,
    required String label,
    required int index,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
        color: index == 3 // Check if it's the Kid Zone index
            ? null // No color assigned for Kid Zone icon
            : (controller.currentIndex.value == index
                ? Colors.purple
                : Colors.grey),
      ),
      label: label,
    );
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Row(
              children: [
                Icon(Icons.exit_to_app, color: Colors.red, size: 28),
                SizedBox(width: 8),
                Text(
                  'Exit App',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: const Text(
              'Are you sure you want to exit the application?',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey,
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  'Exit',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
