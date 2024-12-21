// signup_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/features/databse_helper/databse_helper.dart';
import 'package:coin_kids/pages/roles/parents/bottom_navigationbar/bottom_navigationbar_screen.dart';
import 'package:coin_kids/pages/roles/parents/authentication/parent_login/parent_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        isEmailLoading.value = true;
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.value,
          password: pin.value,
        );
        saveUserInfo(fieldName: 'email', fieldValue: email.value);
        await saveCredentialsLocally(email.value, pin.value);
        Get.offAll(() => BottomNavigationBarScreen());
      } on FirebaseAuthException catch (e) {
        isEmailLoading.value = false;
        Get.snackbar("Error", "Failed to create account: $e",
            snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        isEmailLoading.value = false;
        Get.log(e.toString());
      }

      // Show success message and navigate to the next screen
    } catch (e) {
      isEmailLoading.value = false;
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
        saveUserInfo(fieldName: 'gmail', fieldValue: user.email!);
        Get.offAll(() => BottomNavigationBarScreen());
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
      // Get.off(() => ParentLoginScreen());
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

      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.value, password: pin.value);
      await saveCredentialsLocally(email.value, pin.value);
      isEmailLoading.value = false; // Stop loading
      Get.offAll(() => BottomNavigationBarScreen());
      // Navigate to Home Screen
    } on FirebaseAuthException catch (e) {
      isEmailLoading.value = false;
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
      isEmailLoading.value = false;
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
        Get.off(() => BottomNavigationBarScreen());
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

  // Future<void> autoLogin() async {
  //   try {
  //     isLoading.value = true;

  //     // Load saved credentials
  //     final credentials = await DatabaseHelper.instance.fetchCredentials();
  //     if (credentials != null) {
  //       email.value = credentials['email']!;
  //       pin.value = credentials['password']!;

  //       // Attempt Firebase login with saved credentials
  //       final UserCredential credential = await FirebaseAuth.instance
  //           .signInWithEmailAndPassword(
  //               email: email.value, password: pin.value);

  //       if (credential.user != null) {
  //         // Navigate to home screen
  //         Get.off(() => BottomNavigationBarScreen());
  //       }
  //     } else {
  //       // If no saved credentials, navigate to the login screen
  //       Get.off(() => ParentLoginScreen());
  //     }
  //   } catch (e) {
  //     Get.log("Auto-login failed: $e");
  //     Get.off(() => ParentLoginScreen()); // Fallback to login screen on failure
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // apple sign in

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

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await clearCredentials(); // Clear local credentials
    isEmailLoading.value = false;
    isGoogleLoading.value = false;
    isAppleLoading.value = false;
    Get.offAll(() => ParentLoginScreen());
  }
}
