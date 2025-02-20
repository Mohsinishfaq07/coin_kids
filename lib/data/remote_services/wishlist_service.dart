import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/wishlist_model.dart';
import 'package:get/get.dart';
import '../models/market_product_model.dart';
import 'market_service.dart';

class WishlistService extends GetxService {
  final RxList<dynamic> wishlistItems = <dynamic>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final MarketService _marketService = MarketService();
  final String collection = 'wishlists';

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

  Future<void> addToWishlist(MarketProductModel product) async {
    try {
      final String kidId = _auth.currentUser?.uid ?? 'L7oiYyQUhT2aBRbmfUEP';

      final wishlistRef = _firestore.collection('wishlist').doc();
      final wishlistModel =
          WishlistModel.fromProduct(kidId, product);

      await wishlistRef.set(wishlistModel.toJson());
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

  // Method to fetch the count of the wishlist for the current kid

  Stream<List<WishlistModel>> getWishlistStream() {
    final String kidId = _auth.currentUser?.uid ?? 'L7oiYyQUhT2aBRbmfUEP';
    return _firestore
        .collection('wishlist')
        .where('kidId', isEqualTo: kidId)
        .where('deleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => WishlistModel.fromJson(doc.data()))
          .toList();
    });
  }

  // Add item to wishlist
  Future<DocumentReference> addToWishlistModel(WishlistModel wishlist) async {
    try {
      final docRef = await _firestore.collection(collection).add(wishlist.toJson());
      return docRef;
    } catch (e) {
      throw Exception('Failed to add to wishlist: ${e.toString()}');
    }
  }

  // Add product to wishlist
  Future<DocumentReference> addProductToWishlist(String kidId, MarketProductModel product) async {
    try {
      final wishlist = WishlistModel.fromProduct(kidId, product);
      return await addToWishlistModel(wishlist);
    } catch (e) {
      throw Exception('Failed to add product to wishlist: ${e.toString()}');
    }
  }

  // Fetch wishlist item by ID
  Future<WishlistModel?> fetchWishlistItemById(String wishlistId) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection(collection).doc(wishlistId).get();
      
      if (!doc.exists) {
        return null;
      }

      // Fetch associated product data
      final data = doc.data() as Map<String, dynamic>;
      final productId = data['productId'] as String;
      final product = await _marketService.fetchProductById(productId);

      return WishlistModel.fromJson(data, id: doc.id, product: product);
    } catch (e) {
      throw Exception('Failed to fetch wishlist item: ${e.toString()}');
    }
  }

  // Fetch kid's wishlist
  Future<List<WishlistModel>> fetchKidWishlist(String kidId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collection)
          .where('kidId', isEqualTo: kidId)
          .orderBy('isPriority', descending: true)
          .orderBy('addedAt', descending: true)
          .get();

      // Fetch all associated products
      final List<WishlistModel> wishlist = [];
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final productId = data['productId'] as String;
        final product = await _marketService.fetchProductById(productId);
        
        wishlist.add(WishlistModel.fromJson(data, id: doc.id, product: product));
      }

      return wishlist;
    } catch (e) {
      throw Exception('Failed to fetch kid wishlist: ${e.toString()}');
    }
  }

  // Remove item from wishlist
  Future<void> removeFromWishlistModel(String wishlistId) async {
    try {
      await _firestore.collection(collection).doc(wishlistId).delete();
    } catch (e) {
      throw Exception('Failed to remove from wishlist: ${e.toString()}');
    }
  }

  // Toggle priority status
  Future<void> togglePriority(String wishlistId) async {
    try {
      final wishlistItem = await fetchWishlistItemById(wishlistId);
      if (wishlistItem == null) {
        throw Exception('Wishlist item not found');
      }

      await _firestore.collection(collection).doc(wishlistId).update({
        'isPriority': !wishlistItem.isPriority,
      });
    } catch (e) {
      throw Exception('Failed to toggle priority: ${e.toString()}');
    }
  }

  // Check if product is in wishlist
  Future<bool> isInWishlistModel(String kidId, String productId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collection)
          .where('kidId', isEqualTo: kidId)
          .where('productId', isEqualTo: productId)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check wishlist: ${e.toString()}');
    }
  }

  // Fetch affordable items from wishlist
  Future<List<WishlistModel>> fetchAffordableItems(String kidId, double balance) async {
    try {
      final wishlist = await fetchKidWishlist(kidId);
      return wishlist.where((item) => item.isAffordable(balance)).toList();
    } catch (e) {
      throw Exception('Failed to fetch affordable items: ${e.toString()}');
    }
  }

  // Fetch priority items
  Future<List<WishlistModel>> fetchPriorityItems(String kidId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collection)
          .where('kidId', isEqualTo: kidId)
          .where('isPriority', isEqualTo: true)
          .orderBy('addedAt', descending: true)
          .get();

      // Fetch all associated products
      final List<WishlistModel> wishlist = [];
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final productId = data['productId'] as String;
        final product = await _marketService.fetchProductById(productId);
        
        wishlist.add(WishlistModel.fromJson(data, id: doc.id, product: product));
      }

      return wishlist;
    } catch (e) {
      throw Exception('Failed to fetch priority items: ${e.toString()}');
    }
  }
}
