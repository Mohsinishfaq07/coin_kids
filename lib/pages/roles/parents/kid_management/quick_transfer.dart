import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/app_assets.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/custom_widgets/custom_text_field.dart';
import 'package:coin_kids/features/custom_widgets/quick_transfer_text_field.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
 import 'package:coin_kids/theme/components/AppButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../theme/color_theme.dart';

class QuickTransferPage extends StatelessWidget {
  final dynamic docData;
  final String kidId;
  const QuickTransferPage(
      {super.key, required this.docData, required this.kidId});

  @override
  Widget build(BuildContext context) {
      final parentController = Get.put(ParentController());

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Quick Transfer",
        showBackButton: true,
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.background,
            ),
            child: Stack(children: [
              SvgPicture.asset(
                AppAssets.cloudImageSvg,
                width: 400.w,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    quickTransferChildGeneralDetailWidget(childId: kidId),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Send ',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,

                              color: AppColors
                                  .textHighlighted, // Default color for non-bold text
                            ),
                            children: [
                              const TextSpan(
                                text: 'or ',
                                style: TextStyle(
                                  color: Colors.black, // Default color for "or"
                                ),
                              ),
                              TextSpan(
                                text: 'remove ',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,

                                  color: AppColors
                                      .textHighlighted, // Purple color for "remove"
                                ),
                              ),
                              TextSpan(
                                text:
                                    'money\nfrom your ${docData['name']}\'s account',
                                style: const TextStyle(
                                  color: Colors
                                      .black, // Default color for the remaining text
                                ),
                              ),
                            ],
                          ),
                        ),
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
                    SizedBox(height: 12.h),
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
                                double enteredAmount =
                                    double.parse(parentController.amount.value);

                                await firestoreOperations
                                    .parentFirebaseFunctions
                                    .updateKidSpending(
                                        kidId: kidId,
                                        enteredAmount: enteredAmount,
                                        save: false,
                                        spendingJarColor: AppColors.textPrimary
                                        );
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
                                try {
                                  double enteredAmount = double.parse(
                                      parentController.amount.value);

                                  await firestoreOperations
                                      .parentFirebaseFunctions
                                      .updateKidSpending(
                                          kidId: kidId,
                                          enteredAmount: enteredAmount,
                                          save: true,
                                          
                                          
                                          spendingJarColor: AppColors.textPrimary
                                          );
                                } on Exception catch (e) {
                                  print("Exception $e");
                                }
                              }
                            },
                          );
                        }),
                      ],
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

quickTransferFields({
  required Function()? onTap,
  required Function(String)? onChanged,
  required TextInputType? keyboardType,
  required String hintText,
  required bool showPrefix,
}) {
  return TextField(
    onTap: onTap,
    onChanged: onChanged,

    keyboardType: keyboardType,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white38, // Background color for the text field
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey), // Hint text color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.grey, // Border color when unfocused
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.grey, // Border color when enabled
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.blue, // Border color when focused
            width: 2.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        prefixIcon: showPrefix
            ? const Icon(
                Icons.money,
                color: Colors.blue,
              )
            : const SizedBox.shrink()),
    style: const TextStyle(color: Colors.black), // Input text color
  );
}

Widget quickTransferChildGeneralDetailWidget({required String childId}) {
  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance
        .collection('kids')
        .doc(childId)
        .snapshots(), // Stream for the specific child document
    builder: (context, snapshot) {
      // Loading State
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      // Error State
      if (snapshot.hasError) {
        return const Center(child: Text('Error loading child details'));
      }

      // Check if document does not exist
      if (!snapshot.hasData || !snapshot.data!.exists) {
        return const Center(
          child: Text(
            'Child details not found!',
            style: TextStyle(fontSize: 16),
          ),
        );
      }

      // Extract document data safely
      var docData = snapshot.data!.data() as Map<String, dynamic>;

      // Default values if fields are null
      final name = docData['name'] ?? 'Unknown Name';
      final savings = docData['spendings']?['amount']?.toString() ?? '0';

      return Center(
        child: Container(
          width: 126.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Child Name
                  Text(
                    name,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14.sp,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Child Avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: docData['avatar'].startsWith('/')
                        ? FileImage(File(docData['avatar']))
                        : (docData['avatar'].startsWith('assets') &&
                                !docData['avatar'].endsWith('.svg'))
                            ? AssetImage(docData['avatar'])
                            : docData['avatar'].startsWith('http')
                                ? NetworkImage(docData['avatar'])
                                : null,
                    child: docData['avatar'].endsWith('.svg')
                        ? SvgPicture.asset(
                            docData['avatar'],
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  SizedBox(height: 8.h),

                  // Available Money
                  Text(
                    'Available Money',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '\$ $savings',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
