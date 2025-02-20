import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/core/constants/constants.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/presentation/controllers/parent/parent_home_controller.dart';
import 'package:coin_kids/presentation/dialogs/kid/custom_dialogs.dart';
import 'package:coin_kids/data/local_services/databse_helper.dart';
import 'package:coin_kids/presentation/components/kid/toast_widget.dart';
import 'package:coin_kids/presentation/screens/kid/home/kid_home_screen.dart';
import 'package:coin_kids/presentation/screens/common/role_selection/role_selection_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../presentation/controllers/parent/add_child_controller.dart';
 import '../../presentation/screens/common/authentication/login/login_screen.dart';
import '../../presentation/screens/parent/bottom_navigation/bottom_navigationbar_screen.dart';
import '../../presentation/screens/parent/home_screen/parent_home_screen.dart';

class FirebaseAuthController extends GetxController {
  final ParentController homeController = Get.put(ParentController());
  final AddChildController _addChildController = Get.put(AddChildController());
  final AuthService _authService = Get.put(AuthService());
  final email = ''.obs;
  final number = ''.obs;
  final birthday = ''.obs;
  final parentName = ''.obs;
  final password = ''.obs;
  final confirmPassword = "".obs;
  final selectedGender = ''.obs; // "Male" or "Female"
  final isEmailLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isAppleLoading = false.obs;
  final isNormalLoading = false.obs;
  final parentPin = 0.obs;
  // Reactive state for tracking if fields are filled
  final isButtonEnabled = false.obs;
  final showPassword = true.obs;
  final showConfirmPassword = true.obs;

  // Update button state whenever a field changes
  void checkFields() {
    isButtonEnabled.value = email.value.isNotEmpty && password.value.isNotEmpty;
  }

  void signUpCheckField() {
    isButtonEnabled.value = parentName.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword;
  }

