import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';
import 'package:coin_kids/features/custom_widgets/quick_transfer_text_field.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:coin_kids/theme/components/AppButton.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../../app_assets.dart';
import '../../../../theme/color_theme.dart';

class AllChildrenPage extends StatelessWidget {
  final parentController = Get.find<ParentController>();
  AllChildrenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Quick transfer",
        centerTitle: true,
        showBackButton: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.background,
        ),
        child: Stack(children: [
          SvgPicture.asset(
            AppAssets.cloudImageSvg,
            width: 400.w,
          ),
          StreamBuilder<List<DocumentSnapshot>>(
            stream: firestoreOperations.parentFirebaseFunctions
                .fetchChildrenForParent(FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No documents found');
              }

              List<DocumentSnapshot> documents = snapshot.data!;
              if (parentController
                      .selectedChildIdForQuickTransfer.value.isEmpty &&
                  documents.isNotEmpty) {
                var firstKid = documents.first.data() as Map<String, dynamic>;
                parentController.selectedChildIdForQuickTransfer.value =
                    documents.first.id;
                parentController.selectedChildNameForQuickTransfer.value =
                    firstKid['name'];
              }

              return Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: CarouselSlider.builder(
                          options: CarouselOptions(
                            height: 180.h,

                            viewportFraction:
                                0.5, // Controls the size of each slide
                            enableInfiniteScroll:
                                false, // Enable/Disable infinite scrolling
                            enlargeCenterPage:
                                true, // Makes the centered slide larger
                            scrollDirection:
                                Axis.horizontal, // Scroll direction
                            onPageChanged: (index, reason) {
                              // Update the selected child index when the carousel slides
                              var dataKid = documents[index].data()
                                  as Map<String, dynamic>;
                              parentController.selectedChildIdForQuickTransfer
                                  .value = documents[index].id;
                              parentController.selectedChildNameForQuickTransfer
                                  .value = dataKid['name'];
                            },
                          ),
                          itemCount: documents.length,
                          itemBuilder: (context, index, realIndex) {
                            var dataKid =
                                documents[index].data() as Map<String, dynamic>;
                            return GestureDetector(
                              onTap: () {
                                parentController.selectedChildIdForQuickTransfer
                                    .value = documents[index].id;
                                parentController
                                    .selectedChildNameForQuickTransfer
                                    .value = dataKid['name'];
                              },
                              child: Container(
                                height: 164.h,
                                width: 126.w,
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFEDFAFF),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1.w, color: Color(0xFFCBE4F3)),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x0F000000),
                                      blurRadius: 6,
                                      offset: Offset(0, 0),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${dataKid['name']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 9.5.h, bottom: 8.h),
                                        child: CircleAvatar(
                                          radius: 30.r,
                                          backgroundImage: dataKid['avatar']
                                                  .startsWith('/')
                                              ? FileImage(
                                                  File(dataKid['avatar']))
                                              : (dataKid['avatar'].startsWith(
                                                          'assets') &&
                                                      !dataKid['avatar']
                                                          .endsWith('.svg'))
                                                  ? AssetImage(
                                                      dataKid['avatar'])
                                                  : dataKid['avatar']
                                                          .startsWith('http')
                                                      ? NetworkImage(
                                                          dataKid['avatar'])
                                                      : null,
                                          child:
                                              dataKid['avatar'].endsWith('.svg')
                                                  ? SvgPicture.asset(
                                                      dataKid['avatar'],
                                                      fit: BoxFit.cover,
                                                    )
                                                  : null,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 6.h,
                                      ),
                                      Text(
                                        'Available Money',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey),
                                      ),
                                      SizedBox(
                                        height: 6.h,
                                      ),
                                      Text(
                                        '€ ${dataKid['spendings']['amount']}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Center(
                          child: Obx(() {
                            return RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Send ',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors
                                      .purple, // Default color for non-bold text
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'or ',
                                    style: TextStyle(
                                      color: Colors
                                          .black, // Default color for "or"
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: 'remove ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .purple, // Purple color for "remove"
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'money\nfrom ${parentController.selectedChildNameForQuickTransfer.value}\'s account',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Enter amount',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                  fontSize: 14.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      QuickTransferTextField(
                          hintText: "0,00",
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            parentController.amount.value = val;
                          },
                          prefix: SvgPicture.asset("assets/currency_euro.svg")),
                      SizedBox(height: 24.h),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text.rich(
                          TextSpan(
                            text: 'Leave a Message ', // Default text
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                  fontSize: 14.h,
                                  fontWeight: FontWeight.bold,
                                ),
                            children: [
                              TextSpan(
                                text: '(Optional)', // Optional in gray color
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                      fontSize: 14.h,
                                      fontFamily: 'Open Sans',
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w100,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      CustomTextField(
                        titleText: "Leave a Message",
                        hintText: "e.g Remember to save some money",
                        keyboardType: TextInputType.name,
                        isOptional: true,
                        onChanged: (val) {},
                      ),
                      SizedBox(height: 27.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Obx(() {
                            return AppButton(
                              size: Size(125.w, 50.h),
                              text: '- Remove',
                              backgroundColor:
                                  parentController.amount.value.isNotEmpty
                                      ? AppColors.buttonPrimary
                                      : AppColors.buttonDisabled,
                              onPressed: () async {
                                if (parentController.amount.value.isEmpty) {
                                  parentController.amountValidation.value =
                                      'Enter valid amount';
                                } else {
                                  double enteredAmount = double.parse(
                                      parentController.amount.value);
                               await   firestoreOperations.parentFirebaseFunctions
                                      .updateKidSpending(
                                          childId: parentController
                                              .selectedChildIdForQuickTransfer
                                              .value,
                                          enteredAmount: enteredAmount,
                                          save: false, spendingJarColor: AppColors.textPrimary);
                                  // parentController.amount.value = "";
                                }
                              },
                            );
                          }),
                          Obx(() {
                            return AppButton(
                              size: Size(125.w, 50.h),
                              text: '+ Send',
                              backgroundColor:
                                  parentController.amount.value.isNotEmpty
                                      ? AppColors.buttonPrimary
                                      : AppColors.buttonDisabled,
                              onPressed: () async {
                                if (parentController.amount.value.isEmpty) {
                                  parentController.amountValidation.value =
                                      'Enter valid amount';
                                } else {
                                  double enteredAmount = double.parse(
                                      parentController.amount.value);

                                  await firestoreOperations
                                      .parentFirebaseFunctions
                                      .updateKidSpending(
                                          childId: parentController
                                              .selectedChildIdForQuickTransfer
                                              .value,
                                          enteredAmount: enteredAmount,
                                          save: true,
                                          
                                          spendingJarColor: AppColors.textPrimary
                                          );
                                  // parentController.amount.value = "";
                                }
                              },
                            );
                          }),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}
