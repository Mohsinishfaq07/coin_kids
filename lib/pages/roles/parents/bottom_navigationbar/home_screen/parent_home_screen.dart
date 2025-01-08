import 'dart:io';
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/pages/roles/parents/add_child/add_child_screen.dart';
import 'package:coin_kids/pages/roles/parents/all_childs/all_children_page.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:coin_kids/pages/roles/parents/drawer/drawer.dart';
import 'package:coin_kids/pages/roles/parents/kid_management/kid_profile_management_page.dart';
import 'package:coin_kids/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../theme/color_theme.dart';

class ParentsHomeScreen extends StatefulWidget {
  const ParentsHomeScreen({super.key});

  @override
  State<ParentsHomeScreen> createState() => _ParentsHomeScreenState();
}

class _ParentsHomeScreenState extends State<ParentsHomeScreen> {
  final ParentHomeController parentHomeController =
      Get.find<ParentHomeController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      parentHomeController.fetchParentDetails();
      parentHomeController.fetchKids();
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
          backgroundColor: const Color(0xFFCAF0FF),
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(
                    ParentDrawer(),
                    transition:
                        Transition.leftToRightWithFade, // Custom transition
                    duration:
                        const Duration(milliseconds: 300), // Animation duration
                  );
                },
                child: SizedBox(
                    width: 40.w, // Adjust the size of the border
                    height: 40.h, // Adjust the size of the border

                    child: SvgPicture.asset(
                        AppAssets.drawerIconSvg)),
              ),
              SizedBox(width: 7.5.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                        parentHomeController.parentName.value,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontSize: 18.sp),
                      )),
                  Text("Welcome 👋",
                      style: Theme.of(context).textTheme.bodySmall)
                ],
              ),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.background,
          ),
          child: Obx(
            () {
              if (parentHomeController.isLoading.value) {
                // Show loading indicator
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (parentHomeController.kidsList.isEmpty) {
                // No kids available
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 51.h,
                            bottom: 81.h,
                          ),
                          child: SvgPicture.asset(AppAssets.appLogoSvg,height: 50.h,),
                        ),
                        Container(
                          height: 177.h,
                          width: 328.w,
                          decoration: ShapeDecoration(
                              color: const Color(0xFFEDFAFF),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1.w, color: const Color(0xFFCBE4F3)),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              shadows: [
                                BoxShadow(
                                    color: const Color(0x0F000000),
                                    blurRadius: 6.r,
                                    offset: const Offset(0, 0),
                                    spreadRadius: 0)
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Almost There!",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                          color: CustomThemeData()
                                              .primaryButtonColor,
                                          fontSize: 18.sp)),
                              const SizedBox(height: 10),
                              Text("Start by adding your first child.",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: CustomThemeData()
                                              .primaryTextColor,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14.sp)),
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
                        itemCount: parentHomeController.kidsList.length +
                            1, // Add 1 for "Add" circle at the end
                        itemBuilder: (context, index) {
                          if (index == parentHomeController.kidsList.length) {
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
                            final kid = parentHomeController.kidsList[
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
                                          : (kid['avatar']
                                                      .startsWith('assets') &&
                                                  !kid['avatar']
                                                      .endsWith('.svg'))
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
                                  Get.to(() => AllChildrenPage());
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60.0),
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
          ),
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
