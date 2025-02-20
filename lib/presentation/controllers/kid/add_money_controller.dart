import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AddMoneyController extends GetxController {
  RxDouble spendingAmount = 0.0.obs; // Changed to RxDouble
  RxDouble savingAmount = 0.0.obs; // Changed to RxDouble
  RxDouble totalValue = 0.00.obs; // Changed to RxDouble
  var clickedIndex = 0.obs; // Observable for the text
  RxBool isJarFilled = false.obs;
  RxList<double> droppedNotes = <double>[].obs; // Changed to double
  RxString spendingJarColor = ''.obs;
  RxString savingJarColor = ''.obs;

  Future<void> fetchSpendingColor() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('kids')
          .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        final colorString =
            data['spendings']?['color'] ?? "#000000"; // Default black color

        spendingJarColor.value = colorString;
        print('Updated spendingColor: ${spendingJarColor.value}');
      } else {
        print('No document found for the given parentId');
        spendingJarColor.value = "#000000"; // Default black color
      }
    } catch (e) {
      print('Error fetching spending color: $e');
      spendingJarColor.value = "#000000"; // Default black color
    }
  }

  // void onNoteDropped(String noteAsset) {
  //   try {
  //     // Extract numeric value from the asset name using regular expression
  //     final noteValueString = noteAsset.split('/').last.split('.').first;
  //     final noteValue =
  //         double.parse(RegExp(r'\d+').stringMatch(noteValueString)!);

  //     droppedNotes.add(noteValue);

  //     // Update the total value
  //     totalValue.value =
  //         droppedNotes.fold(0.0, (sum, value) => sum + value); // Changed to 0.0
  //   } catch (e) {
  //     print("Error parsing note asset: $e");
  //   }
  // }

  void onNoteDropped(String noteAsset) {
    try {
      // Check in all maps to get exact value
      double? noteValue = notesMap[noteAsset] ??
          firstCoinList[noteAsset] ??
          secondCoinList[noteAsset] ??
          thirdCoinList[noteAsset];

      if (noteValue == null) {
        print("Unknown asset: $noteAsset");
        return;
      }

      droppedNotes.add(noteValue);

      // Update the total value
      totalValue.value = droppedNotes.fold(0.0, (sum, value) => sum + value);
    } catch (e) {
      print("Error processing note asset: $e");
    }
  }

  void resetJar() {
    droppedNotes.clear();
    totalValue.value = 0.0; // Reset to 0.0
  }

  Future<void> fetchSpendingAmount() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('kids')
          .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        print('Fetched data: $data');

        final amount = data['spendings']?['amount'] ?? 0.0;
        spendingAmount.value = amount.toDouble(); // Converted to double
        print('Updated spendingAmount: ${spendingAmount.value}');
      } else {
        print('No document found for the given parentId');
        spendingAmount.value = 0.0; // Default to 0.0
      }
    } catch (e) {
      print('Error fetching spending amount: $e');
      spendingAmount.value = 0.0; // Default to 0.0
    }
  }

  Future<void> fetchSavingAmount() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('kids')
          .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        print('Fetched data: $data');

        final dynamic amount = data['savings']?['amount'];
        print('Raw amount value: $amount (${amount.runtimeType})');

        if (amount != null) {
          if (amount is String) {
            final sanitizedAmount = amount.trim();
            if (sanitizedAmount.isEmpty) {
              print('Empty amount string.');
              savingAmount.value = 0.0;
            } else if (RegExp(r'^\d+(\.\d+)?$').hasMatch(sanitizedAmount)) {
              savingAmount.value = double.parse(sanitizedAmount);
            } else {
              print('Invalid amount format: "$sanitizedAmount"');
              savingAmount.value = 0.0;
            }
          } else if (amount is int || amount is double) {
            savingAmount.value = amount.toDouble(); // Converted to double
          } else {
            print('Unsupported type for amount: $amount');
            savingAmount.value = 0.0;
          }
        } else {
          print('No savings.amount found in the document.');
          savingAmount.value = 0.0;
        }

        print('Updated savingAmount: ${savingAmount.value}');
      } else {
        print('No document found for the given parentId.');
        savingAmount.value = 0.00;
      }
    } catch (e) {
      print('Error fetching saving amount: $e');
      savingAmount.value = 0.0;
    }
  }

  void undoLastDrop() {
    if (droppedNotes.isNotEmpty) {
      droppedNotes.removeLast(); // Remove the last note from the list

      // Recalculate the total value
      totalValue.value =
          droppedNotes.fold(0.0, (sum, value) => sum + value); // Changed to 0.0
    }
  }

  final Map<String, double> notesMap = {
    "assets/5.png": 5.0,
    "assets/10.png": 10.0,
    "assets/20.png": 20.0,
    "assets/50.png": 50.0,
    "assets/100.png": 100.0,
    "assets/200.png": 200.0,
  };

  final Map<String, double> firstCoinList = {
    "assets/1euro.png": 1.0,
    "assets/2euros.png": 2.0,
  };

  final Map<String, double> secondCoinList = {
    "assets/50cent.png": 0.50,
    "assets/20cents.png": 0.20,
    "assets/10cents.png": 0.10,
  };

  final Map<String, double> thirdCoinList = {
    "assets/5cents.png": 0.05,
    "assets/2cents.png": 0.02,
    "assets/1cents.png": 0.01,
  };

  Future<void> fetchSavingsColor() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('kids')
          .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        final colorString =
            data['savings']?['color'] ?? "#000000"; // Default black color

        savingJarColor.value = colorString; // Convert and store
        print('Updated spendingColor: ${savingJarColor.value}');
      } else {
        print('No document found for the given parentId');
        savingJarColor.value = "#000000"; // Default black color
      }
    } catch (e) {
      print('Error fetching spending color: $e');
      savingJarColor.value = "#000000"; // Default black color
    }
  }

  Future<void> transferSpendingToSavings({
    required String childId,
    required double enteredAmount,
  }) async {
    try {
      DocumentReference kidDocRef =
          FirebaseFirestore.instance.collection('kids').doc(childId);

      DocumentSnapshot snapshot = await kidDocRef.get();

      if (!snapshot.exists) {
        // Create a new record if child data doesn't exist
        await kidDocRef.set({
          'spendings': {'amount': 0.0},
          'savings': {
            'amount': enteredAmount,
            'color': 0xFF000000,
            'name': "Savings"
          }
        });

        Get.log("New savings record created successfully.");
        return;
      }

      final data = snapshot.data() as Map<String, dynamic>;

      double currentSpending = (data['spendings']?['amount'] ?? 0.0).toDouble();
      double currentSavings = (data['savings']?['amount'] ?? 0.0).toDouble();

      if (enteredAmount > currentSpending) {
        Fluttertoast.showToast(
          msg: 'Not Enough Funds',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.textHighlighted,
          textColor: Colors.white,
          fontSize: 16.sp,
        );
        return;
      }

      // Update values
      double updatedSpending = currentSpending - enteredAmount;
      double updatedSavings = currentSavings + enteredAmount;
      int savingsJarColor = data['savings']?['color'] ?? 0xFF000000;

      await kidDocRef.set({
        'spendings': {'amount': updatedSpending},
        'savings': {
          'amount': updatedSavings,
          'color': savingsJarColor,
          'name': "Savings"
        }
      }, SetOptions(merge: true));

      Get.log(
          "Spending deducted and savings updated successfully.$updatedSpending ,$updatedSavings");
    } catch (e) {
      Get.log("Error transferring spendings to savings: $e");
    }
  }

  Future<void> transferSavingsToSpending({
    required String childId,
    required double enteredAmount,
  }) async {
    try {
      DocumentReference kidDocRef =
          FirebaseFirestore.instance.collection('kids').doc(childId);

      DocumentSnapshot snapshot = await kidDocRef.get();

      if (!snapshot.exists) {
        // Agar child data exist nahi karta, naya record bana do
        await kidDocRef.set({
          'spendings': {
            'amount': enteredAmount
          }, // Spendings ko update kar diya
          'savings': {'amount': 0.0, 'color': 0xFF000000, 'name': "Savings"}
        });

        Get.log("New spending record created successfully.");
        return;
      }

      final data = snapshot.data() as Map<String, dynamic>;

      double currentSpending = (data['spendings']?['amount'] ?? 0.0).toDouble();
      double currentSavings = (data['savings']?['amount'] ?? 0.0).toDouble();

      if (enteredAmount > currentSavings) {
        Fluttertoast.showToast(
          msg: 'Not Enough Savings',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.textHighlighted,
          textColor: Colors.white,
          fontSize: 16.sp,
        );
        return;
      }

      // **New Values After Transfer**
      double updatedSpending = currentSpending + enteredAmount;
      double updatedSavings = currentSavings - enteredAmount;
      int savingsJarColor = data['savings']?['color'] ?? 0xFF000000;

      await kidDocRef.set({
        'spendings': {'amount': updatedSpending},
        'savings': {
          'amount': updatedSavings,
          'color': savingsJarColor,
          'name': "Savings"
        }
      }, SetOptions(merge: true));

      Get.log(
          "Savings deducted and spending updated successfully. Savings: $updatedSavings, Spendings: $updatedSpending");
    } catch (e) {
      Get.log("Error transferring savings to spendings: $e");
    }
  }
}
