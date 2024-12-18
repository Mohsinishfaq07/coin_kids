import 'package:coin_kids/features/roles/kid/kid_bottom_nav/kid_nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class KidBottomNavScreen extends StatelessWidget {
  KidBottomNavScreen({super.key});
  final KidNavigationBarController controller =
      Get.put(KidNavigationBarController());

  bool _isOnHomeScreen = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.currentIndex.value != 0) {
          // Agar current index home pe nahi hai
          controller.currentIndex.value = 0; // Home index pe navigate karna
          _isOnHomeScreen = true;
          return false; // Pop nahi hone dena
        }

        if (_isOnHomeScreen) {
          // Agar home screen pe aur back button press ho gaya
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
              controller.currentIndex.value = index;
              _isOnHomeScreen = index == 0; // Track if user is on home screen
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.purple,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: GoogleFonts.openSans(
              color: const Color(0xffA421D9),
              fontWeight: FontWeight.w800,
            ),
            unselectedLabelStyle: GoogleFonts.openSans(
              color: const Color(0xff838383),
              fontWeight: FontWeight.w800,
            ),
            backgroundColor: Colors.blue[50],
            elevation: 0.0,
            items: [
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/kid_section_icons/kid_my_money_icon.svg',
                  ),
                  label: 'My Money'),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/kid_section_icons/kid_goal_icon.svg',
                  ),
                  label: 'Goals'),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/kid_section_icons/kid_shop_icon.svg',
                  ),
                  label: 'Shop'),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/kid_section_icons/kid_parent_zone.svg',
                  ),
                  label: 'Parent Zone')
              // bottomBarItem(
              //     assetName: 'assets/kid_section_icons/kid_goal_icon.svg',
              //     label: 'Goals'),
              // bottomBarItem(
              //     assetName: 'assets/kid_section_icons/kid_shop_icon.svg',
              //     label: 'Shop'),
              // bottomBarItem(
              //     assetName: 'assets/kid_section_icons/kid_parent_zone.svg',
              //     label: 'Parent Zone')
            ],
          );
        }),
      ),
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

  //bottom bar item

  bottomBarItem({required String assetName, required String label}) {
    return SizedBox(
      height: 70,
      width: 70,
      child: Column(
        children: [
          SvgPicture.asset(assetName),
          Text(label),
        ],
      ),
    );
  }
}
