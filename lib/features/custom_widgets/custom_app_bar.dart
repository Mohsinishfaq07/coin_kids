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
  final bool showBackButton;
  final bool centerTitle;

  CustomAppBar({
    super.key,
    required this.title, // Enforce required     title
    this.backgroundColor = Colors.transparent,
    Color? titleColor, // Nullable, initialized in constructor body
    Color? iconColor = Colors.blue, // Nullable, initialized in constructor body
    this.elevation = 0.0,
    this.onBackPressed,
    this.actions,
    this.showBackButton = false,
    this.centerTitle = true,
  })  : titleColor = titleColor ?? Colors.blue.shade900,
        iconColor = iconColor ?? Colors.blue.shade900;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: iconColor),
              onPressed: onBackPressed ??
                  () => Get.back(), // Default action is Get.back
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: centerTitle, // Adjust center alignment based on your design
      actions: actions, // Add custom actions if provided
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