  void setBirthday(DateTime date) {
    final DateFormat formatter = DateFormat('d MMM, y');

    birthday.value = formatter.format(date);
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  Future<void> signUpWithEmail() async {
    try {
      // Validate only required fields
      if (email.value.isEmpty ||
          password.value.isEmpty ||
          parentName.value.isEmpty) {
        ToastUtil.showToast('Please fill in email, username, and password');
        return;
      }

      isEmailLoading.value = true;
      showDialog(
          context: Get.context!,
          builder: (context) => LoadingProgressDialogueWidget(
                title: "Sign up..",
              ));

      // Use AuthService for signup
      final credential = await _authService.signUpWithEmailPassword(
        email: email.value,
        password: password.value,
        name: parentName.value,
        dob: DateTime.now(), // Default date, can be updated later
        gender: selectedGender.value.isEmpty ? '' : selectedGender.value,
        pin: parentPin.value,
      );

      if (credential.user != null) {
        // Save credentials locally
        await saveInfoLocally(email.value, password.value);

        ToastUtil.showToast("Account created successfully");
        Get.back();
        Get.off(() => RoleSelectionScreen());
      }
    } catch (e) {
      Get.back();
      ToastUtil.showToast(e.toString());
      Get.log(e.toString());
    } finally {
      isEmailLoading.value = false;
    }
  }

  Future<void> saveParentInfo(
      {required String fieldName, required String fieldValue}) async {
    try {
      await FirebaseFirestore.instance
          .collection('parents')
          .doc(fieldValue)
          .set({
        fieldName: fieldValue,
        'name':
            parentName.value.isNotEmpty ? parentName.value : 'Not specified',
        'dob': birthday.value.isNotEmpty ? birthday.value : 'Not specified',
        'password':
            password.value.isNotEmpty ? password.value : 'Not specified',
        'gender': selectedGender.value.isNotEmpty
            ? selectedGender.value
            : 'Not specified',
        'created_at': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));

      ToastUtil.showToast("Account created");
      // Get.off(() => ParentLoginScreen());
    } catch (e) {
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

  //Method to handle Google Sign-In
  Future<void> signUpWithGoogle() async {
    try {
      isGoogleLoading.value = true; // Show loading state
      // Initiate Google Sign-In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the Google Sign-In process
        ToastUtil.showToast("Sign-In Canceled");
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
        ToastUtil.showToast("Logged in as ${user.email}");
      } else {
        // Handle null user case
        ToastUtil.showToast("Sign In Failed");
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors
      ToastUtil.showToast("Firebase Auth Error: ${e.message}");

      Get.log("An error occurred in Firebase Auth: $e");
    } catch (e) {
      // Handle general errors
      ToastUtil.showToast("An error occurred: $e");

      Get.log("An error occurred in catch: $e");
    } finally {
      // Reset the loading state
      isGoogleLoading.value = false;
    }
  }

  Future<void> loginWithEmail() async {
    try {
      isEmailLoading.value = true; // Start loading
      showDialog(
          context: Get.context!,
          builder: (context) => LoadingProgressDialogueWidget(
                title: "loading..",
              ));

      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.value, password: password.value);

      Get.offAll(RoleSelectionScreen());
    } on FirebaseAuthException catch (e) {
      isEmailLoading.value = false;
      if (e.code == 'user-not-found') {
        Get.back();
        Future.delayed(const Duration(milliseconds: 500), () {
          ToastUtil.showToast("No user found for that email.");
        });
      } else if (e.code == 'wrong-password') {
        Get.back();
        Future.delayed(const Duration(milliseconds: 500), () {
          ToastUtil.showToast("Incorrect password entered.");
        });
      } else {
        Get.back();
        Future.delayed(const Duration(milliseconds: 500), () {
          ToastUtil.showToast(
            "An unexpected error occurred: ${e.message}",
          );
        });
      }
    } catch (e) {
      isEmailLoading.value = false;
      Get.back();
      ToastUtil.showToast(
        "Failed to login. Please try again later.",
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
        final isParent = await checkIfParent(email.value);
        if (isParent) {
          bool parentHasKids = await homeController.fetchKids();
          if (parentHasKids) {
            Get.off(() => ParentBottomNavigationBar());
          } else {
            Get.off(() => const ParentsHomeScreen());
          }
          // Navigate to ParentBottomNavigationBar if user is a parent
        } else {
          // Navigate to KidMyMoney if user is a kid
          Get.off(() => KidHomeScreen());
        }

        // comment out above  line and add these instead of them
        // Get.back(); // Stop loading
        // Get.off(() => const RoleSelectionScreen());
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
        password.value = credentials['password']!;
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

  Future<void> logout() async {
    try {
      // Show loading indicator before starting the logout process
      firebaseAuthController.isNormalLoading.value = true;
      showDialog(
        context: Get.context!,
        builder: (context) => LoadingProgressDialogueWidget(
          title: "Logging out...",
        ),
      );

      // Ensure the current user is not null before logging out
      if (FirebaseAuth.instance.currentUser != null) {
        // Sign out the current user
        await FirebaseAuth.instance.signOut();
        await clearCredentials(); // Clear local credentials
        _addChildController.childName.value = "";
        _addChildController.kidImagePath.value = "";

        // Navigate to the Login Screen after successful logout
        Get.offAll(() => LoginScreen());
      } else {
        ToastUtil.showToast("No user is logged in");
      }
    } catch (e) {
      // Handle any errors during logout
      ToastUtil.showToast("An error occurred during logout: $e");
    } finally {
      // Hide the loading indicator after the process is complete
      firebaseAuthController.isNormalLoading.value = false;
      Get.back(); // Close the loading dialog
    }
  }

  Future<bool> checkIfParent(String email) async {
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

  Future<void> resetPassword(String email) async {
    showDialog(
        context: Get.context!,
        builder: (context) => LoadingProgressDialogueWidget(
              title: "Processing",
            ));

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.back();
      ToastUtil.showToast('Check your inbox for password reset link');
    } catch (e) {
      Get.back();
      ToastUtil.showToast(e.toString());
    }
  }
}
