import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/pages/roles/kid/kid_model_class.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ParentController extends GetxController {
  var parentId = ''
      .obs; // Parent ID (can be passed dynamically or fetched from authentication)
  var kidsList = [].obs; // List to store kids data
  var isLoading = true.obs;
  var parentName = ''.obs; // Observable to hold the parent's name
  var kidName = ''.obs; //
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxString selectedChildIdForQuickTransfer = ''.obs;
  RxString selectedChildNameForQuickTransfer = ''.obs;

  // controller values  for parent quick transfer
  RxString amount = ''.obs;
  RxString message = ''.obs;
  RxString amountValidation = ''.obs;

  // Add any controller logic if needed (e.g., API calls, navigation)

  @override
  void onInit() {
    super.onInit();
    fetchParentDetails();
    // fetchKids();
  }

  Future<bool> fetchKids() async {
    // Get.log('kids app parent id in starting:${FirebaseAuth.instance.currentUser!.uid}');
    try {
      isLoading.value = true; // Start loading

      // Fetch the initial snapshot
      final QuerySnapshot initialSnapshot = await _firestore
          .collection('kids')
          .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      // Process the initial data
      kidsList.value = initialSnapshot.docs.map((doc) {
        var docData = doc.data() as Map<String, dynamic>?;
        if (docData != null) {
          docData['id'] = doc.id;
          Get.log('kids app doc id: ${doc.id}');
        }
        return docData ?? {};
      }).toList();

      // Listen to updates for real-time changes
      _firestore
          .collection('kids')
          .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        kidsList.value = snapshot.docs.map((doc) {
          var docData = doc.data() as Map<String, dynamic>?;
          if (docData != null) {
            docData['id'] = doc.id;
            Get.log('kids app doc id: ${doc.id}');
          }
          return docData ?? {};
        }).toList();

        isLoading.value = false;
        Get.log('kids app kid list status: ${kidsList.isNotEmpty}');
      });

      isLoading.value = false; // Stop loading
      return kidsList.isNotEmpty; // Return whether kidsList has data
    } catch (e) {
      isLoading.value = false; // Ensure loading is stopped on error
      Get.snackbar("Error", "Failed to fetch kids: $e");
      return false; // Return false in case of an error
    }
  }

  void fetchParentDetails() async {
    try {
      isLoading.value = true; // Start loading

      // Get the currently logged-in user's email
      final email = FirebaseAuth.instance.currentUser?.email;

      if (email != null) {
        // Fetch parent document from Firestore
        final parentDoc =
            await _firestore.collection('parents').doc(email).get();

        if (parentDoc.exists) {
          final parent = ParentModelClass.fromFirestore(parentDoc);
          parentName.value = parent.name ?? 'Guest';
        } else {
          parentName.value = 'Guest';
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch parent details: $e");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  void fetchKidDetails() async {
    try {
      isLoading.value = true; // Start loading

      // Get the currently logged-in user's email
      final email = FirebaseAuth.instance.currentUser?.email;

      if (email != null) {
        // Fetch kid document from Firestore
        final kidDoc = await _firestore.collection('kids').doc(email).get();

        if (kidDoc.exists && kidDoc.data() != null) {
          // Convert Firestore document to KidModelClass
          final kidDetails = KidModelClass.fromMap(kidDoc.data()!);

          kidName.value = kidDetails.name;
        } else {
          // Document does not exist or is null
          kidName.value = 'Kid';
        }
      } else {
        Get.snackbar("Error", "User is not logged in");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch kid details: $e");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

     var selectedColorIndex = (-1).obs; // Default to no selection
  RxBool isSelected = false.obs; //
 
  // Update Spending Jar Color in Firebase
  Future<void> updateSavingJarColor({
    required bool save,
    required String childId,
    required Color spendingJarColor, // Color passed as parameter
  }) async {
    try {
      // Show loading dialog
      // showDialog(
      //   context: Get.context!,
      //   builder: (context) => LoadingProgressDialogueWidget(
      //     title: "Saving...",
      //   ),
      // );

      // Reference to the kid's document
      DocumentReference kidDocRef =
          FirebaseFirestore.instance.collection('kids').doc(childId);
      DocumentSnapshot snapshot = await kidDocRef.get();

      if (snapshot.exists) {
        // Convert color to a string value (Hex or RGBA)
        String colorHex = spendingJarColor.value
            .toRadixString(16)
            .padLeft(8, '0'); // Converts to hex format

        if (save) {
          // Save the updated spending jar color as a hex string
          await kidDocRef.update({
            'savings.color': colorHex, // Use dot notation for nested fields
          });
          // Close loading dialog
          // Get.back();
          print("Spending Jar Color updated successfully to: $colorHex");
          Get.log("Spending Jar Color updated successfully to: $colorHex");
          // Get.to(() => AmountScreen(
          //       isSpending: false.obs,
          //     ));
        } else {
          Get.back();
          Get.log("Save flag is false. No changes made.");
        }
      } else {
        Get.back();
        Get.log("Kid document does not exist.");
      }
    } catch (e) {
      // Handle errors
      Get.back();
      Get.log("Error updating spending jar color: $e");
    }
  }
 
// Future<void> getParentDataForKidGoals(String parentId) async {
//   try {
//     // Fetch the parent document
//     DocumentSnapshot parentDoc = await FirebaseFirestore.instance
//         .collection('parents')
//         .doc(parentId)
//         .get();

//     if (parentDoc.exists) {
//       Map<String, dynamic> parentData = parentDoc.data() as Map<String, dynamic>;

//       // Get the 'kids' field which is a list of references
//       List kidsReferences = parentData['kids'];

//       // Get the first kid reference (or handle if there are multiple)
//       if (kidsReferences.isNotEmpty) {
//         DocumentReference kidRef = kidsReferences[0];

//         // Fetch the kid document using the reference
//         DocumentSnapshot kidDoc = await kidRef.get();
//         if (kidDoc.exists) {
//           Map<String, dynamic> kidData = kidDoc.data() as Map<String, dynamic>;

//           // Now you can pass the kid data further
//           String kidId = kidDoc.id; // Kid ID
//           String kidName = kidData['name']; // Example of passing kid's name

//           print('Kid ID: $kidId, Kid Name: $kidName');
//         } else {
//           print('Kid document not found');
//         }
//       } else {
//         print('No kids found in the parent data');
//       }
//     } else {
//       print('Parent document not found');
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
// }

 
}
