import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/roles/parents/authentication/parent_auth_controller/parent_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';

class ParentUpdateProfileScreen extends StatelessWidget {
  final ParentAuthController _controller = Get.put(ParentAuthController());

  ParentUpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(title: "Update Profile"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Email Input
              CustomTextField(
                hintText: _controller.birthday.value.isEmpty
                    ? 'Date'
                    : _controller.birthday.value,
                titleText: 'Birthday',
                suffixIcon: Icons.calendar_month,
                onSuffixTap: () async {
                  // Open DatePicker
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    _controller.setBirthday(pickedDate); // Update Birthday
                  }
                },
              ),
              const SizedBox(height: 25),

              // PIN Input
              CustomTextField(
                titleText: 'Full name',
                hintText: 'What should we call you ',
                onChanged: (value) {
                  _controller.pin.value = value.trim();
                  _controller.checkFields(); // Check fields on change
                },
              ),
              const SizedBox(height: 10),
              // Gender Selection

              Text("Gender (Optional)",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _controller.selectGender("Male");
                      },
                      child: Obx(() => Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: _controller.selectedGender.value == "Male"
                                  ? Colors.blue.shade100
                                  : Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.male, color: Colors.blue),
                          )),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _controller.selectGender("Female");
                      },
                      child: Obx(() => Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color:
                                  _controller.selectedGender.value == "Female"
                                      ? Colors.pink.shade100
                                      : Colors.white,
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.female, color: Colors.pink),
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),

              // Forgot Credentials

              // Login Button
              Obx(() => Center(
                    child: CustomButton(
                      color: _controller.isButtonEnabled.value
                          ? Colors.purple
                          : Colors.grey,
                      text: 'Update profile',
                      onPressed: () async {
                        await _controller.loginWithEmail();
                      },
                    ),
                  )),
              const SizedBox(height: 40),

              // Signup Link
            ],
          ),
        ),
      ),
    );
  }
}
