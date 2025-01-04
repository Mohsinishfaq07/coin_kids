import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/pages/roles/parents/drawer/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class KidDrawer extends StatelessWidget {
  KidDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.blue.shade50, // Light blue background
        body: StreamBuilder(
            stream:
                firestoreOperations.parentFirebaseFunctions.fetchKidData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('No data found.'));
              }

              Map<String, dynamic> data = snapshot.data!;
              firebaseAuthController.username.value = data['name'];
              firebaseAuthController.birthday.value = data['dob'];
              firebaseAuthController.selectedGender.value = data['gender'];
              return originalWidget(parentData: data);
            }));
  }

  // after data fetched widget
  originalWidget({required Map<String, dynamic> parentData}) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // Header with profile information
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.purple,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(60)),
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.yellow,
                        child: Icon(
                          Icons.edit,
                          size: 15,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${parentData['name']}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "@${parentData['name']}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // My Profile Section
            _buildSectionHeader("My Profile", onEdit: () {
              Get.to(() => ParentUpdateProfileScreen(
                    parentData: parentData,
                  ));
              Get.snackbar("Edit", "Edit profile clicked!");
            }),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white38,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  _buildProfileRow("Full name", "${parentData['name']}",
                      "assets/drawer_svgs/3p.svg"),
                  _buildProfileRow("Date of birth", "${parentData['dob']}",
                      "assets/drawer_svgs/calendar_month.svg"),
                  _buildProfileRow("Gender", "${parentData['gender']}",
                      "assets/drawer_svgs/wc.svg"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Personalization Section
            _buildSectionHeader("Personalization"),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white38,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  _buildProfileRowWithArrow(
                      "Change Language", "assets/drawer_svgs/language.svg"),
                  _buildProfileRowWithArrow(
                      "Parent Zone Pin", "assets/drawer_svgs/password_2.svg"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Notifications Section
            _buildSectionHeader("Notifications"),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white38,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  _buildToggleRow("Goal Achievement", true,
                      "assets/drawer_svgs/flag_check.svg"),
                  _buildToggleRow(
                      "Money Request", false, "assets/drawer_svgs/euro.svg"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Others Section
            _buildSectionHeader("Others"),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white38,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(children: [
                  _buildProfileRowWithArrow(
                      "Share app", "assets/drawer_svgs/share.svg"),
                  _buildProfileRowWithArrow(
                      "Feedback", "assets/drawer_svgs/rate_review.svg"),
                  _buildProfileRowWithArrow(
                      "Privacy Policy", "assets/drawer_svgs/lock.svg"),
                  ElevatedButton(
                    onPressed: () async {
                      await firebaseAuthController.logout();
                    },
                    child: const Text('Logout'),
                  )
                ])),

            const SizedBox(height: 30),

            // Version
            const Text(
              "Version 1.0.1",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build section header
  Widget _buildSectionHeader(String title, {VoidCallback? onEdit}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900),
          ),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18, color: Colors.blue.shade900),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    "Edit",
                    style: TextStyle(color: Colors.blue.shade900, fontSize: 12),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Build profile row (key-value pair)
  Widget _buildProfileRow(String title, String value, String iconPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                iconPath, // Path to your SVG asset
                color: Colors.purple,
                height: 30, // Adjust the size as needed
                width: 30, // Adjust the size as needed
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Build profile row with arrow
  Widget _buildProfileRowWithArrow(String title, String iconPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                iconPath, // Path to your SVG asset
                color: Colors.purple,
                height: 25, // Adjust the size as needed
                width: 25, // Adjust the size as needed
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
        ],
      ),
    );
  }

  // Build toggle row
  Widget _buildToggleRow(String title, bool value, String iconPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                iconPath, // Path to your SVG asset
                color: Colors.purple,
                height: 25, // Adjust the size as needed
                width: 25, // Adjust the size as needed
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              Get.snackbar("Toggle Changed", "$title is now $newValue");
            },
            activeColor: Colors.purple,
          ),
        ],
      ),
    );
  }
}
