import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final Color titleColor;

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
    // Nullable, initialized in constructor body
    this.elevation = 0.0,
    this.onBackPressed,
    this.actions,
    this.showBackButton = false,
    this.centerTitle = true,
  }) : titleColor = titleColor ?? Colors.blue.shade900;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.blue.shade900),
              onPressed: onBackPressed ??
                  () => Get.back(), // Default action is Get.back
            )
          : null,
      title: Text(title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18)),
      centerTitle: centerTitle, // Adjust center alignment based on your design
      actions: actions, // Add custom actions if provided
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
