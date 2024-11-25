import 'dart:io';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/features/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:coin_kids/features/roles/parents/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParentsHomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  ParentsHomeScreen({super.key});
  void navigateToProfileScreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration:
            const Duration(milliseconds: 300), // Animation duration
        pageBuilder: (context, animation, secondaryAnimation) =>
            ProfileDrawer(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(-1.0, 0.0); // Start from left
          const end = Offset.zero; // End at the current position
          const curve = Curves.easeInOut;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.purple,
              ),
              onPressed: () {
                Get.snackbar("Settings", "Settings screen navigation");
              },
            ),
          ],
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  navigateToProfileScreen(context);
                },
                child: Container(
                  width: 45, // Adjust the size of the border
                  height: 45, // Adjust the size of the border
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue, // Border color
                      // Border width
                    ),
                  ),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                        controller.parentName.value,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      )),
                  const Text(
                    "Welcome 👋",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        body: Obx(
          () {
            if (controller.isLoading.value) {
              // Show loading indicator
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.kidsList.isEmpty) {
              // No kids available
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 60),
                        child: Image.asset(
                          "assets/logo.png", // Ensure the image is in the 'assets' folder and added to pubspec.yaml
                          height: 50,
                        ),
                      ),
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Almost There!",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Start by adding your first child.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomButton(
                              width: 180,
                              text: 'Add Child',
                              onPressed: controller.navigateToAddChild,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Display list of kids
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Image.asset(
                      "assets/logo.png", // Ensure the image is in the 'assets' folder and added to pubspec.yaml
                      height: 50,
                    ),
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Family Profile")),
                  SizedBox(
                    height: 150, // Set a fixed height for the horizontal list
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.kidsList.length +
                          1, // Add 1 for "Add" circle at the end
                      itemBuilder: (context, index) {
                        if (index == controller.kidsList.length) {
                          // Last item: Add circle
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: GestureDetector(
                              onTap: controller
                                  .navigateToAddChild, // Navigate to add child screen
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.purple),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(14.0),
                                      child: Icon(
                                        Icons.add, // Add icon
                                        color: Colors.deepPurple,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Add Child",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          // Other items: Display kids' data
                          final kid = controller.kidsList[
                              index]; // Use index directly for kidsList
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: kid['avatar'] != null &&
                                          kid['avatar'].toString().isNotEmpty
                                      ? (kid['avatar'].startsWith('/')
                                          ? FileImage(File(kid[
                                              'avatar'])) // Load local image
                                          : NetworkImage(kid[
                                                  'avatar']) // Load network image
                                              as ImageProvider) // Determine if it's a local or network image
                                      : const AssetImage("assets/avatar1.png"),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  kid['name'] ?? 'No Name',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                              width: 180,
                              text: 'Quick transfer',
                              onPressed: controller.navigateToAddChild,
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 60.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'Send ',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors
                                        .black, // Default color for non-bold text
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Send ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .purple, // Purple color for "Send"
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'or ',
                                      style: const TextStyle(
                                        color: Colors
                                            .black, // Default color for "or"
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'remove ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .purple, // Purple color for "remove"
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'money from your child\'s account',
                                      style: const TextStyle(
                                        color: Colors
                                            .black, // Default color for the remaining text
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
///