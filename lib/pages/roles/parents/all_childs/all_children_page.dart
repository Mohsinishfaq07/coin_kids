import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/pages/roles/parents/kid_management/kid_profile_management_page.dart';
import 'package:coin_kids/pages/roles/parents/kid_management/quick_transfer.dart';
import 'package:coin_kids/theme/light_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AllChildrenPage extends StatelessWidget {
  const AllChildrenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "All Children",
        centerTitle: true,
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
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

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: PageController(
                        viewportFraction: 0.5,
                      ),
                      itemCount: documents.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        var dataKid =
                            documents[index].data() as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: GestureDetector(
                            onTap: () {
                              parentController.selectedChildIdForQuickTransfer
                                  .value = documents[index].id;
                              parentController.selectedChildNameForQuickTransfer
                                  .value = dataKid['name'];
                              Get.to(() => KidProfileManagementPage(
                                    childId: documents[index].id,
                                  ));
                            },
                            child: Container(
                              width: 150, // Width of each card
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                      '${dataKid['name']}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.purple,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: dataKid['avatar']
                                                .startsWith('/')
                                            ? FileImage(File(dataKid['avatar']))
                                            : (dataKid['avatar']
                                                        .startsWith('assets') &&
                                                    !dataKid['avatar']
                                                        .endsWith('.svg'))
                                                ? AssetImage(dataKid['avatar'])
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
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Available Money',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    '€ ${dataKid['savings']['amount']}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                          fontSize: 14,
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
                  )

                  // quickTransferFields(
                  //     onChanged: (val) {
                  //       parentController.amount.value = val;
                  //     },
                  //     keyboardType: const TextInputType.numberWithOptions(),
                  //     hintText: 'Enter Amount',
                  //     onTap: () {
                  //       parentController.amountValidation.value = '';
                  //     },
                  //     showPrefix: true),
                  // const SizedBox(height: 30),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Obx(() {
                  //       return CustomButton(
                  //         color: parentController.amount.value.isNotEmpty
                  //             ? Colors.purple
                  //             : Colors.grey,
                  //         text: '- Remove',
                  //         onPressed: () async {
                  // if (parentController.amount.value.isEmpty) {
                  //   parentController.amountValidation.value =
                  //       'Enter valid amount';
                  // } else if (parentController
                  //     .selectedChildIdForQuickTransfer.value.isEmpty) {
                  //   Get.snackbar('Alert',
                  //       'Please add child first by taping on it ');
                  // } else {
                  //   firestoreOperations.parentFirebaseFunctions
                  //       .updateSavings(
                  //           childId:
                  //               parentController
                  //                   .selectedChildIdForQuickTransfer
                  //                   .value,
                  //           enteredAmount:
                  //               int.parse(parentController.amount.value),
                  //           save: false);
                  // }
                  //         },
                  //         width: 150,
                  //       );
                  //     }),
                  //     Obx(() {
                  //       return CustomButton(
                  //         color: parentController.amount.value.isNotEmpty
                  //             ? Colors.purple
                  //             : Colors.grey,
                  //         text: '+ Send',
                  //         onPressed: () async {
                  // if (parentController.amount.value.isEmpty) {
                  //   parentController.amountValidation.value =
                  //       'Enter valid amount';
                  // } else if (parentController
                  //     .selectedChildIdForQuickTransfer.value.isEmpty) {
                  //   Get.snackbar('Alert',
                  //       'Please add child first by taping on it ');
                  // } else {
                  //   firestoreOperations.parentFirebaseFunctions
                  //       .updateSavings(
                  //           childId:
                  //               parentController
                  //                   .selectedChildIdForQuickTransfer
                  //                   .value,
                  //           enteredAmount:
                  //               int.parse(parentController.amount.value),
                  //           save: true);
                  // }
                  //         },
                  //         width: 150,
                  //       );
                  //     }),
                  //   ],
                  // )
                  ,
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: Obx(() {
                        return RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Send ',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors
                                  .purple, // Default color for non-bold text
                            ),
                            children: [
                              const TextSpan(
                                text: 'or ',
                                style: TextStyle(
                                  color: Colors.black, // Default color for "or"
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
                                  color: Colors
                                      .black, // Default color for the remaining text
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
                          .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  quickTransferFields(
                      onChanged: (val) {
                        parentController.amount.value = val;
                      },
                      keyboardType: const TextInputType.numberWithOptions(),
                      hintText: 'Enter Amount',
                      onTap: () {
                        parentController.amountValidation.value = '';
                      },
                      showPrefix: true),
                  Obx(() {
                    return parentController.amountValidation.value.isEmpty
                        ? const SizedBox.shrink()
                        : Text(parentController.amountValidation.value,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ));
                  }),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Leave a Message (Optional)',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  quickTransferFields(
                      onChanged: (val) {},
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'Remember to save money.',
                      onTap: () {},
                      showPrefix: false),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        return CustomButton(
                          color: parentController.amount.value.isNotEmpty
                              ? Colors.purple
                              : Colors.grey,
                          text: '- Remove',
                          onPressed: () async {
                            if (parentController.amount.value.isEmpty) {
                              parentController.amountValidation.value =
                                  'Enter valid amount';
                            } else if (parentController
                                .selectedChildIdForQuickTransfer
                                .value
                                .isEmpty) {
                              Get.snackbar('Alert',
                                  'Please add child first by taping on it ');
                            } else {
                              firestoreOperations.parentFirebaseFunctions
                                  .updateSavings(
                                      childId: parentController
                                          .selectedChildIdForQuickTransfer
                                          .value,
                                      enteredAmount: int.parse(
                                          parentController.amount.value),
                                      save: false);
                            }
                          },
                          width: 150,
                        );
                      }),
                      Obx(() {
                        return CustomButton(
                          color: parentController.amount.value.isNotEmpty
                              ? Colors.purple
                              : Colors.grey,
                          text: '+ Send',
                          onPressed: () async {
                            if (parentController.amount.value.isEmpty) {
                              parentController.amountValidation.value =
                                  'Enter valid amount';
                            } else if (parentController
                                .selectedChildIdForQuickTransfer
                                .value
                                .isEmpty) {
                              Get.snackbar('Alert',
                                  'Please add child first by taping on it ');
                            } else {
                              firestoreOperations.parentFirebaseFunctions
                                  .updateSavings(
                                      childId: parentController
                                          .selectedChildIdForQuickTransfer
                                          .value,
                                      enteredAmount: int.parse(
                                          parentController.amount.value),
                                      save: true);
                            }
                          },
                          width: 150,
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
    );
  }
}