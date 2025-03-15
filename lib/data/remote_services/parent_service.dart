import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/core/utils/image_utils.dart';
import 'package:coin_kids/data/models/parent_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class ParentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Fetch parent data
  Future<ParentModel?> fetchParentData() async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception('User not authenticated');
      }

      final DocumentSnapshot doc = await _firestore.collection('parents').doc(userId).get();

      if (!doc.exists) {
        return null;
      }

      return ParentModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to fetch parent data: ${e.toString()}');
    }
  }

  // Stream to observe parent data updates
  Stream<ParentModel?> streamParentData() {
    final String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      Get.log("ParentService: No user ID found");
      return Stream.value(null);
    }

    return _firestore.collection('parents').doc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        Get.log("ParentService: Document doesn't exist for user $userId");
        return null;
      }

      try {
        final data = snapshot.data() as Map<String, dynamic>;
        final parent = ParentModel.fromJson(data);
        Get.log("ParentService: Successfully mapped parent data: ${parent.name}");
        return parent;
      } catch (e) {
        Get.log("ParentService: Error mapping parent data: $e");
        return null;
      }
    }).handleError((error) {
      Get.log("ParentService: Stream error: $error");
      return null;
    });
  }

  // Create new parent
  Future<void> createParent(ParentModel parent) async {
    try {
      await _firestore.collection('parents').doc(parent.id).set(parent.toJson());
    } catch (e) {
      throw Exception('Failed to create parent: ${e.toString()}');
    }
  }

  // Update parent data
  Future<void> updateParent(ParentModel parent) async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception('User not authenticated');
      }

      await _firestore.collection('parents').doc(userId).update(parent.toJson());
    } catch (e) {
      throw Exception('Failed to update parent: ${e.toString()}');
    }
  }

  // Update parent PIN
  Future<void> updatePin(int newPin) async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception('User not authenticated');
      }

      await _firestore.collection('parents').doc(userId).update({'pin': newPin});
    } catch (e) {
      throw Exception('Failed to update PIN: ${e.toString()}');
    }
  }

  // Verify parent PIN
  Future<bool> verifyPin(int pin) async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception('User not authenticated');
      }

      final DocumentSnapshot doc = await _firestore.collection('parents').doc(userId).get();
      if (!doc.exists) {
        return false;
      }

      final data = doc.data() as Map<String, dynamic>;
      return data['pin'] == pin;
    } catch (e) {
      throw Exception('Failed to verify PIN: ${e.toString()}');
    }
  }

  // Update parent's photo
  Future<String> updateParentPhoto(File photoFile) async {
    try {
      final String userId = _auth.currentUser?.uid ?? '';
      if (userId.isEmpty) {
        throw Exception('User not authenticated');
      }

      // Resize image before uploading
      final File resizedFile = await ImageUtils.resizeImage(photoFile);

      // Create file path in storage
      final String fileName = 'user_avatars/parents/$userId.${resizedFile.path.split('.').last}';
      final Reference storageRef = _storage.ref().child(fileName);

      // Upload resized file
      final UploadTask uploadTask = storageRef.putFile(resizedFile);
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update parent document with new photo URL
      await _firestore.collection('parents').doc(userId).update({'imageUrl': downloadUrl});

      // Clean up temporary resized file
      if (resizedFile.path != photoFile.path) {
        await resizedFile.delete();
      }

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to update parent photo: ${e.toString()}');
    }
  }
}
