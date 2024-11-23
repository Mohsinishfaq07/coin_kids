// signup_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/features/roles/parents/home_screen/parent_home_screen.dart';
import 'package:coin_kids/features/roles/parents/authentication/parent_login/parent_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ParentAuthController extends GetxController {
  final email = ''.obs;
  final number = ''.obs;
  final birthday = ''.obs;
  final username = ''.obs;
  final pin = ''.obs;
  final selectedGender = ''.obs; // "Male" or "Female"

  void setBirthday(DateTime date) {
    birthday.value = "${date.year}-${date.month}-${date.day}";
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  Future<void> signUpWithEmail() async {
    if (username.isEmpty || pin.isEmpty || birthday.isEmpty || email.isEmpty) {
      Get.snackbar(
        "Error",
        "All fields (except gender) are required!",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (pin.value.length < 6) {
      Get.snackbar(
        "Error",
        "Pin must be at-least 6 digits long!",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.value,
          password: pin.value,
        );
        saveUserInfo(fieldName: 'email', fieldValue: email.value);
      } on FirebaseAuthException catch (e) {
        Get.snackbar("Error", "Failed to create account: $e",
            snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.log(e.toString());
      }

      // Show success message and navigate to the next screen
    } catch (e) {
      Get.snackbar("Error", "Failed to create account: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // signup with google
  Future<void> signUpWithGoogle() async {
    // if (birthday.isEmpty || username.isEmpty) {
    //   Get.snackbar(
    //     "Error",
    //     "All fields (except gender) are required!",
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    //   return;
    // }

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        Get.log('Google sign-in cancelled');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        saveUserInfo(fieldName: 'email', fieldValue: user.email!);
      }
    } catch (e) {
      Get.log('log: Error during Google Sign-In: $e');
    }
  }

  // number sign up

  signUpWithNumber() {
    if (username.isEmpty || birthday.isEmpty || number.isEmpty) {
      Get.snackbar(
        "Error",
        "All fields (except gender) are required!",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!RegExp(r'^\d+$').hasMatch(number.value)) {
      Get.snackbar(
        "Error",
        "Enter valid number!",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    try {
      // phone validation
      //get otp
      //verify otp
      //store user information
      //all set
    } catch (e) {
      Get.log(e.toString());
    }
  }

  // save user info
  saveUserInfo({required String fieldName, required String fieldValue}) async {
    try {
      await FirebaseFirestore.instance
          .collection('parents')
          .doc(fieldValue)
          .set({
        // add email or phone number field
        // fieldName: fieldValue,
        // 'name': username.value,
        // 'dob': birthday.value,
        // 'password': pin.value,
        // 'gender': selectedGender.value.isNotEmpty
        //     ? selectedGender.value
        //     : 'Not specified',
        // 'created_at': DateTime.now().toIso8601String(),
        fieldName: fieldValue,
        'name': username.value.isNotEmpty ? username.value : 'Not specified',
        'dob': birthday.value.isNotEmpty ? birthday.value : 'Not specified',
        'password': pin.value.isNotEmpty ? pin.value : 'Not specified',
        'gender': selectedGender.value.isNotEmpty
            ? selectedGender.value
            : 'Not specified',
        'created_at': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
      Get.snackbar("Success", "Account created",
          snackPosition: SnackPosition.BOTTOM);
      Get.off(() => ParentLoginScreen());
    } catch (e) {
      Get.log(e.toString());
    }
  }

  // login with email
  Future<void> loginWithEmail() async {
    if (email.isEmpty || pin.isEmpty) {
      Get.snackbar(
        "Error",
        "All fields  are required!",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (pin.value.length < 6) {
      Get.snackbar(
        "Error",
        "Enter valid password!",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.value, password: pin.value);
      Get.off(() => ParentsHomeScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error",
        "Enter valid email or password!",
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.log(e.toString());
    }
  }
  // login with gmail

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        Get.log('Google sign-in cancelled');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        Get.off(() => ParentLoginScreen());
      }
    } catch (e) {
      Get.log('log: Error during Google Sign-In: $e');
    }
  }
  // login with phone number
}
