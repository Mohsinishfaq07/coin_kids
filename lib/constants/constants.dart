import 'package:coin_kids/firebase/authentication/firebase_auth.dart';
import 'package:coin_kids/firebase/firestore/firestore_operations.dart';
import 'package:get/get.dart';

late FirebaseAuthController firebaseAuthController;
late FirestoreOperations firestoreOperations;
controllerAndClassInitialization() async {
  firebaseAuthController = Get.put(FirebaseAuthController());
  firestoreOperations = FirestoreOperations();
}
