import 'dart:io';

import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';
import 'package:coin_kids/pages/roles/parents/add_child/add_child_controller.dart';
import 'package:coin_kids/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AddChildScreen extends StatelessWidget {
  final AddChildController _controller = Get.put(AddChildController());

  AddChildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add your child",
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Child Name Field
              CustomTextField(
                titleText: "Child name",
                hintText: "Enter your child name",
                onChanged: (value) =>
                    _controller.childName.value = value.trim(),
              ),
              const SizedBox(height: 20),

              // Child Age Field
              CustomTextField(
                titleText: "Age",
                hintText: "Enter your child age",
                keyboardType: TextInputType.number,
                onChanged: (value) => _controller.childAge.value = value.trim(),
              ),
              const SizedBox(height: 40),

              // Avatar Selection Title
              Text(
                "Select Avatar",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: CustomThemeData().primaryTextColor,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 10),

              // Avatar Selection
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // Number of items per row
                      crossAxisSpacing: 18, // Space between columns
                      mainAxisSpacing: 14, // Space between rows
                    ),
                    itemCount: _controller.avatars.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // First item: Custom Avatar Picker
                        return Obx(
                          () => GestureDetector(
                            onTap: () async {
                              await _controller.pickCustomAvatar();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: CircleAvatar(
                                radius: 2,
                                backgroundColor: Colors.purple,
                                backgroundImage: _controller
                                        .customAvatarPath.value.isEmpty
                                    ? null
                                    : FileImage(File(
                                        _controller.customAvatarPath.value)),
                                child:
                                    _controller.customAvatarPath.value.isEmpty
                                        ? Center(
                                            child: SvgPicture.asset(
                                              "assets/child_avatar_images/Vector (1).svg",
                                              color: Colors.white,
                                            ),
                                          )
                                        : null,
                              ),
                            ),
                          ),
                        );
                      } else {
                        // Other items: Predefined Avatars
                        final avatarIndex =
                            index - 1; // Adjust index for predefined avatars
                        return Obx(
                          () => GestureDetector(
                            onTap: () => _controller.selectAvatar(avatarIndex),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            _controller.selectedAvatar.value ==
                                                    avatarIndex
                                                ? Colors.purple
                                                : Colors.green),
                                    borderRadius: BorderRadius.circular(50)),
                                child: SvgPicture.asset(
                                  _controller.avatars[avatarIndex],
                                  cacheColorFilter: true,
                                  height:
                                      10, // Set the height to fit the container size
                                  // Set the width to fit the container size
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Add Child Button
              Center(
                child: CustomButton(
                  text: "Add Child",
                  onPressed: () async {
                    await _controller.addChildAndUpdateParent();
                    _controller.customAvatarPath.value = "";
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
