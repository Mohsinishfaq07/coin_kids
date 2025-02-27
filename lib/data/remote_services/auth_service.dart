import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/models/parent_model.dart';
import 'package:coin_kids/presentation/screens/common/sign_in/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'parent_service.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final ParentService _parentService = ParentService();

  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

  // Email/Password Sign Up
  Future<UserCredential> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
    int dob = 0,
    required String gender,
    int pin = 0000,
  }) async {
    try {
      // Create user with email and password
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final parent = ParentModel(
          id: credential.user!.uid,
          email: email,
          password: password,
          name: name,
          pin: pin,
          createdAt: DateTime.now(),
          dob: dob,
          gender: gender,
        );

        await _parentService.createParent(parent);
      }

      return credential;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Email/Password Sign In
  Future<UserCredential> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Google Sign In
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // If this is a new user, create parent document
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        final parent = ParentModel(
          email: googleUser.email,
          password: '',
          // No password for Google sign in
          name: googleUser.displayName ?? '',
          pin: 0000,
          // Default PIN
          createdAt: DateTime.now(),
          dob: DateTime
              .now()
              .millisecondsSinceEpoch,
          // Will need to be updated by user
          gender: '', // Will need to be updated by user
        );

        await _parentService.createParent(parent);
      }

      return userCredential;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Apple Sign In
  Future<UserCredential> signInWithApple() async {
    try {
      // Check if Apple Sign In is available
      final isAvailable = await SignInWithApple.isAvailable();

      if (!isAvailable) {
        throw Exception('Apple Sign In is not available on this device');
      }

      // Get Apple credentials
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create OAuthCredential
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(oauthCredential);

      // If this is a new user, create parent document
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        final String? email = userCredential.user?.email;
        final String? name = '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'.trim();

        final parent = ParentModel(
          email: email ?? '',
          password: '',
          // No password for Apple sign in
          name: name == null || name.isEmpty ? 'Apple User' : name,
          pin: 0000,
          // Default PIN
          createdAt: DateTime.now(),
          dob: DateTime
              .now()
              .millisecondsSinceEpoch,
          // Will need to be updated by user
          gender: '', // Will need to be updated by user
        );

        await _parentService.createParent(parent);
      }

      return userCredential;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      Get.offAll(() => LoginScreen());
      await SharedPreferencesHelper.saveString(SharedPreferencesHelper.lastLoggedInRole, UserRole.NONE.name);
      await Future.wait([
        _auth.signOut(),
      ]);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Update Password
  Future<void> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user is currently signed in');
      await user.updatePassword(newPassword);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Helper method to handle Firebase Auth exceptions
  Exception _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return Exception('No user found with this email.');
        case 'wrong-password':
          return Exception('Wrong password provided.');
        case 'email-already-in-use':
          return Exception('An account already exists with this email.');
        case 'weak-password':
          return Exception('The password provided is too weak.');
        case 'invalid-email':
          return Exception('The email address is not valid.');
        case 'operation-not-allowed':
          return Exception('This sign in method is not enabled.');
        case 'user-disabled':
          return Exception('This user account has been disabled.');
        case 'requires-recent-login':
          return Exception('Please sign in again to complete this operation.');
        case 'invalid-credential':
          return Exception('Email and Password doesn\'t match');
        default:
          return Exception("${e.code}: ${e.message}");
      }
    }
    return Exception('An unexpected error occurred.');
  }
}
