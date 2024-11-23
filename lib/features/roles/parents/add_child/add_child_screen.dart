import 'package:coin_kids/features/roles/parents/add_child/add_child_controller.dart';
import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddChildScreen extends StatelessWidget {
  final AddChildController _controller = Get.put(AddChildController());

  AddChildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ),
      appBar: const CustomAppBar(title: "Add your child"),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                titleText: "Child name",
                hintText: "Enter your child name",
                onChanged: (value) => _controller.childName.value = value,
              ),

              SizedBox(height: 20),
              CustomTextField(
                titleText: "Age",
                hintText: "Enter your child age",
                onChanged: (value) => _controller.childAge.value = value,
              ),

              const SizedBox(height: 20),

              // Grade Selection
              const Text("Grade",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Obx(() => DropdownButtonFormField<String>(
                    value: _controller.selectedGrade.value.isEmpty
                        ? null
                        : _controller.selectedGrade.value,
                    items: ["Grade 1", "Grade 2", "Grade 3", "Grade 4"]
                        .map((grade) => DropdownMenuItem(
                              value: grade,
                              child: Text(grade),
                            ))
                        .toList(),
                    onChanged: (value) => _controller.setGrade(value!),
                    decoration: InputDecoration(
                      hintText: "Select Child's Grade",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )),
              const SizedBox(height: 20),

              // Avatar Selection
              const Text("Select Avatar",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        List.generate(_controller.avatars.length, (index) {
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
                  )),
              const SizedBox(height: 30),

              // Add Child Button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    _controller.addChildAndUpdateParent();
                    //    await _controller.addChild();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Add Child",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
