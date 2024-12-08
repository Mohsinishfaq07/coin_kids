// signup_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/features/databse_helper/databse_helper.dart';
import 'package:coin_kids/features/roles/parents/bottom_navigationbar/bottom_navigationbar_screen.dart';
import 'package:coin_kids/features/roles/parents/bottom_navigationbar/home_screen/parent_home_screen.dart';
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
  final confirmPin = "".obs;
  final selectedGender = ''.obs; // "Male" or "Female"
  final isLoading = false.obs; // New reactive loading state
  String? _selectedDate;

  // Reactive state for tracking if fields are filled
  final isButtonEnabled = false.obs;

  // Update button state whenever a field changes
  void checkFields() {
    isButtonEnabled.value = email.value.isNotEmpty && pin.value.isNotEmpty;
  }

  void setBirthday(DateTime date) {
    birthday.value = "${date.year}-${date.month}-${date.day}";
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  Future<void> signUpWithEmail() async {
    if (username.value.isEmpty ||
        pin.value.isEmpty ||
        email.value.isEmpty ||
        pin.value != confirmPin.value) {
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
        await saveCredentialsLocally(email.value, pin.value);
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

  Future<void> saveCredentialsLocally(String email, String password) async {
    try {
      await DatabaseHelper.instance.insertCredentials(email, password);
      Get.log("Credentials saved locally.");
    } catch (e) {
      Get.log("Error saving credentials: $e");
    }
  }

  // signup with google
  Future<void> signUpWithGoogle() async {
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

  Future<void> loginWithEmail() async {
    if (email.value.isEmpty || pin.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Email and password fields cannot be empty!",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true; // Start loading

      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.value, password: pin.value);
      await saveCredentialsLocally(email.value, pin.value);
      isLoading.value = false; // Stop loading
      // Navigate to Home Screen
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      if (e.code == 'user-not-found') {
        Get.snackbar("Error", "No user found for that email.",
            snackPosition: SnackPosition.BOTTOM);
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Error", "Incorrect password entered.",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Error", "An unexpected error occurred: ${e.message}",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Failed to login. Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true; // Stop loading
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
        isLoading.value = false; // Stop loading
        Get.off(() => ParentsHomeScreen());
      }
    } catch (e) {
      Get.log('log: Error during Google Sign-In: $e');
    }
  }

  Future<void> clearCredentials() async {
    await DatabaseHelper.instance.clearCredentials();
  }

  Future<void> loadCredentials() async {
    try {
      final credentials = await DatabaseHelper.instance.fetchCredentials();
      if (credentials != null) {
        email.value = credentials['email']!;
        pin.value = credentials['password']!;
      }
    } catch (e) {
      Get.log("Error loading credentials: $e");
    }
  }

  Future<void> autoLogin() async {
    try {
      isLoading.value = true;

      // Load saved credentials
      final credentials = await DatabaseHelper.instance.fetchCredentials();
      if (credentials != null) {
        email.value = credentials['email']!;
        pin.value = credentials['password']!;

        // Attempt Firebase login with saved credentials
        final UserCredential credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: email.value, password: pin.value);

        if (credential.user != null) {
          // Navigate to home screen
          Get.off(() => BottomNavigationBarScreen());
        }
      } else {
        // If no saved credentials, navigate to the login screen
        Get.off(() => ParentLoginScreen());
      }
    } catch (e) {
      Get.log("Auto-login failed: $e");
      Get.off(() => ParentLoginScreen()); // Fallback to login screen on failure
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await clearCredentials(); // Clear local credentials
    Get.off(() => ParentLoginScreen()); // Navigate back to login screen
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;

      // Update Firebase Firestore
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('parents')
            .doc(user.email)
            .update({
          'name': username.value,
          'dob': birthday.value,
          'gender': selectedGender.value.isNotEmpty
              ? selectedGender.value
              : 'Not specified',
        });

        Get.snackbar(
          "Success",
          "Profile updated successfully!",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          "User not logged in. Please log in again.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update profile: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
