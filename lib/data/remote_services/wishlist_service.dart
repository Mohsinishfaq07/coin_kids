import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/market_product_model.dart';
import '../models/wishlist_model.dart';
import 'market_service.dart';

class WishlistService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'wishlists';

  // Store both status and document ID
  final RxMap<String, String> wishlistItems = <String, String>{}.obs; // productId -> documentId

  final MarketService _marketService = MarketService();

  // Observable map to track wishlist status
  final RxMap<String, bool> wishlistStatus = <String, bool>{}.obs;

  // Fetch user's wishlist
  Future<List<WishlistModel>> fetchWishlist(String userId) async {
    try {
      final snapshot = await _firestore.collection(collection).where('userId', isEqualTo: userId).orderBy('addedAt', descending: true).get();

      return snapshot.docs.map((doc) => WishlistModel.fromJson(doc.data(), id: doc.id)).toList();
    } catch (e) {
      throw Exception('Failed to fetch wishlist: ${e.toString()}');
    }
  }

  // Add to wishlist
  Future<void> addToWishlist(WishlistModel wishlist) async {
    try {
      final docRef = await _firestore.collection(collection).add(wishlist.toJson());
      wishlistItems[wishlist.productId] = docRef.id;
      wishlistItems.refresh();
    } catch (e) {
      throw Exception('Failed to add to wishlist: ${e.toString()}');
    }
  }

  // Remove from wishlist
  Future<void> removeFromWishlist(String productId) async {
    try {
      final docId = wishlistItems[productId];
      if (docId != null) {
        await _firestore.collection(collection).doc(docId).delete();
        wishlistItems.remove(productId);
        wishlistItems.refresh();
      }
    } catch (e) {
      throw Exception('Failed to remove from wishlist: ${e.toString()}');
    }
  }

  // Refresh wishlist statuses
  Future<void> refreshWishlistStatuses(String userId) async {
    try {
      final snapshot = await _firestore.collection(collection).where('userId', isEqualTo: userId).get();

      wishlistItems.clear();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        wishlistItems[data['productId'] as String] = doc.id;
      }
      wishlistItems.refresh();
    } catch (e) {
      Get.log('Failed to refresh wishlist statuses: $e');
    }
  }

  // Method to fetch the count of the wishlist for the current kid

  Stream<List<WishlistModel>> getWishlistStream(String userId) {
    return _firestore.collection('wishlist').where('userId', isEqualTo: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => WishlistModel.fromJson(doc.data())).toList();
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
  Future<DocumentReference> addProductToWishlist(String userId, MarketProductModel product) async {
    try {
      final wishlist = WishlistModel.fromProduct(userId, product);
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
  Future<List<WishlistModel>> fetchKidWishlist(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection(collection).where('userId', isEqualTo: userId).orderBy('addedAt', descending: true).get();

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
  bool isInWishlist(String productId) {
    return wishlistItems.containsKey(productId);
  }

  // Fetch affordable items from wishlist
  Future<List<WishlistModel>> fetchAffordableItems(String userId, double balance) async {
    try {
      final wishlist = await fetchKidWishlist(userId);
      return wishlist.where((item) => item.isAffordable(balance)).toList();
    } catch (e) {
      throw Exception('Failed to fetch affordable items: ${e.toString()}');
    }
  }

  // Fetch priority items
  Future<List<WishlistModel>> fetchPriorityItems(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection(collection).where('userId', isEqualTo: userId).where('isPriority', isEqualTo: true).orderBy('addedAt', descending: true).get();

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
