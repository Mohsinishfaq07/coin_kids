import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:coin_kids/pages/roles/parents/kid_management/kid_profile_management_page.dart';
import 'package:coin_kids/pages/roles/parents/kid_management/quick_transfer.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var dataKid =
                        documents[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 15,
                        backgroundImage: dataKid['avatar'].startsWith('/')
                            ? FileImage(File(dataKid['avatar']))
                            : (dataKid['avatar'].startsWith('assets') &&
                                    !dataKid['avatar'].endsWith('.svg'))
                                ? AssetImage(dataKid['avatar'])
                                : dataKid['avatar'].startsWith('http')
                                    ? NetworkImage(dataKid['avatar'])
                                    : null,
                        child: dataKid['avatar'].endsWith('.svg')
                            ? SvgPicture.asset(
                                dataKid['avatar'],
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      title: Text(dataKid['name']),
                      trailing: Text(dataKid['age']),
                      onTap: () {
                        // Get.to(
                        //   () => KidProfileManagementPage(
                        //     childId: documents[index].id,
                        //   ),
                        // );
                        parentController.selectedChildIdForQuickTransfer.value =
                            documents[index].id;
                        Get.log(
                            'selectedChildIdForQuickTransfer: ${parentController.selectedChildIdForQuickTransfer.value}');
                      },
                    );
                  },
                ),
              ),
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
                            .selectedChildIdForQuickTransfer.value.isEmpty) {
                          Get.snackbar('Alert',
                              'Please add child first by taping on it ');
                        } else {
                          firestoreOperations.parentFirebaseFunctions
                              .updateSavings(
                                  childId:
                                      parentController
                                          .selectedChildIdForQuickTransfer
                                          .value,
                                  enteredAmount:
                                      int.parse(parentController.amount.value),
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
                            .selectedChildIdForQuickTransfer.value.isEmpty) {
                          Get.snackbar('Alert',
                              'Please add child first by taping on it ');
                        } else {
                          firestoreOperations.parentFirebaseFunctions
                              .updateSavings(
                                  childId:
                                      parentController
                                          .selectedChildIdForQuickTransfer
                                          .value,
                                  enteredAmount:
                                      int.parse(parentController.amount.value),
                                  save: true);
                        }
                      },
                      width: 150,
                    );
                  }),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
