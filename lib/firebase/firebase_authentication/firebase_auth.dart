// signup_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/dialogues/custom_dialogues.dart';
import 'package:coin_kids/features/databse_helper/databse_helper.dart';
import 'package:coin_kids/pages/roles/kid/kid_bottom_nav/kid_bottom_nav_screen.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/bottom_navigationbar_screen.dart';
import 'package:coin_kids/pages/roles/parents/authentication/parent_login/parent_login_screen.dart';
import 'package:coin_kids/pages/roles/role_selection_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthController extends GetxController {
  final email = ''.obs;
  final number = ''.obs;
  final birthday = ''.obs;
  final username = ''.obs;
  final pin = ''.obs;
  final confirmPin = "".obs;
  final selectedGender = ''.obs; // "Male" or "Female"
  final isEmailLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isAppleLoading = false.obs;
  final isNormalLoading = false.obs;
  // Reactive state for tracking if fields are filled
  final isButtonEnabled = false.obs;

  // Update button state whenever a field changes
  void checkFields() {
    isButtonEnabled.value = email.value.isNotEmpty && pin.value.isNotEmpty;
  }

  void signUpCheckField() {
    isButtonEnabled.value = username.isNotEmpty &&
        email.isNotEmpty &&
        pin.isNotEmpty &&
        confirmPin.isNotEmpty &&
        pin == confirmPin;
  }

  void setBirthday(DateTime date) {
    birthday.value = "${date.year}-${date.month}-${date.day}";
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  Future<void> signUpWithEmail() async {
    try {
      isEmailLoading.value = true;

      showDialog(
          context: Get.context!,
          builder: (context) => LoadingProgressDialogueWidget(
                title: "Sign up..",
              ));
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.value,
        password: pin.value,
      );
      // saveUserInfo(fieldName: 'email', fieldValue: email.value);
      // await saveParentInfoLocally(email.value, pin.value);
      Get.back(); // Stop loading
      Get.offAll(() => const RoleSelectionScreen());
      // Get.offAll(() => BottomNavigationBarScreen());
    } on FirebaseAuthException catch (e) {
      Get.back();
      isEmailLoading.value = false;
      Get.snackbar("Error", "Failed to create account: $e",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.back();
      isEmailLoading.value = false;
      Get.log(e.toString());
    }
  }

  Future<void> saveInfoLocally(String email, String password) async {
    try {
      await DatabaseHelper.instance.insertCredentials(email, password);
      Get.log("Credentials saved locally.");
    } catch (e) {
      Get.log("Error saving credentials: $e");
    }
  }

  // signup with google

  // Method to handle Google Sign-In
  Future<void> signUpWithGoogle() async {
    try {
      isGoogleLoading.value = true; // Show loading state
      // Initiate Google Sign-In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the Google Sign-In process
        Get.snackbar("Sign-In Canceled", "You canceled the Google Sign-In.");
        return;
      }

      // Authenticate the Google user
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential using the Google authentication tokens
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase using the Google credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Retrieve the user information
      final User? user = userCredential.user;

      if (user != null) {
        // Save user information or perform further actions
        await saveParentInfo(fieldName: 'gmail', fieldValue: user.email!);

        // Navigate to the main screen
        Get.offAll(() => ParentBottomNavigationBar());
        Get.snackbar("Welcome", "Logged in as ${user.email}");
      } else {
        // Handle null user case
        Get.snackbar("Sign-In Failed", "User data could not be retrieved.");
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      Get.snackbar("Error", "Firebase Auth Error: ${e.message}");
    } catch (e) {
      // Handle general errors
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      // Reset the loading state
      isGoogleLoading.value = false;
    }
  }

  signUpWithNumber() {
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
  saveParentInfo(
      {required String fieldName, required String fieldValue}) async {
    try {
      await FirebaseFirestore.instance
          .collection('parents')
          .doc(fieldValue)
          .set({
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
      // Get.off(() => ParentLoginScreen());
    } catch (e) {
      Get.log(e.toString());
    }
  }

  saveKidInfo({required String fieldName, required String fieldValue}) async {
    try {
      await FirebaseFirestore.instance.collection('kids').doc(fieldValue).set({
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
      isEmailLoading.value = true; // Start loading
      showDialog(
          context: Get.context!,
          builder: (context) => LoadingProgressDialogueWidget(
                title: "loading..",
              ));

      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.value, password: pin.value);
      await saveInfoLocally(email.value, pin.value);
      Get.back(); // Stop loading
       
      // Fetch user role from Firestore
      final isParent = await _checkIfParent(email.value);
      if (isParent) {
        // Navigate to ParentBottomNavigationBar if user is a parent
        Get.off(() => ParentBottomNavigationBar());
      } else {
        // Navigate to KidMyMoney if user is a kid
        Get.off(() => KidBottomNavScreen());
      
    } 
      
      // Navigate to Home Screen
    } on FirebaseAuthException catch (e) {
      isEmailLoading.value = false;
      if (e.code == 'user-not-found') {
        Get.back();
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.snackbar("Error", "No user found for that email.",
              snackPosition: SnackPosition.BOTTOM);
        });
      } else if (e.code == 'wrong-password') {
        Get.back();
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.snackbar("Error", "Incorrect password entered.",
              snackPosition: SnackPosition.BOTTOM);
        });
      } else {
        Get.back();
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.snackbar("Error", "An unexpected error occurred: ${e.message}",
              snackPosition: SnackPosition.BOTTOM);
        });
      }
    } catch (e) {
      isEmailLoading.value = false;
      Get.back();
      Get.snackbar(
        "Error",
        "Failed to login. Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isGoogleLoading.value = true; // start loading
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        Get.log('Google sign-in cancelled');
        isGoogleLoading.value = false;
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
        // saveUserInfo(fieldName: 'gmail', fieldValue: user.email!);
        isGoogleLoading.value = false; // Stop loading
        Get.off(() => ParentBottomNavigationBar());
      }
    } catch (e) {
      isGoogleLoading.value = false;
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

  signinWithApple() async {
    try {
      isAppleLoading.value = true;
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: '<>',
          redirectUri: Uri.parse('<>'),
        ),
        // need client id from apple developer console from client side
        // need redirect url of domain from client side
      );

      final oAuth = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );
      await firebaseAuth.signInWithCredential(oAuth);
      Get.log('credentials:$credential');
    } catch (e) {
      isAppleLoading.value = false;
      Get.log('error in apple login:${e.toString()}');
    }
  }

  // forget credentials

  Future<void> resetPassword(String email) async {
    showDialog(
        context: Get.context!,
        builder: (context) => LoadingProgressDialogueWidget(
              title: "Processing",
            ));

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.back();
      Get.snackbar('Alert', 'Check your inbox for password reset link');
    } catch (e) {
      Get.back();
      Get.snackbar('Alert', e.toString());
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await clearCredentials(); // Clear local credentials
    isEmailLoading.value = false;
    isGoogleLoading.value = false;
    isAppleLoading.value = false;
    Get.offAll(() => ParentLoginScreen());
  }
     Future<bool> _checkIfParent(String email) async {
    try {
      final parentSnapshot = await FirebaseFirestore.instance
          .collection('parents')
          .where('email', isEqualTo: email)
          .get();

      if (parentSnapshot.docs.isNotEmpty) {
        return true; // User is a parent
      }

      // If not found in parents collection, check in kids collection
      final kidSnapshot = await FirebaseFirestore.instance
          .collection('kids')
          .where('email', isEqualTo: email)
          .get();

      if (kidSnapshot.docs.isNotEmpty) {
        return false; // User is a kid
      }
    } catch (e) {
      Get.log("Error checking user role: $e");
    }

    return false; // Default to kid if no matching document is found
  }

}
