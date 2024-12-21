import 'package:coin_kids/features/roles/kid/kid_bottom_nav/kid_bottom_nav_screen.dart';
import 'package:coin_kids/features/roles/parents/authentication/parent_login/parent_login_screen.dart';
import 'package:coin_kids/features/roles/parents/authentication/parent_signup/parent_signup_screen.dart';
import 'package:coin_kids/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              OptionCard(
                imagePath: "assets/role_selection_icons/im_parent_icon.svg",
                title: "I’m a Parent",
                description: "Give allowances",
                onTap: () {
                  Get.to(() => SignupParentScreen());
                },
                description1: "Support your child's",
                description2: "financial goals",
              ),
              OptionCard(
                imagePath: "assets/role_selection_icons/Group.svg",
                title: "I’m a Child",
                description: "Receive allowance",
                onTap: () {
                  // Navigate to Child Screen (e.g., ChildLoginScreen)
                  //Get.to(() => ChildLoginScreen());
                  Get.to(() => KidBottomNavScreen());
                },
                description1: 'Set up saving goals',
                description2: '',
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
  final String description2;
  final VoidCallback onTap;
  final Color? imageColor;

  const OptionCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.description1,
    required this.description2,
    required this.onTap,
    this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(30),
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
              radius: 50,
              backgroundColor: Colors.purple,
              child: SvgPicture.asset(
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/role_selection_icons/coin_icon.svg",
                        height: 30,
                      ),
                      const SizedBox(width: 10),
                      Text(description,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: CustomThemeData().primaryTextColor)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/role_selection_icons/support_icon.svg",
                        height: 30,
                      ),
                      const SizedBox(width: 10),
                      Text(description1,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: CustomThemeData().primaryTextColor)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/role_selection_icons/support_icon.svg",
                        height: 30,
                        color: Colors.transparent,
                      ),
                      const SizedBox(width: 10),
                      Text(description2,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: CustomThemeData().primaryTextColor)),
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
