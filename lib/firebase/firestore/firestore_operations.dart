import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/core/constants/constants.dart';
import 'package:coin_kids/presentation/dialogs/kid/custom_dialogs.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_onboarding_controller.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../presentation/controllers/parent/add_child_controller.dart';
import '../../presentation/controllers/parent/parent_home_controller.dart';
import '../../presentation/dialogs/kid/transfer_dialog.dart';

class FirestoreOperations {
  ParentFirebaseFunctions parentFirebaseFunctions = ParentFirebaseFunctions();
}

class ParentFirebaseFunctions {
  String formatDate(DateTime date) {
    var formatter = DateFormat('dd/MM/yy, hh:mm a');
    return formatter.format(date);
  }

  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  AddChildController addChildController = Get.put(AddChildController());
  final ParentController homeController = Get.put(ParentController());
  final KidsOnBoardingController kidsOnBoardingController =
      Get.put(KidsOnBoardingController());
  // fetch the details of parent
  Stream<Map<String, dynamic>?> fetchParentData() {
    try {
      String? userEmail = FirebaseAuth.instance.currentUser?.email;

      if (userEmail == null) {
        return Stream.value(null);
      }

      DocumentReference parentDocRef =
          FirebaseFirestore.instance.collection('parents').doc(userEmail);

      return parentDocRef.snapshots().map((docSnapshot) {
        if (docSnapshot.exists) {
          return docSnapshot.data() as Map<String, dynamic>?;
        } else {
          return null;
        }
      });
    } catch (e) {
      Get.log('Error fetching document fields: $e');
      return Stream.value(null); // Return an empty stream on error
    }
  }

  Stream<Map<String, dynamic>?> fetchKidData() {
    try {
      String? userEmail = FirebaseAuth.instance.currentUser?.email;

      if (userEmail == null) {
        return Stream.value(null);
      }

      DocumentReference parentDocRef =
          FirebaseFirestore.instance.collection('kids').doc(userEmail);

      return parentDocRef.snapshots().map((docSnapshot) {
        if (docSnapshot.exists) {
          return docSnapshot.data() as Map<String, dynamic>?;
        } else {
          return null;
        }
      });
    } catch (e) {
      Get.log('Error fetching document fields: $e');
      return Stream.value(null); // Return an empty stream on error
    }
  }

  // get all the children related to current logged in parent

