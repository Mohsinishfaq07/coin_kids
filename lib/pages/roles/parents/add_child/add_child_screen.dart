// import 'package:coin_kids/features/custom_widgets/custom_button.dart';
// import 'package:coin_kids/features/roles/parents/add_child/add_child_controller.dart';
// import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
// import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class AddChildScreen extends StatelessWidget {
//   final AddChildController _controller = Get.put(AddChildController());

//   AddChildScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: "Add your child"),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomTextField(
//                 titleText: "Child name",
//                 hintText: "Enter your child name",
//                 onChanged: (value) =>
//                     _controller.childName.value = value.trim(),
//               ),

//               const SizedBox(height: 20),
//               CustomTextField(
//                 titleText: "Age",
//                 hintText: "Enter your child age",
//                 onChanged: (value) => _controller.childAge.value = value.trim(),
//               ),

//               const SizedBox(height: 40),

//               // // Grade Selection
//               // const Text("Grade",
//               //     style: TextStyle(fontWeight: FontWeight.bold)),
//               // Obx(() => DropdownButtonFormField<String>(
//               //       value: _controller.selectedGrade.value.isEmpty
//               //           ? null
//               //           : _controller.selectedGrade.value,
//               //       items: ["Grade 1", "Grade 2", "Grade 3", "Grade 4"]
//               //           .map((grade) => DropdownMenuItem(
//               //                 value: grade,
//               //                 child: Text(grade),
//               //               ))
//               //           .toList(),
//               //       onChanged: (value) => _controller.setGrade(value!),
//               //       decoration: InputDecoration(
//               //         hintText: "Select Child's Grade",
//               //         border: OutlineInputBorder(
//               //           borderRadius: BorderRadius.circular(8),
//               //         ),
//               //       ),
//               //     )),
//               // const SizedBox(height: 20),

//               // Avatar Selection
//               Text("Select Avatar",
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue.shade900)),
//               const SizedBox(height: 10),
//               Obx(() => Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children:
//                         List.generate(_controller.avatars.length, (index) {
//                       return GestureDetector(
//                         onTap: () => _controller.selectAvatar(index),
//                         child: CircleAvatar(
//                           radius: 30,
//                           backgroundColor:
//                               _controller.selectedAvatar.value == index
//                                   ? Colors.purple
//                                   : Colors.transparent,
//                           child: CircleAvatar(
//                             radius: 28,
//                             backgroundImage:
//                                 AssetImage(_controller.avatars[index]),
//                           ),
//                         ),
//                       );
//                     }),
//                   )),
//               const SizedBox(height: 130),
//                // Circle with Camera Icon for Selecting Image
//               Center(
//                 child: GestureDetector(
//                   onTap: () async {
//                     await _controller.pickImage(); // Trigger image selection
//                   },
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       CircleAvatar(
//                         radius: 40,
//                         backgroundColor: Colors.grey[300],
//                         child: _controller.selectedImagePath.value.isEmpty
//                             ? const Icon(Icons.camera_alt, size: 30)
//                             : null,
//                       ),
//                       if (_controller.selectedImagePath.value.isNotEmpty)
//                         CircleAvatar(
//                           radius: 38,
//                           backgroundImage: FileImage(
//                             File(_controller.selectedImagePath.value),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),

//               // Add Child Button
//               Center(
//                 child: CustomButton(
//                   text: "Add Child",
//                   onPressed: () async {
//                     _controller.addChildAndUpdateParent();
//                     //    await _controller.addChild();
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';

import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';
import 'package:coin_kids/pages/roles/parents/add_child/add_child_controller.dart';
import 'package:coin_kids/theme/light_theme.dart';
import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
              Text("Select Avatar",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: CustomThemeData().primaryTextColor,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),

              // Avatar Selection
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await _controller.pickCustomAvatar();
                        },
                        child: Obx(() => CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.purple,
                              backgroundImage: _controller
                                      .customAvatarPath.value.isEmpty
                                  ? null
                                  : FileImage(
                                      File(_controller.customAvatarPath.value)),
                              child: _controller.customAvatarPath.value.isEmpty
                                  ? const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 30,
                                      color: Colors.white,
                                    )
                                  : null,
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
              const SizedBox(height: 40),

              // Add Child Button
              Center(
                child: CustomButton(
                  text: "Add Child",
                  onPressed: () async {
                    await _controller.addChildAndUpdateParent();
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
