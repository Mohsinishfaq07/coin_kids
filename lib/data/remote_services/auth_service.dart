import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/constants/enums.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/models/parent_model.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'parent_service.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final ParentService _parentService = ParentService();
  final analytics = Get.find<AnalyticsService>();

  // Make user stream final and initialize with current user
  final Rx<User?> user = Rx<User?>(FirebaseAuth.instance.currentUser);

  // Computed properties
  bool get isLoggedIn => user.value != null;

  String get userId => user.value?.uid ?? '';

  String get userEmail => user.value?.email ?? '';

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
    ever(user, handleAuthChanged);
  }

  // Email/Password Sign Up
  Future<UserCredential> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
    int dob = 0,
    required String gender,
    String pin = "",
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
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update user stream immediately
      user.value = userCredential.user;
      return userCredential;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Google Sign In
  Future<UserCredential> signInWithGoogle() async {
    try {
      Get.log("Starting Google Sign In process");
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      Get.log("Google Sign In result: ${googleUser != null ? 'Success' : 'Cancelled/Failed'}");

      if (googleUser == null) {
        throw Exception('Google sign in was cancelled by user');
      }

      // Obtain the auth details from the request
      Get.log("Getting Google auth details");
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      Get.log("Got auth tokens - Access Token: ${googleAuth.accessToken != null}, ID Token: ${googleAuth.idToken != null}");

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Could not get auth details from Google');
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      Get.log("Signing in to Firebase with Google credential");
      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Update user stream immediately
      user.value = userCredential.user;
      Get.log("Firebase sign in successful. User ID: ${userCredential.user?.uid}");
      final bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      final String userType = isNewUser ? 'new' : 'returning';
      await analytics.logGoogleSignInSuccess(AnalyticsScreenNames.signUp, userType);



      // If uid doc is not present, create new Doc, create parent document
      Get.log("Checking for existing parent data");
      ParentModel? parentData = await _parentService.fetchParentData();

      if (parentData == null) {
        Get.log("Creating new parent document");
        final parent = ParentModel(
          id: userCredential.user!.uid,
          email: googleUser.email,
          password: '',
          name: googleUser.displayName ?? '',
          imageUrl: googleUser.photoUrl ?? "",
          createdAt: DateTime.now(),
          dob: 0,
          gender: '',
        );

        await _parentService.createParent(parent);
        Get.log("Parent document created successfully");
      }

      return userCredential;
    } catch (e) {
      Get.log("Google Sign In Error: $e");
      if (e is FirebaseAuthException) {
        Get.log("Firebase Auth Error Code: ${e.code}");
        Get.log("Firebase Auth Error Message: ${e.message}");
      }
      throw _handleAuthException(e);
    }
  }

  // Apple Sign In
  Future<UserCredential> signInWithApple() async {
    try {
      final isAvailable = await SignInWithApple.isAvailable();

      if (!isAvailable) {
        throw Exception('Apple Sign In is not available on this device');
      }

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(oauthCredential);

      // Update user stream immediately
      user.value = userCredential.user;

      // If this is a new user, create parent document
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        final String? email = userCredential.user?.email;
        final String name = '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'.trim();

        final parent = ParentModel(
          id: userCredential.user!.uid,
          email: email ?? '',
          password: '',
          name: name.isEmpty ? 'Apple User' : name,
          createdAt: DateTime.now(),
          dob: 0,
          gender: '',
        );

        await _parentService.createParent(parent);
      }

      return userCredential;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }

  // Handle auth state changes
  void handleAuthChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      await SharedPreferencesHelper.saveString(SharedPreferencesHelper.lastLoggedInRole, UserRole.none.name);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      // Update user stream immediately
      user.value = null;
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
    return Exception('An unexpected error occurred. $e');
  }
}
