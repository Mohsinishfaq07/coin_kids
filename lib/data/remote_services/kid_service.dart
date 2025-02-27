import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kid_model.dart';

class KidService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Cache keys
  static const String _avatarCacheKey = 'cached_avatars';
  static const String _avatarCacheTimestampKey = 'cached_avatars_timestamp';
  static const Duration _cacheExpiration = Duration(days: 7); // Cache expires after 7 days

  // Fetch kid data by ID
  Future<KidModel?> fetchKidById(String kidId) async {
    try {
      final DocumentSnapshot doc =
          await _firestore.collection('kids').doc(kidId).get();

      if (!doc.exists) {
        return null;
      }

      return KidModel.fromJson(doc.data() as Map<String, dynamic>,
          documentId: kidId);
    } catch (e) {
      throw Exception('Failed to fetch kid data: ${e.toString()}');
    }
  }

  // Fetch kids by parent ID
  Future<List<KidModel>> fetchKidsByParentId(String parentId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('kids')
          .where('parentId', isEqualTo: parentId)
          .get();

      return snapshot.docs
          .map((doc) => KidModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch kids: ${e.toString()}');
    }
  }

  // Single method to create kid
  Future<String> createKid({
    required String name,
    required int age,
    required String parentId,
    String? customImagePath,
    String? selectedAvatarUrl,
  }) async {
    try {
      String avatarUrl = selectedAvatarUrl ?? '';

      // Create initial wallet
      final wallet = Wallet(
        savingJar: WalletJar(balance: 0.0, color: '#000000'),
        spendingJar: WalletJar(balance: 0.0, color: '#000000'),
      );

      // Create kid model
      final KidModel kid = KidModel(
        name: name,
        age: age,
        avatar: avatarUrl,
        parentId: parentId,
        wallet: wallet,
        coinKidsBalance: 0.0,
        createdAt: DateTime.now(),
        kidId: '', // Will be updated after creation
      );

      // Create kid document and get ID
      final DocumentReference docRef =
          await _firestore.collection('kids').add(kid.toJson());
      final String kidId = docRef.id;

      // If custom image provided, upload it
      if (customImagePath != null && customImagePath.isNotEmpty) {
        final String fileName =
            'user_avatars/kids/$kidId.${customImagePath.split('.').last}';
        final Reference ref = _storage.ref().child(fileName);

        final UploadTask uploadTask = ref.putFile(File(customImagePath));
        final TaskSnapshot snapshot = await uploadTask;
        avatarUrl = await snapshot.ref.getDownloadURL();
        
        // Cache the avatar locally
        await _cacheAvatarImage(avatarUrl);
      }

      // Update kid with its ID and final avatar URL
      final updatedKid = kid.copyWith(
        kidId: kidId,
        avatar: avatarUrl,
      );
      await _firestore
          .collection('kids')
          .doc(kidId)
          .update(updatedKid.toJson());

      return kidId;
    } catch (e) {
      throw Exception('Failed to create kid: $e');
    }
  }

  // Update kid data
  Future<void> updateKid(String kidId, KidModel kid) async {
    try {
      await _firestore.collection('kids').doc(kidId).update(kid.toJson());
    } catch (e) {
      throw Exception('Failed to update kid: ${e.toString()}');
    }
  }

  // Delete kid
  Future<void> deleteKid(String kidId) async {
    try {
      await _firestore.collection('kids').doc(kidId).delete();
    } catch (e) {
      throw Exception('Failed to delete kid: ${e.toString()}');
    }
  }

  // Update saving jar balance
  Future<void> updateSavingJarBalance(String kidId, double newBalance) async {
    try {
      await _firestore.collection('kids').doc(kidId).update({
        'wallet.savingJar.balance': newBalance,
      });
    } catch (e) {
      throw Exception('Failed to update saving jar balance: ${e.toString()}');
    }
  }

  // Update spending jar balance
  Future<void> updateSpendingJarBalance(String kidId, double newBalance) async {
    try {
      await _firestore.collection('kids').doc(kidId).update({
        'wallet.spendingJar.balance': newBalance,
      });
    } catch (e) {
      throw Exception('Failed to update spending jar balance: ${e.toString()}');
    }
  }

  // Transfer money between jars
  Future<void> transferBetweenJars(
    String kidId,
    String fromJar,
    String toJar,
    double amount,
  ) async {
    try {
      // Get current kid data
      final kidDoc = await _firestore.collection('kids').doc(kidId).get();
      if (!kidDoc.exists) {
        throw Exception('Kid not found');
      }

      final kidData = kidDoc.data() as Map<String, dynamic>;
      final wallet = kidData['wallet'] as Map<String, dynamic>;

      // Get current balances
      final fromBalance = (wallet[fromJar]?['balance'] ?? 0.0) as double;
      final toBalance = (wallet[toJar]?['balance'] ?? 0.0) as double;

      // Validate transfer
      if (fromBalance < amount) {
        throw Exception('Insufficient funds in $fromJar');
      }

      // Update balances
      await _firestore.collection('kids').doc(kidId).update({
        'wallet.$fromJar.balance': fromBalance - amount,
        'wallet.$toJar.balance': toBalance + amount,
      });
    } catch (e) {
      throw Exception('Failed to transfer between jars: ${e.toString()}');
    }
  }

  // Update CoinKids balance
  Future<void> updateCoinKidsBalance(String kidId, double newBalance) async {
    try {
      await _firestore.collection('kids').doc(kidId).update({
        'coinKidsBalance': newBalance,
      });
    } catch (e) {
      throw Exception('Failed to update CoinKids balance: ${e.toString()}');
    }
  }

  // Update kid's avatar
  Future<void> updateAvatar(String kidId, String newAvatarUrl) async {
    try {
      await _firestore.collection('kids').doc(kidId).update({
        'avatar': newAvatarUrl,
      });
      
      // Cache the new avatar
      await _cacheAvatarImage(newAvatarUrl);
    } catch (e) {
      throw Exception('Failed to update avatar: ${e.toString()}');
    }
  }

  // Update kid's grade
  Future<void> updateGrade(String kidId, String newGrade) async {
    try {
      await _firestore.collection('kids').doc(kidId).update({
        'grade': newGrade,
      });
    } catch (e) {
      throw Exception('Failed to update grade: ${e.toString()}');
    }
  }

  // Fetch all predefined avatars from Firebase Storage with caching
  Future<List<String>> fetchPredefinedAvatars({bool forceRefresh = false}) async {
    try {
      // Check if we have cached avatars and they're not expired
      if (!forceRefresh) {
        final cachedAvatars = await _getCachedAvatars();
        if (cachedAvatars.isNotEmpty) {
          return cachedAvatars;
        }
      }
      
      // If no cache or force refresh, fetch from Firebase
      final ListResult result = await _storage.ref('avatars').listAll();
      final List<String> urls = await Future.wait(
        result.items.map((ref) => ref.getDownloadURL()),
      );
      
      // Cache the avatars
      _cacheAvatarUrls(urls);

      // Download and cache the actual images
      _cacheAvatarImagesInBackground(urls);

      return urls;
    } catch (e) {
      // If fetching fails, try to return cached avatars as fallback
      final cachedAvatars = await _getCachedAvatars();
      if (cachedAvatars.isNotEmpty) {
        return cachedAvatars;
      }
      throw Exception('Failed to fetch avatars: $e');
    }
  }

  // Upload custom avatar image and get URL
  Future<String> uploadCustomAvatar(File imageFile) async {
    try {
      final String fileName =
          'user_avatars/${DateTime.now().millisecondsSinceEpoch}.${imageFile.path.split('.').last}';
      final Reference ref = _storage.ref().child(fileName);

      final UploadTask uploadTask = ref.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      final String url = await snapshot.ref.getDownloadURL();

      // Cache the avatar
      await _cacheAvatarImage(url);

      return url;
    } catch (e) {
      throw Exception('Failed to upload avatar: $e');
    }
  }

  // Stream to count number of kids for a parent
  Stream<int> streamKidsCount(String parentId) {
    return _firestore
        .collection('kids')
        .where('parentId', isEqualTo: parentId)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Stream to check if parent has any kids
  Stream<bool> streamHasKids(String parentId) {
    return _firestore
        .collection('kids')
        .where('parentId', isEqualTo: parentId)
        .limit(1) // More efficient than fetching all docs
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  // Stream single kid by parent ID
  Stream<KidModel?> streamKidByParentId(String parentId) {
    return _firestore
        .collection('kids')
        .where('parentId', isEqualTo: parentId)
        .limit(1)  // Ensure we only get one kid
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) {
            return null;
          }
          final doc = snapshot.docs.first;
          return KidModel.fromJson(
            doc.data(),
            documentId: doc.id,
          );
        });
  }

  // CACHING METHODS

  // Cache avatar URLs in SharedPreferences
  Future<void> _cacheAvatarUrls(List<String> urls) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_avatarCacheKey, urls);
      await prefs.setInt(_avatarCacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Failed to cache avatar URLs: $e');
    }
  }

  // Cache avatar images in background without blocking
  void _cacheAvatarImagesInBackground(List<String> urls) {
    // Use Future.forEach to process in background without awaiting
    Future.forEach(urls, (String url) async {
      await _cacheAvatarImage(url);
    });
  }

  // Get cached avatar URLs if not expired
  Future<List<String>> _getCachedAvatars() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_avatarCacheTimestampKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;

      // Check if cache is expired
      if (now - timestamp > _cacheExpiration.inMilliseconds) {
        return [];
      }

      return prefs.getStringList(_avatarCacheKey) ?? [];
    } catch (e) {
      print('Failed to get cached avatars: $e');
      return [];
    }
  }

  // Cache actual avatar image file
  Future<void> _cacheAvatarImage(String url) async {
    try {
      // Create a unique filename based on the URL
      final String filename = _getFilenameFromUrl(url);
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/avatars/$filename';

      // Create directory if it doesn't exist
      final dir = Directory('${directory.path}/avatars');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Check if file already exists
      final file = File(filePath);
      if (await file.exists()) {
        return; // Already cached
      }

      // Download and save the image
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
      }
    } catch (e) {
      print('Failed to cache avatar image: $e');
    }
  }

  // Get local path for a cached avatar
  Future<String?> getLocalAvatarPath(String url) async {
    try {
      final String filename = _getFilenameFromUrl(url);
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/avatars/$filename';

      final file = File(filePath);
      if (await file.exists()) {
        return filePath;
      }

      // If not cached, download and cache it
      await _cacheAvatarImage(url);

      // Check again after download attempt
      if (await file.exists()) {
        return filePath;
      }

      return null;
    } catch (e) {
      print('Failed to get local avatar path: $e');
      return null;
    }
  }

  // Generate a filename from URL
  String _getFilenameFromUrl(String url) {
    // Create a hash of the URL to use as filename
    final bytes = utf8.encode(url);
    final digest = base64Encode(bytes);
    return digest.replaceAll('/', '_').replaceAll('+', '-') + '.jpg';
  }

  // Clear avatar cache
  Future<void> clearAvatarCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_avatarCacheKey);
      await prefs.remove(_avatarCacheTimestampKey);

      final directory = await getApplicationDocumentsDirectory();
      final dir = Directory('${directory.path}/avatars');
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (e) {
      print('Failed to clear avatar cache: $e');
    }
  }
}
