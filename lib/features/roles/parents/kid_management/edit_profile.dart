import 'dart:io';

import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/features/custom_widgets/custom_dropdown.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';
import 'package:coin_kids/features/roles/parents/add_child/add_child_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  RxString selectedAge = '1'.obs;
  RxString selectedGrade = 'Grade 1'.obs;
  RxString updatedName = ''.obs;
}

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final AddChildController _controller = Get.put(AddChildController());
    final EditProfileController editProfileController =
        Get.put(EditProfileController());
    return Scaffold(
      appBar: CustomAppBar(title: "Update Child Profile"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                  titleText: "Child name",
                  hintText: "Enter your child name",
                  onChanged: (val) {
                    editProfileController.updatedName.value = val;
                  }),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Age'),
                      SizedBox(
                          width: MediaQuery.sizeOf(context).width / 2.5,
                          child: Obx(() {
                            return customDropdown(
                              context,
                              options: ['1', '2', '3', '4'],
                              onChanged: (value) {
                                Get.log('Selected: $value');
                                editProfileController.selectedAge.value =
                                    value ?? '1';
                              },
                              selectedValue:
                                  editProfileController.selectedAge.value,
                            );
                          })),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Grade'),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 2.5,
                        child: Obx(() {
                          return customDropdown(
                            context,
                            options: [
                              'Grade 1',
                              'Grade 2',
                              'Grade 3',
                              'Grade 4'
                            ],
                            onChanged: (value) {
                              Get.log('Selected: $value');
                              editProfileController.selectedGrade.value =
                                  value ?? 'Grade 1';
                            },
                            selectedValue:
                                editProfileController.selectedGrade.value,
                          );
                        }),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 30),
              Text(
                "Select Avatar",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 10),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await _controller.pickCustomAvatar();
                        },
                        child: Obx(() => Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(
                                    30,
                                  )),
                                  border: Border.all(
                                    color: Colors.purple,
                                  )),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.transparent,
                                backgroundImage: _controller
                                        .customAvatarPath.value.isEmpty
                                    ? null
                                    : FileImage(File(
                                        _controller.customAvatarPath.value)),
                                child:
                                    _controller.customAvatarPath.value.isEmpty
                                        ? const Icon(
                                            Icons.add,
                                            size: 30,
                                            color: Colors.purple,
                                          )
                                        : null,
                              ),
                            )),
                      ), // Predefined avatars
                      ...List.generate(_controller.avatars.length, (index) {
                        return GestureDetector(
                          onTap: () => _controller.selectAvatar(index),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                _controller.selectedAvatar.value == index
                                    ? Colors.purple
                                    : Colors.transparent,
                            child: CircleAvatar(
                              radius: 28,
                              backgroundImage:
                                  AssetImage(_controller.avatars[index]),
                            ),
                          ),
                        );
                      }),
                      // Custom Avatar (Empty Circle with Camera Icon)
                    ],
                  )),
              const Expanded(child: SizedBox()),
              Center(
                child: CustomButton(
                  text: "Update Child",
                  onPressed: () async {
                    Get.back();
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
