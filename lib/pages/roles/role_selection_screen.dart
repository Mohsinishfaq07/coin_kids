import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/pages/roles/kid/kid_bottom_nav/kid_bottom_nav_screen.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/bottom_navigationbar_screen.dart';
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
                "Are you a parent or\n a child?",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 24.0, // Adjust the font size as needed
                    ),
              ),
              const SizedBox(height: 40),
              OptionCard(
                imagePath: "assets/role_selection_icons/im_parent_icon.svg",
                title: "I’m a Parent",
                description: "Give allowances",
                onTap: () {
                  firebaseAuthController.saveParentInfo(
                      fieldName: 'email',
                      fieldValue: firebaseAuthController.email.value);
                  firebaseAuthController.saveInfoLocally(
                      firebaseAuthController.email.value,
                      firebaseAuthController.pin.value);
                  Get.offAll(ParentBottomNavigationBar());
                },
                description1: "Support your child's",
                description2: "Financial journey  ",
              ),
              OptionCard(
                imagePath: "assets/role_selection_icons/Group.svg",
                title: "I’m a Child",
                description: "Receive Allowance",
                onTap: () {
                  firebaseAuthController.saveKidInfo(
                      fieldName: 'email',
                      fieldValue: firebaseAuthController.email.value);
                  firebaseAuthController.saveInfoLocally(
                      firebaseAuthController.email.value,
                      firebaseAuthController.pin.value);

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
        padding: const EdgeInsets.all(18),
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
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 18),
              child: CircleAvatar(
                radius: 38,
                backgroundColor: Colors.purple,
                child: SvgPicture.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  color: imageColor,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 19),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/role_selection_icons/coin_icon.svg",
                        height: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(description,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: CustomThemeData().primaryTextColor,
                                  fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/role_selection_icons/support_icon.svg",
                        height: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(description1,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  color: CustomThemeData().primaryTextColor,
                                  fontSize: 14)),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/role_selection_icons/support_icon.svg",
                        height: 22,
                        color: Colors.transparent,
                      ),
                      const SizedBox(width: 12),
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
