import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/features/custom_widgets/custom_app_bar.dart';
import 'package:coin_kids/features/custom_widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class QuickTransferPage extends StatelessWidget {
  final dynamic docData;
  final String childId;
  const QuickTransferPage(
      {super.key, required this.docData, required this.childId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Quick Transfer",
        showBackButton: true,
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                quickTransferChildGeneralDetailWidget(childId: childId),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Send ',
                        style: const TextStyle(
                          fontSize: 14,
                          color:
                              Colors.purple, // Default color for non-bold text
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
                              color: Colors.purple, // Purple color for "remove"
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
                const Text(
                  'Enter amount',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
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
                const Text(
                  'Leave a Message (Optional)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
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
                          } else {
                            firestoreOperations.parentFirebaseFunctions
                                .updateSavings(
                                    childId: childId,
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
                          } else {
                            firestoreOperations.parentFirebaseFunctions
                                .updateSavings(
                                    childId: childId,
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
      final savings = docData['savings']?['amount']?.toString() ?? '0';

      return Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Child Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

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
                const SizedBox(height: 10),

                // Available Money
                const Text(
                  'Available Money',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 5),
                Text(
                  '\$ $savings',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class TransferSuccessDialog extends StatelessWidget {
  final String receiverName;
  final String amount;
  final String dateTime;
  final String title;
  final String transferType;

  const TransferSuccessDialog({
    super.key,
    required this.receiverName,
    required this.amount,
    required this.dateTime,
    required this.title,
    required this.transferType,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 10,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFB47CF7), // Purple background
              ),
              padding: const EdgeInsets.all(16),
              child: const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 16),

            // Transfer successful title
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 10),

            // Receiver information
            RichText(
              text: TextSpan(
                text: '$receiverName $transferType ',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                children: [
                  TextSpan(
                    text: '€ $amount',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Date & Time
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Time & date: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  dateTime,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
