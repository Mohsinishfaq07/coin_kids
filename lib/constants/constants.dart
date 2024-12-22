import 'package:coin_kids/controllers/parent_controller.dart';
import 'package:coin_kids/firebase/firebase_authentication/firebase_auth.dart';
import 'package:coin_kids/firebase/firestore/firestore_operations.dart';
import 'package:get/get.dart';

late FirebaseAuthController firebaseAuthController;
late FirestoreOperations firestoreOperations;
late ParentController parentController;
controllerAndClassInitialization() async {
  firebaseAuthController = Get.put(FirebaseAuthController());
  firestoreOperations = Get.put(FirestoreOperations());
  parentController = Get.put(ParentController());
}
