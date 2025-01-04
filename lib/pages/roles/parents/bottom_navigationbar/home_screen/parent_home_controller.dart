import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/pages/roles/kid/kid_model_class.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ParentHomeController extends GetxController {
  var parentId = ''
      .obs; // Parent ID (can be passed dynamically or fetched from authentication)
  var kidsList = [].obs; // List to store kids data
  var isLoading = true.obs;
  var parentName = ''.obs; // Observable to hold the parent's name
  var kidName = ''.obs; //
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add any controller logic if needed (e.g., API calls, navigation)

  void fetchKids() {
    try {
      isLoading.value = true; // Start loading
      _firestore
          .collection('kids')
          .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        kidsList.value = snapshot.docs.map((doc) {
          var docData = doc.data() as Map<String, dynamic>?;
          if (docData != null) {
            docData['id'] = doc.id;
          }
          return docData ?? {};
        }).toList();
        isLoading.value = false;
      });
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch kids: $e");
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
}
