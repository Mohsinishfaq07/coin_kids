import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/features/roles/parents/add_child/add_child_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var parentId = ''
      .obs; // Parent ID (can be passed dynamically or fetched from authentication)
  var kidsList = [].obs; // List to store kids data

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all kids associated with the parent
  // void fetchKids(String parentId) async {
  //   try {
  //     // final QuerySnapshot snapshot = await _firestore
  //     //     .collection('kids')
  //     //     .where('parentId',
  //     //         isEqualTo: _firestore.collection('parents').doc(parentId))
  //     //     .get();

  //     final QuerySnapshot snapshot = await _firestore
  //         .collection('kids')
  //         .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //         .get();

  //     // Update kidsList with fetched data
  //     kidsList.value = snapshot.docs.map((doc) => doc.data()).toList();
  //   } catch (e) {
  //     Get.snackbar("Error", "Failed to fetch kids: $e");
  //   }
  // }
  void fetchKids() {
    try {
      _firestore
          .collection('kids')
          .where('parentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        kidsList.value = snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch kids: $e");
    }
  }

  // Add any controller logic if needed (e.g., API calls, navigation)
  void navigateToAddChild() {
    Get.to(() => AddChildScreen());
    Get.snackbar("Navigation", "Navigating to Add Child Screen");
  }

  @override
  void onInit() {
    fetchKids();
    super.onInit();
  }
}

class ParentsHomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  ParentsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Light blue background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              Get.snackbar("Settings", "Settings screen navigation");
            },
          ),
        ],
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.person, color: Colors.white),
            ),
            SizedBox(width: 10),
            Text(
              "Nora",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Spacer(),
            Text(
              "👋",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.kidsList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                // CoinKids Logo and Title
                Text(
                  "CoinKids",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 10),
                // Card Section
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Almost There!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Starting by adding you first child.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: controller.navigateToAddChild,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 40,
                          ),
                        ),
                        child: Text(
                          "Add Child",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            ElevatedButton(
              onPressed: controller.navigateToAddChild,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 40,
                ),
              ),
              child: Text(
                "Add Child",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.kidsList.length,
                itemBuilder: (context, index) {
                  final kid = controller.kidsList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(kid[
                            'avatar']), // here is the error because of  firebase storage
                      ),
                      title: Text(
                        kid['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Grade: ${kid['grade']}"),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Savings: ${kid['savings']['amount']}",
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            "Spendings: ${kid['spendings']['amount']}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        );
      }),
    );
  }
}
