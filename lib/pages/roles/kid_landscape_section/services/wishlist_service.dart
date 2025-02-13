import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/wishlist_model.dart';
import '../kid_market/product_model.dart';
import 'package:get/get.dart';

class WishlistService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable map to track wishlist status
  final RxMap<String, bool> wishlistStatus = <String, bool>{}.obs;

  Future<List<WishlistModel>> fetchWishlist() async {
    try {
      final String kidId = _auth.currentUser?.uid ?? 'L7oiYyQUhT2aBRbmfUEP';

      // Modified query to use simple ordering
      final snapshot = await _firestore
          .collection('wishlist')
          .where('kidId', isEqualTo: kidId)
          .where('deleted', isEqualTo: false)
          // Remove the orderBy clause if you don't want to create an index
          // .orderBy('addedAt', descending: true)
          .get();

      // Sort the results in memory instead
      final results = snapshot.docs
          .map((doc) => WishlistModel.fromJson(doc.data()))
          .toList();

      results.sort((a, b) => b.addedAt.compareTo(a.addedAt));

      return results;
    } catch (e) {
      throw Exception('Failed to fetch wishlist: ${e.toString()}');
    }
  }

  Future<void> addToWishlist(ProductModel product) async {
    try {
      final String kidId = _auth.currentUser?.uid ?? 'L7oiYyQUhT2aBRbmfUEP';

      final wishlistRef = _firestore.collection('wishlist').doc();
      final wishlistModel =
          WishlistModel.fromProduct(kidId, product, wishlistRef.id);

      await wishlistRef.set(wishlistModel.toJson());
      wishlistStatus[product.id] = true; // Update status immediately
    } catch (e) {
      throw Exception('Failed to add to wishlist: ${e.toString()}');
    }
  }

  Future<void> removeFromWishlist(String wishlistId, String productId) async {
    try {
      await _firestore
          .collection('wishlist')
          .doc(wishlistId)
          .update({'deleted': true});
      // Update status immediately and notify all listeners
      wishlistStatus[productId] = false;
      // Force refresh the status
      wishlistStatus.refresh();
    } catch (e) {
      throw Exception('Failed to remove from wishlist: ${e.toString()}');
    }
  }

  Future<bool> isInWishlist(String productId) async {
    try {
      // First check the cached status
      if (wishlistStatus.containsKey(productId)) {
        return wishlistStatus[productId]!;
      }

      final String kidId = _auth.currentUser?.uid ?? 'L7oiYyQUhT2aBRbmfUEP';
      final snapshot = await _firestore
          .collection('wishlist')
          .where('kidId', isEqualTo: kidId)
          .where('productId', isEqualTo: productId)
          .where('deleted', isEqualTo: false)
          .get();

      final status = snapshot.docs.isNotEmpty;
      wishlistStatus[productId] = status; // Cache the status
      return status;
    } catch (e) {
      return false;
    }
  }

  // Add method to clear wishlist status for specific product
  void clearWishlistStatus(String productId) {
    wishlistStatus.remove(productId);
    wishlistStatus.refresh();
  }

  // Add method to refresh all wishlist statuses
  Future<void> refreshWishlistStatuses() async {
    try {
      final String kidId = _auth.currentUser?.uid ?? 'L7oiYyQUhT2aBRbmfUEP';
      final snapshot = await _firestore
          .collection('wishlist')
          .where('kidId', isEqualTo: kidId)
          .where('deleted', isEqualTo: false)
          .get();

      // Clear existing statuses
      wishlistStatus.clear();

      // Update with new statuses
      for (var doc in snapshot.docs) {
        final data = doc.data();
        wishlistStatus[data['productId'] as String] = true;
      }

      wishlistStatus.refresh();
    } catch (e) {
      print('Failed to refresh wishlist statuses: $e');
    }
  }
}
