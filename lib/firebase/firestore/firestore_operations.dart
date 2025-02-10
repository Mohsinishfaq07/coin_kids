import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/constants/constants.dart';
import 'package:coin_kids/dialogues/custom_dialogues.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/custom_widgets/toast_widget.dart';
import 'package:coin_kids/pages/roles/kid_landscape_section/main_screens/add_money.dart';
import 'package:coin_kids/pages/roles/parents/add_child/add_child_controller.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_home_controller.dart';
import 'package:coin_kids/theme/color_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../dialogues/transfer_dialog.dart';

class FirestoreOperations {
  ParentFirebaseFunctions parentFirebaseFunctions = ParentFirebaseFunctions();
  // ChildFirebaseFunctions childFirebaseFunctions = ChildFirebaseFunctions();
}

class ParentFirebaseFunctions {
  String formatDate(DateTime date) {
    var formatter = DateFormat('dd/MM/yy, hh:mm a');
    return formatter.format(date);
  }

  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  AddChildController addChildController = Get.put(AddChildController());
  final ParentController homeController = Get.put(ParentController());
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
      final String avatarUrl =
          addChildController.selectedAvatarPath.value.isEmpty &&
                  addChildController.kidImagePath.value.isEmpty
              ? 'assets/defaultImage.png' // Default image URL if both are empty
              : addChildController.selectedAvatarPath.value.isEmpty
                  ? addChildController.kidImagePath.value
                  : addChildController
                      .selectedAvatarPath.value; // Use selected avatar

      // Reference to the parent document
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

      DocumentReference parentRef = _firebaseFirestore
          .collection('parents')
          .doc(FirebaseAuth.instance.currentUser!.email);
      DocumentReference newChildRef =
          _firebaseFirestore.collection('kids').doc();
      String kidDocumentId = newChildRef.id; // Extracting the child document ID

