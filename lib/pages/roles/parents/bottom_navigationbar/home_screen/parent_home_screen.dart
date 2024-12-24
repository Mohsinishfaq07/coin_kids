import 'dart:io';
import 'package:coin_kids/dialogues/custom_dialogues.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/pages/roles/parents/add_child/add_child_screen.dart';
import 'package:coin_kids/pages/roles/parents/all_childs/all_children_page.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:coin_kids/pages/roles/parents/drawer/drawer.dart';
import 'package:coin_kids/pages/roles/parents/kid_management/kid_profile_management_page.dart';
import 'package:coin_kids/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ParentsHomeScreen extends StatefulWidget {
  const ParentsHomeScreen({super.key});

  @override
  State<ParentsHomeScreen> createState() => _ParentsHomeScreenState();
}

class _ParentsHomeScreenState extends State<ParentsHomeScreen> {
  final HomeController controller = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchParentDetails();
      controller.fetchKids();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor:
                Colors.transparent, // Make the status bar transparent
            statusBarIconBrightness: Brightness.dark,
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.purple,
              ),
              onPressed: () {
                // Get.snackbar("Settings", "Settings screen navigation");
                // showKidsZoneDialog(
                //   context,
                //   purpleBgPath: 'assets/bottomSheetIcons/bottomSheetBg.svg',
                //   coinIconPath: 'assets/bottomSheetIcons/kidZoneCoinIcon.svg',
                //   closeIconPath: 'assets/bottomSheetIcons/closeButton.svg',
                //   greenButtonBgPath: 'assets/bottomSheetIcons/okBtnBg.svg',
                //   tickIconPath: 'assets/bottomSheetIcons/tickIcon.svg', label: '', subLabel: '',
                // );
              },
            ),
          ],
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(
                    ProfileDrawer(),
                    transition:
                        Transition.leftToRightWithFade, // Custom transition
                    duration:
                        const Duration(milliseconds: 300), // Animation duration
                  );
                },
                child: Container(
                  width: 45, // Adjust the size of the border
                  height: 45, // Adjust the size of the border
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: CustomThemeData()
                            .primaryButtonColor, // Border color
                        width: 2
                        // Border width
                        ),
                  ),
                  child: Icon(Icons.person,
                      color: CustomThemeData().disabledIconColor),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                        controller.parentName.value,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontSize: 18),
                      )),
                  Text("Welcome 👋",
                      style: Theme.of(context).textTheme.bodySmall)
                ],
              ),
            ],
          ),
        ),
        body: Obx(
          () {
            if (controller.isLoading.value) {
              // Show loading indicator
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.kidsList.isEmpty) {
              // No kids available
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 60),
                        child: Image.asset(
                          "assets/logo.png", // Ensure the image is in the 'assets' folder and added to pubspec.yaml
                          height: 50,
                        ),
                      ),
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Almost There!",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        color: CustomThemeData()
                                            .primaryButtonColor)),
                            const SizedBox(height: 10),
                            Text("Start by adding your first child.",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color:
                                            CustomThemeData().primaryTextColor,
                                        fontWeight: FontWeight.w700)),
                            const SizedBox(height: 20),
                            CustomButton(
                                width: 180,
                                text: 'Add Child',
                                onPressed: () {
                                  Get.to(() => AddChildScreen());
                                }
                                //controller.navigateToAddChild,
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Display list of kids
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Image.asset(
                      "assets/logo.png", // Ensure the image is in the 'assets' folder and added to pubspec.yaml
                      height: 50,
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Family Profile",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                            fontSize: 12),
                      )),
                  SizedBox(
                    height: 150, // Set a fixed height for the horizontal list
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.kidsList.length +
                          1, // Add 1 for "Add" circle at the end
                      itemBuilder: (context, index) {
                        if (index == controller.kidsList.length) {
                          // Last item: Add circle
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => AddChildScreen());
                              }, // Navigate to add child screen
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.purple, width: 2),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(14.0),
                                      child: Icon(
                                        Icons.add, // Add icon
                                        color: Colors.deepPurple,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Add Child",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          // Other items: Display kids' data
                          final kid = controller.kidsList[
                              index]; // Use index directly for kidsList

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => KidProfileManagementPage(
                                      childId: '${kid['id']}',
                                    ));
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: kid['avatar']
                                            .startsWith('/')
                                        ? FileImage(File(kid['avatar']))
                                        : (kid['avatar'].startsWith('assets') &&
                                                !kid['avatar'].endsWith('.svg'))
                                            ? AssetImage(kid['avatar'])
                                            : kid['avatar'].startsWith('http')
                                                ? NetworkImage(kid['avatar'])
                                                : null,
                                    child: kid['avatar'].endsWith('.svg')
                                        ? SvgPicture.asset(
                                            kid['avatar'],
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    kid['name'] ?? 'No Name',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Center(
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            color: Colors.white38,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                              width: 180,
                              text: 'Quick Transfer',
                              onPressed: () {
                                Get.to(() => const AllChildrenPage());
                              },
                              buttonStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: CustomThemeData().whiteColorText,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 60.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Send ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: CustomThemeData()
                                                  .primaryButtonColor,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                        text: 'or ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: CustomThemeData()
                                                    .secondaryTextColor,
                                                fontWeight: FontWeight.w600)),
                                    TextSpan(
                                        text: 'remove ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: CustomThemeData()
                                                    .primaryButtonColor,
                                                fontWeight: FontWeight.w600)),
                                    TextSpan(
                                        text:
                                            'money from your child\'s account',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: CustomThemeData()
                                                    .secondaryTextColor,
                                                fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}



/*

kid['avatar'] != null &&
                                            kid['avatar'].toString().isNotEmpty
                                        ? (kid['avatar'].startsWith('/')
                                            ? FileImage(File(kid[
                                                'avatar'])) // Load local image
                                            :  NetworkImage(kid[
                                                    'avatar']) // Load network image
                                                as ImageProvider) // Determine if it's a local or network image
                                        : const AssetImage(
                                            "assets/googlelogo.png"),

*/