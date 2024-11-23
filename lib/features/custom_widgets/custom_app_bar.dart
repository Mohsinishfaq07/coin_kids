import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final Color titleColor;
  final Color iconColor;
  final double elevation;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.backgroundColor = Colors.transparent,
    this.titleColor = Colors.black,
    this.iconColor = Colors.black,
    this.elevation = 0.0,
    this.onBackPressed,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: iconColor),
        onPressed:
            onBackPressed ?? () => Get.back(), // Default action is Get.back
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      actions: actions, // Add custom actions if provided
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