      // Prepare child data
      final Map<String, dynamic> childData = {
        'kidId': kidDocumentId,
        'name': addChildController.childName.value,
        // 'kidId': kidRef.id,
        'parentId': FirebaseAuth.instance.currentUser!.uid,
        'grade': 'Grade 1',
        'parent': parentRef,
        'avatar': avatarUrl,
        'age': addChildController.childAge.value,
        // 'savings': {
        //   'amount': 0.0, // Default savings value
        //   'color': '#227799',
        //   'name': 'Savings',
        // },
        // 'spendings': {
        //   'amount': 0.0, // Default spendings value
        //   'color': '#F54422',
        //   'name': 'Spendings',
        // },
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

  // Future<void> SpendingTOGoals({
  //   required String kidId,
  //   required String goalId,
  //   required double enteredAmount,
  // }) async {
  //   try {
  //     DocumentReference kidDocRef =
  //         FirebaseFirestore.instance.collection('kids').doc(kidId);
  //     DocumentReference goalDocRef =
  //         FirebaseFirestore.instance.collection('goals').doc(goalId);

  //     // Fetch current spending details
  //     DocumentSnapshot kidSnapshot = await kidDocRef.get();
  //     if (!kidSnapshot.exists) {
  //       Get.back();
  //       Get.log("Kid document not found: $kidId");
  //       return;
  //     }

  //     double currentSpending = (kidSnapshot.data()
  //             as Map<String, dynamic>?)?['spendings']?['amount'] ??
  //         0.0;

  //     if (enteredAmount > currentSpending) {
  //       ToastUtil.showToast('Not Enough Funds');

  //       return;
  //     }

  //     // Deduct from spending
  //     double updatedSpending = currentSpending - enteredAmount;

  //     // Update spending in `kids` collection
  //     await kidDocRef.update({
  //       'spendings.amount': updatedSpending,
  //     });

  //     // Fetch existing goal amount
  //     DocumentSnapshot goalSnapshot = await goalDocRef.get();
  //     if (!goalSnapshot.exists) {
  //       Get.back();
  //       Get.log("Goal document not found: ");
  //       return;
  //     }
  //     double currentGoalAmount =
  //         (goalSnapshot.data() as Map<String, dynamic>?)?['currentAmount']
  //                 ?.toDouble() ??
  //             0.0;
  //     double goalAmount =
  //         (goalSnapshot.data() as Map<String, dynamic>?)?['amount']
  //                 ?.toDouble() ??
  //             0.0;
  //     if (currentGoalAmount + enteredAmount > goalAmount) {
  //       ToastUtil.showToast('Goal amount already reached!');
  //       return; // Prevent further processing if goal amount is exceeded
  //     }

  //     double updatedGoalAmount = currentGoalAmount + enteredAmount;

  //     // Update or create goal document in `goals` collection
  //     await goalDocRef.update(
  //       {
  //         'kidId': kidId,
  //         'currentAmount': updatedGoalAmount,
  //       },
  //     );
  //     if (updatedGoalAmount >= goalAmount) {
  //       await goalDocRef.update({
  //         'completed': true,
  //       });
  //       Get.log("Goal completed!");
  //     }

  //     Get.log(
  //         "Funds moved successfully: $enteredAmount transferred from Spendings to Goals.");
  //     ToastUtil.showToast(
  //       'Funds moved to Goals successfully!',
  //     );
  //   } catch (e) {
  //     Get.back();
  //     Get.log("Error transferring funds: $e");
  //   }
  // }
  var previousValue = 0.0.obs;
  Future<void> GoalsTOSpending({
    required String kidId,
    required String goalId,
    required double enteredAmount,
  }) async {
    try {
      // References to Firestore collections
      DocumentReference kidDocRef =
          FirebaseFirestore.instance.collection('kids').doc(kidId);
      DocumentReference goalDocRef =
          FirebaseFirestore.instance.collection('goals').doc(goalId);

      // Fetch current spending details
      DocumentSnapshot kidSnapshot = await kidDocRef.get();
      if (!kidSnapshot.exists) {
        Get.back();
        Get.log("Kid document not found: $kidId");
        return;
      }

      double currentSpending = (kidSnapshot.data()
              as Map<String, dynamic>?)?['spendings']?['amount'] ??
          0.0;

      if (enteredAmount > currentSpending) {
        Get.back();
        ToastUtil.showToast('Not Enough Funds');

        return;
      }

      // Deduct from spending
      double updatedSpending = currentSpending + enteredAmount;

      // Update spending in `kids` collection
      await kidDocRef.update({
        'spendings.amount': updatedSpending,
      });

      // Fetch existing goal amount
      DocumentSnapshot goalSnapshot = await goalDocRef.get();
      if (!goalSnapshot.exists) {
        Get.back();
        Get.log("Goal document not found: ");
        return;
      }
      double currentGoalAmount =
          (goalSnapshot.data() as Map<String, dynamic>?)?['currentAmount']
                  ?.toDouble() ??
              0.0;

      double updatedGoalAmount = currentGoalAmount - enteredAmount;

      // Update or create goal document in `goals` collection
      await goalDocRef.update(
        {
          'kidId': kidId,
          'currentAmount': updatedGoalAmount,
        },
      );

      // Get.back();
      Get.log(
          "Funds moved successfully: $enteredAmount transferred from Spendings to Goals.");
      ToastUtil.showToast('Funds moved to Spendings successfully!');
    } catch (e) {
      Get.back();
      Get.log("Error transferring funds: $e");
    }
  }

  Future<void> SpendingTOGoals({
    required String kidId,
    required String goalId,
    required double enteredAmount,
  }) async {
    try {
      DocumentReference kidDocRef =
          FirebaseFirestore.instance.collection('kids').doc(kidId);
      DocumentReference goalDocRef =
          FirebaseFirestore.instance.collection('goals').doc(goalId);

      // Fetch current spending details
      DocumentSnapshot kidSnapshot = await kidDocRef.get();
      if (!kidSnapshot.exists) {
        Get.back();
        Get.log("Kid document not found: $kidId");
        return;
      }

      double currentSpending = (kidSnapshot.data()
              as Map<String, dynamic>?)?['spendings']?['amount'] ??
          0.0;

      // Fetch existing goal amount
      DocumentSnapshot goalSnapshot = await goalDocRef.get();
      if (!goalSnapshot.exists) {
        Get.back();
        Get.log("Goal document not found: ");
        return;
      }

      double currentGoalAmount =
          (goalSnapshot.data() as Map<String, dynamic>?)?['currentAmount']
                  ?.toDouble() ??
              0.0;
      double goalAmount =
          (goalSnapshot.data() as Map<String, dynamic>?)?['amount']
                  ?.toDouble() ??
              0.0;

      // Check if the goal is already completed (currentGoalAmount >= goalAmount)
      if (currentGoalAmount == goalAmount) {
        ToastUtil.showToast('Goal already achieved!');
        return; // If goal is already reached, prevent any changes
      }

      if (enteredAmount > currentSpending) {
        ToastUtil.showToast('Not Enough Funds');
        return;
      }

      if (enteredAmount > goalAmount) {
        ToastUtil.showToast('Not Enough Funds');
        return;
      }

      // Deduct from spending only if goal is not completed
      double updatedSpending = currentSpending - enteredAmount;

      // Update spending in `kids` collection
      await kidDocRef.update({
        'spendings.amount': updatedSpending,
      });

      // Prevent exceeding the goalAmount while updating goal
      if (currentGoalAmount + enteredAmount > goalAmount) {
        ToastUtil.showToast('Goal amount already reached!');
        return; // Prevent further processing if goal amount is exceeded
      }

      // Update goal amount
      double updatedGoalAmount = currentGoalAmount + enteredAmount;
      int completionPercentage =
          ((updatedGoalAmount / goalAmount) * 100).toInt();

      // Update goal document in `goals` collection
      await goalDocRef.update({
        'kidId': kidId,
        'currentAmount': updatedGoalAmount,
        'progress': completionPercentage,
      });

      // Mark goal as completed if the goal is fully achieved
      if (updatedGoalAmount >= goalAmount) {
        await goalDocRef.update({
          'completed': true,
        });
        Get.log("Goal completed!");
      }
      previousValue.value = 0.0;
      Get.log(
          "Funds moved successfully: $enteredAmount transferred from Spendings to Goals.");
      ToastUtil.showToast(
        'Funds moved to Goals successfully!',
      );
    } catch (e) {
      Get.back();
      Get.log("Error transferring funds: $e");
    }
  }
}
