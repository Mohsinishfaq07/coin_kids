import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../parent_auth_controller/parent_auth_controller.dart';

class ParentNumber extends StatelessWidget {
  final ParentAuthController _controller = Get.put(ParentAuthController());

  ParentNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          "Create new account",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // email
              CustomTextField(
                hintText: 'Number with country code',
                onChanged: (value) => _controller.number.value = value,
                titleText: 'Number with country code',
              ),
              const SizedBox(height: 20),
              // Birthday Picker
              Obx(
                () => CustomTextField(
                  hintText: _controller.birthday.value.isEmpty
                      ? "Date"
                      : _controller.birthday.value,
                  suffixIcon: Icons.calendar_month,
                  onSuffixTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      _controller.setBirthday(date);
                    }
                  },
                  titleText: "Birthday",
                ),
              ),

              const SizedBox(height: 20),

              // Username Input
              CustomTextField(
                hintText: 'Username',
                onChanged: (value) => _controller.username.value = value,
                titleText: 'Username',
              ),
              const SizedBox(height: 20),

              // Gender Selection
              const Text(
                "Gender (Optional)",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color.fromARGB(255, 9, 90, 156),
                ),
              ),
              const SizedBox(height: 10),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => _controller.selectGender("Female"),
                        child: Container(
                          width: 160,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 32),
                          decoration: BoxDecoration(
                            color: _controller.selectedGender.value == "Female"
                                ? Colors.amber
                                : Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.female,
                            color: _controller.selectedGender.value == "Female"
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _controller.selectGender("Male"),
                        child: Container(
                          width: 160,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 32),
                          decoration: BoxDecoration(
                            color: _controller.selectedGender.value == "Male"
                                ? Colors.purple
                                : Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.male,
                            color: _controller.selectedGender.value == "Male"
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  )),

              // Terms and Signup Button
              RichText(
                textAlign: TextAlign.start,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "By clicking Sign Up, you are agreeing to the ",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                    TextSpan(
                      text: "Terms of services & Privacy Policy.",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Center(
                child: CustomButton(
                  text: 'Sign up',
                  onPressed: () {
                   // _controller.signUpWithGoogle(); // Call signup method
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
