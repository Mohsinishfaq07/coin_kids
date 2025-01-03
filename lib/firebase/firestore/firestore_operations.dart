import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/dialogues/custom_dialogues.dart';
import 'package:coin_kids/pages/roles/parents/add_child/add_child_controller.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_screen.dart';
import 'package:coin_kids/pages/roles/parents/kid_management/quick_transfer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirestoreOperations {
  ParentFirebaseFunctions parentFirebaseFunctions = ParentFirebaseFunctions();
  ChildFirebaseFunctions childFirebaseFunctions = ChildFirebaseFunctions();
}

class ParentFirebaseFunctions {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  AddChildController addChildController = Get.put(AddChildController());
  final ParentHomeController homeController = Get.put(ParentHomeController());
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
          builder: (context) =>
              LoadingProgressDialogueWidget(title: "updating..",));

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
        Get.snackbar(
          "Success",
          "Profile updated successfully!",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.back(closeOverlays: true);
        Get.log('profile updated');
      } else {
        Get.snackbar(
          "Error",
          "User not logged in. Please log in again.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        "Error",
        "Failed to update profile: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      firebaseAuthController.isNormalLoading.value = false;
    }
  }

  // add child to parent
  Future<void> addChildAndUpdateParent() async {
    Get.log(
      'Adding new child with parent ID: ${FirebaseAuth.instance.currentUser!.uid} and normal loading value:${firebaseAuthController.isNormalLoading.value}',
    );
    if (addChildController.childName.value.isEmpty ||
        addChildController.childAge.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      firebaseAuthController.isNormalLoading.value = false;
      return;
    }

    try {
      showDialog(
          context: Get.context!,
          builder: (context) =>
              LoadingProgressDialogueWidget(title: "adding..",));
      final String avatarUrl = addChildController
              .selectedAvatarPath.value.isEmpty
          ? addChildController.customAvatarPath.value
          : addChildController.selectedAvatarPath.value; // Use selected avatar

      // Reference to the parent document
      DocumentReference parentRef = _firebaseFirestore
          .collection('parents')
          .doc(FirebaseAuth.instance.currentUser!.email);

      // Prepare child data
      final Map<String, dynamic> childData = {
        'name': addChildController.childName.value,
        'parentId': FirebaseAuth.instance.currentUser!.uid,
        'grade': 'Grade 1',
        'parent': parentRef,
        'avatar': avatarUrl,
        'age': addChildController.childAge.value,
        'savings': {
          'amount': '15', // Default savings value
          'color': '#227799',
          'name': 'Savings',
        },
        'spendings': {
          'amount': 45, // Default spendings value
          'color': '#F54422',
          'name': 'Spendings',
        },
      };

      // Add child and update parent in a transaction
      await _firebaseFirestore.runTransaction((transaction) async {
        DocumentReference newChildRef =
            _firebaseFirestore.collection('kids').doc();
        transaction.set(newChildRef, childData);
        transaction.update(parentRef, {
          'kids': FieldValue.arrayUnion([newChildRef])
        });
      });
      firebaseAuthController.isNormalLoading.value = false;
      Get.log(
        'Added new child with parent ID: ${FirebaseAuth.instance.currentUser!.uid} and normal loading value:${firebaseAuthController.isNormalLoading.value}',
      );
      Get.back();
      Get.to(() => const ParentsHomeScreen());

      Get.snackbar("Success", "Child added and parent updated successfully");
    } catch (e) {
      Get.back();
      firebaseAuthController.isNormalLoading.value = false;
      Get.snackbar("Error", "Failed to add child: $e");
      Get.log(
        'Error adding new child with parent ID: ${FirebaseAuth.instance.currentUser!.uid} and normal loading value:${firebaseAuthController.isNormalLoading.value}',
      );
      Get.log(e.toString());
    }
  }

  // update savings of child
  Future<void> updateSavings({
    required bool save,
    required String childId,
    required int enteredAmount,
  }) async {
    try {
      showDialog(
          context: Get.context!,
          builder: (context) => LoadingProgressDialogueWidget(title: "saving..",));
      DocumentReference kidDocRef =
          FirebaseFirestore.instance.collection('kids').doc(childId);

      DocumentSnapshot snapshot = await kidDocRef.get();

      if (snapshot.exists) {
        final currentSavings =
            (snapshot.data() as Map<String, dynamic>?)?['savings']?['amount'] ??
                0;
        int updatedAmount = 0;
        if (save) {
          updatedAmount = int.parse(currentSavings) + enteredAmount;
          Get.log("Current Savings Amount: $currentSavings");

          await kidDocRef.set({
            'savings': {'amount': updatedAmount.toString()},
          }, SetOptions(merge: true));
          Get.back();
          Get.log("Savings updated successfully to: $updatedAmount");
          showDialog(
            context: Get.context!,
            builder: (context) => TransferSuccessDialog(
              receiverName: snapshot['name'],
              amount: parentController.amount.toString(),
              dateTime: '01/10/23, 11:00 AM',
              title: 'Transfer Successful',
              transferType: 'received',
            ),
          );
        } else {
          if (enteredAmount >= int.parse(currentSavings)) {
            Get.back();
            parentController.amountValidation.value =
                'Not Enough Funds, can not remove';
          } else {
            Get.back();
            updatedAmount = int.parse(currentSavings) - enteredAmount;
            Get.log("Current Savings Amount: $currentSavings");

            await kidDocRef.set({
              'savings': {'amount': updatedAmount.toString()},
            }, SetOptions(merge: true));

            Get.log("Savings updated successfully to: $updatedAmount");
            showDialog(
              context: Get.context!,
              builder: (context) => TransferSuccessDialog(
                  receiverName: snapshot['name'],
                  amount: parentController.amount.toString(),
                  dateTime: '01/10/23, 11:00 AM',
                  title: 'Deduction Successful',
                  transferType: 'deducted'),
            );
          }
        }
      } else {
        Get.back();
        Get.log("Document does not exist for childId: $childId");
      }
    } catch (e) {
      Get.back();
      Get.log("Error updating savings: $e");
    }
  }
}

class ChildFirebaseFunctions {}
