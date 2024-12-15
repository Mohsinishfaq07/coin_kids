import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/features/roles/kid/kid_bottom_nav/kid_bottom_nav_screen.dart';
import 'package:coin_kids/features/roles/parents/authentication/parent_login/parent_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Are you a parent\nor a child?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 40),
              OptionCard(
                imagePath: "assets/select_parents.png",
                title: "I’m a Parent",
                description: "Give allowances",
                onTap: () {
                  Get.to(() => ParentLoginScreen());
                },
                description1: "Support your child's financial journey",
              ),
              OptionCard(
                imagePath: "assets/select_child.png",
                title: "I’m a Child",
                description: "Receive allowance",
                onTap: () {
                  // Navigate to Child Screen (e.g., ChildLoginScreen)
                  //Get.to(() => ChildLoginScreen());
                  Get.to(() => KidBottomNavScreen());
                },
                description1: 'Set up saving goals',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String description1;
  final VoidCallback onTap;
  final Color? imageColor;

  const OptionCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.description1,
    required this.onTap,
    this.imageColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.purple,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                color: imageColor,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Image.asset("assets/dollar_coin.png"),
                      SizedBox(width: 10),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Image.asset("assets/saving_goals.png"),
                      SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          description1,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