  Stream<List<DocumentSnapshot>> fetchChildrenForParent(String currentUserId) {
    return FirebaseFirestore.instance
        .collection('kids')
        .where('parentId', isEqualTo: currentUserId)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs);
  }

  // update the profile of parent
  Future<void> updateParentProfile() async {
    try {
      firebaseAuthController.isNormalLoading.value = true;
      showDialog(
          context: Get.context!,
          builder: (context) => LoadingProgressDialogueWidget(
                title: "updating..",
              ));

      // Update Firebase Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('parents')
            .doc(user.email)
            .update({
          'name': firebaseAuthController.username.value,
          'dob': firebaseAuthController.birthday.value,
          'gender': firebaseAuthController.selectedGender.value.isNotEmpty
              ? firebaseAuthController.selectedGender.value
              : 'Not specified',
        });
        homeController.parentName.value = firebaseAuthController.username.value;
        Get.back();
        ToastUtil.showToast(
          "Profile updated successfully!",
        );
        Get.back(closeOverlays: true);
        Get.log('profile updated');
      } else {
        ToastUtil.showToast(
          "User not logged in. Please log in again.",
        );
      }
    } catch (e) {
      Get.back();
      ToastUtil.showToast(
        "Failed to update profile: $e",
      );
    } finally {
      firebaseAuthController.isNormalLoading.value = false;
    }
  }

  // add child to parent
  Future<void> addKidAndUpdateParent() async {
    Get.log(
      'Adding new child with parent ID: ${FirebaseAuth.instance.currentUser!.uid} and normal loading value:${firebaseAuthController.isNormalLoading.value}',
    );
    if (addChildController.childName.value.isEmpty ||
        addChildController.childAge.isEmpty) {
      ToastUtil.showToast("All fields are required");
      firebaseAuthController.isNormalLoading.value = false;
      return;
    }

    try {
      showDialog(
          context: Get.context!,
          builder: (context) => LoadingProgressDialogueWidget(
                title: "adding..",
              ));
      final String avatarUrl = addChildController
                  .selectedAvatarPath.value.isEmpty &&
              addChildController.kidImagePath.value.isEmpty
          ? 'assets/default_profile_pic.png' // Default image URL if both are empty
          : addChildController.selectedAvatarPath.value.isEmpty
              ? addChildController.kidImagePath.value
              : addChildController
                  .selectedAvatarPath.value; // Use selected avatar
      // String avatarUrl = isSkip
      //     ? 'assets/default_profile_pic.png' // If skipped, use default image
      //     : addChildController.selectedAvatarPath.value.isNotEmpty
      //         ? addChildController
      //             .selectedAvatarPath.value // If manually selected, use that
      //         : kidsOnBoardingController.avatars[0];

      // Reference to the parent document
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      DocumentReference newChildRef =
          _firebaseFirestore.collection('kids').doc();
      String kidDocumentId = newChildRef.id;

      DocumentReference parentRef = _firebaseFirestore
          .collection('parents')
          .doc(FirebaseAuth.instance.currentUser!.email);

      String parentDocumentId =
          FirebaseAuth.instance.currentUser!.uid; // This is the parent ID
      print("Parent Document ID: $parentDocumentId");

      // Prepare child data
      final Map<String, dynamic> childData = {
        'kidId': kidDocumentId,
        'name': addChildController.childName.value,
        'parentId': FirebaseAuth.instance.currentUser!.uid,
        'grade': 'Grade 1',
        'parent': parentRef,
        'avatar': avatarUrl,
        'age': addChildController.childAge.value,
      };

      // Add child and update parent in a transaction
      await _firebaseFirestore.runTransaction((transaction) async {
        transaction.set(newChildRef, childData);
        transaction.update(parentRef, {
          'kids': FieldValue.arrayUnion([newChildRef])
        });
      });
      firebaseAuthController.isNormalLoading.value = false;
      Get.log(
        'Added new child with parent ID: ${FirebaseAuth.instance.currentUser!.uid} and normal loading value:${firebaseAuthController.isNormalLoading.value}',
      );
      // Get.off(() => ParentBottomNavigationBar());

      ToastUtil.showToast("Child added successfully");
    } catch (e) {
      Get.back();
      firebaseAuthController.isNormalLoading.value = false;
      ToastUtil.showToast("Failed to add child: $e");
      Get.log(
        'Error adding new child with parent ID: ${FirebaseAuth.instance.currentUser!.uid} and normal loading value:${firebaseAuthController.isNormalLoading.value}',
      );
      Get.log(e.toString());
    }
  }

  Future<void> updateKidSpending({
    required bool save,
    required String kidId,
    required double enteredAmount,
    required Color spendingJarColor,
  }) async {
    try {
      showDialog(
        context: Get.context!,
        builder: (context) => LoadingProgressDialogueWidget(
          title: "saving..",
        ),
      );

      DocumentReference kidDocRef =
          FirebaseFirestore.instance.collection('kids').doc(kidId);

      DocumentSnapshot snapshot = await kidDocRef.get();

      if (snapshot.exists) {
        // Check if 'spendings' exists, if not, initialize it with default values
        final currentSpending = (snapshot.data()
                as Map<String, dynamic>?)?['spendings']?['amount'] ??
            0.0; // Default to 0.0 if spendings don't exist
        double updatedAmount = 0.0;
        // Convert the color to hex string
        // String colorHex = spendingJarColor.value.toRadixString(16).padLeft(8, '0');
        String colorHex =
            '#${spendingJarColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}'; // Format like "#RRGGBB"

        // If the color is not already present, set the default color
        String currentColorHex = (snapshot.data()
                as Map<String, dynamic>?)?['spendings']?['color'] ??
            '#227799';

        // Update the spending jar color if it's new
        if (currentColorHex != colorHex) {
          await kidDocRef.update({
            'spendings.color': colorHex, // Update color
          });
        }
        if (save) {
          updatedAmount = currentSpending + enteredAmount;

          // Save the updated spending amount as a numeric value (double or int)
          await kidDocRef.set(
              {
                'spendings': {
                  'amount': updatedAmount, // Save as a numeric type
                  'color': colorHex, // Default color for spendings
                  'name': 'Spendings', // Default name for spendings
                  'kidId': kidId,
                }
              },
              SetOptions(
                  merge: true)); // Merge to avoid overwriting other fields
          Get.back();
          Get.log("Spending updated successfully to: $updatedAmount");

          // showDialog(
          //   context: Get.context!,
          //   builder: (context) => TransferSuccessDialog(
          //     receiverName: snapshot['name'],
          //     amount: homeController.amount.value,
          //     dateTime: formatDate(DateTime.now().toLocal()),
          //     title: 'Transfer Successful',
          //     transferType: 'received',
          //   ),
          //);
        } else {
          if (enteredAmount > currentSpending) {
            homeController.amountValidation.value = 'Not Enough Funds,';
            Get.back();
            ToastUtil.showToast("Not Enough Funds");
          } else {
            updatedAmount = currentSpending - enteredAmount;
            Get.log("Current Spending Amount: $currentSpending");

            // Save the updated spending amount as a numeric value (double or int)
            await kidDocRef.update({
              'spendings': {
                'amount': updatedAmount, // Save as a numeric type
                'color': colorHex, // Default color for spendings
                'name': 'Spendings', // Default name for spendings
              }
            });
            Get.back();
            Get.log("Spending updated successfully to: $updatedAmount");

            // showDialog(
            //   context: Get.context!,
            //   builder: (context) => TransferSuccessDialog(
            //     receiverName: snapshot['name'] ?? 'Unknown',
            //     amount: homeController.amount.value,
            //     dateTime: formatDate(DateTime.now().toLocal()),
            //     title: 'Deduction Successful',
            //     transferType: 'deducted',
            //   ),
            // );
          }
        }
      } else {
        Get.back();
        Get.log("Document does not exist for childId: $kidId");
      }
    } catch (e) {
      Get.back();
      Get.log("Error updating spendings: $e");
    }
  }

  Future<void> kidSpendingToSavings({
    required bool save,
    required String kidId,
    required double enteredAmount,
    required Color savingsJarColor,
  }) async {
    try {
      DocumentReference kidDocRef =
          FirebaseFirestore.instance.collection('kids').doc(kidId);

      DocumentSnapshot snapshot = await kidDocRef.get();

      if (snapshot.exists) {
        // Get current spending and savings
        final data = snapshot.data() as Map<String, dynamic>;

        // Get spending amount safely
        final currentSpending =
            (data['spendings']?['amount'] ?? 0.0).toDouble();

        // Get savings amount safely
        final savingsAmount = data['savings']?['amount'];
        double currentSavings = 0.0;

        if (savingsAmount is String) {
          currentSavings = double.tryParse(savingsAmount) ?? 0.0;
        } else if (savingsAmount != null) {
          currentSavings = (savingsAmount).toDouble();
        }

        if (enteredAmount > currentSpending) {
          // Not enough funds
          // Get.back();
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

        // Deduct from spending and add to savings
        double updatedSpending = currentSpending - enteredAmount;
        double updatedSavings = currentSavings + enteredAmount;

        // Get color from spendings (if available), else use default black
        final int savingsJarColor = data['savings']?['color'] ?? 0xFF000000;

        // Update Firestore document
        await kidDocRef.set({
          'spendings': {
            'amount': updatedSpending,
          },
          'savings': {
            'amount': updatedSavings,
            'color': savingsJarColor, // Use the same color as spendings
            'name': "Savings", // Static name for savings
          }
        }, SetOptions(merge: true));

        Get.log("Spending deducted and savings updated successfully.");
      } else {
        // If child document does not exist, create it with default values
        await kidDocRef.set({
          'spendings': {
            'amount': 0.0,
          },
          'savings': {
            'amount': enteredAmount,
            'color': savingsJarColor, // Default black color
            'name': "Savings",
          }
        });

        Get.log("New savings record created successfully.");

        // Get.to(() => AddMoneyScreen(
        //       isSpending: false.obs, amount: null, jarColor: null,
        //     ));
      }
    } catch (e) {
      Get.back();
      Get.log("Error transferring spendings to savings: $e");
    }
  }

  var selectedColorIndex = (-1).obs; // Default to no selection
  RxBool isSelected = false.obs; //

  Future<void> updateKidSpendingForJar({
    required bool save,
    required String kidId,
    required double enteredAmount,
    required Color spendingJarColor,
  }) async {
    try {
      // showDialog(
      //   context: Get.context!,
      //   builder: (context) => LoadingProgressDialogueWidget(
      //     title: "saving..",
      //   ),
      // );

      DocumentReference kidDocRef =
          FirebaseFirestore.instance.collection('kids').doc(kidId);

      DocumentSnapshot snapshot = await kidDocRef.get();

      if (snapshot.exists) {
        // Check if 'spendings' exists, if not, initialize it with default values
        final currentSpending = (snapshot.data()
                as Map<String, dynamic>?)?['spendings']?['amount'] ??
            0.0; // Default to 0.0 if spendings don't exist
        double updatedAmount = 0.0;
        // Convert the color to hex string
        // String colorHex = spendingJarColor.value.toRadixString(16).padLeft(8, '0');
        String colorHex =
            '#${spendingJarColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}'; // Format like "#RRGGBB"

        // If the color is not already present, set the default color
        String currentColorHex = (snapshot.data()
                as Map<String, dynamic>?)?['spendings']?['color'] ??
            '#227799';

        // Update the spending jar color if it's new
        if (currentColorHex != colorHex) {
          await kidDocRef.update({
            'spendings.color': colorHex, // Update color
          });
        }
        if (save) {
          updatedAmount = currentSpending + enteredAmount;

          // Save the updated spending amount as a numeric value (double or int)
          await kidDocRef.set(
              {
                'spendings': {
                  'amount': updatedAmount, // Save as a numeric type
                  'color': colorHex, // Default color for spendings
                  'name': 'Spendings', // Default name for spendings
                  'kidId': kidId,
                }
              },
              SetOptions(
                  merge: true)); // Merge to avoid overwriting other fields
          Get.back();
          Get.log("Spending updated successfully to: $updatedAmount");

          // showDialog(
          //   context: Get.context!,
          //   builder: (context) => TransferSuccessDialog(
          //     receiverName: snapshot['name'],
          //     amount: homeController.amount.value,
          //     dateTime: formatDate(DateTime.now().toLocal()),
          //     title: 'Transfer Successful',
          //     transferType: 'received',
          //   ),
          // );
        } else {
          if (enteredAmount > currentSpending) {
            homeController.amountValidation.value = 'Not Enough Funds,';
            Get.back();

            Fluttertoast.showToast(
              msg: 'Not Enough Funds', // Message to display
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: AppColors.textHighlighted,
              textColor: Colors.white,
              fontSize: 16.sp,
            );
          } else {
            updatedAmount = currentSpending - enteredAmount;
            Get.log("Current Spending Amount: $currentSpending");

            // Save the updated spending amount as a numeric value (double or int)
            await kidDocRef.update({
              'spendings': {
                'amount': updatedAmount, // Save as a numeric type
                'color': colorHex, // Default color for spendings
                'name': 'Spendings', // Default name for spendings
              }
            });
            Get.back();
            Get.log("Spending updated successfully to: $updatedAmount");

            showDialog(
              context: Get.context!,
              builder: (context) => TransferSuccessDialog(
                receiverName: snapshot['name'] ?? 'Unknown',
                amount: homeController.amount.value,
                dateTime: formatDate(DateTime.now().toLocal()),
                title: 'Deduction Successful',
                transferType: 'deducted',
              ),
            );
          }
        }
      } else {
        Get.back();
        Get.log("Document does not exist for childId: $kidId");
      }
    } catch (e) {
      Get.back();
      Get.log("Error updating spendings: $e");
    }
  }
}
