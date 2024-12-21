import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/pages/roles/parents/add_child/add_child_screen.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/home_screen/parent_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var parentId = ''
      .obs; // Parent ID (can be passed dynamically or fetched from authentication)
  var kidsList = [].obs; // List to store kids data
  var isLoading = true.obs;
  var parentName = ''.obs; // Observable to hold the parent's name

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add any controller logic if needed (e.g., API calls, navigation)
  void navigateToAddChild() {
    Get.to(() => AddChildScreen());
    // Get.snackbar("Navigation", "Navigating to Add Child Screen");
  }

  @override
  void onInit() {
    //   fetchKids();
    // fetchParentDetails();
    super.onInit();
  }

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
}
