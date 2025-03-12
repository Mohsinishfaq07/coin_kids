import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/market_product_model.dart';

class MarketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'products';

  // Create new product
  Future<DocumentReference> createProduct(MarketProductModel product) async {
    try {
      final docRef = await _firestore.collection(collection).add(product.toJson());
      return docRef;
    } catch (e) {
      throw Exception('Failed to create product: ${e.toString()}');
    }
  }

  // Fetch product by ID
  Future<MarketProductModel?> fetchProductById(String productId) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection(collection).doc(productId).get();
      
      if (!doc.exists) {
        return null;
      }

      return MarketProductModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id);
    } catch (e) {
      throw Exception('Failed to fetch product: ${e.toString()}');
    }
  }

  // Fetch all products
  Future<List<MarketProductModel>> fetchAllProducts() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collection)
          .orderBy('rating', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MarketProductModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products: ${e.toString()}');
    }
  }

  // Fetch products by age range
  Future<List<MarketProductModel>> fetchProductsByAgeRange(int minAge, int maxAge) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collection)
          .where('min_age', isLessThanOrEqualTo: maxAge)
          .where('max_age', isGreaterThanOrEqualTo: minAge)
          .orderBy('max_age')
          .orderBy('rating', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MarketProductModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products by age range: ${e.toString()}');
    }
  }

  // Fetch products by price range
  Future<List<MarketProductModel>> fetchProductsByPriceRange(double minPrice, double maxPrice) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collection)
          .where('price', isGreaterThanOrEqualTo: minPrice)
          .where('price', isLessThanOrEqualTo: maxPrice)
          .orderBy('price')
          .get();

      return snapshot.docs
          .map((doc) => MarketProductModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products by price range: ${e.toString()}');
    }
  }

  // Search products by name
  Future<List<MarketProductModel>> searchProducts(String query) async {
    try {
      // Convert query to lowercase for case-insensitive search
      query = query.toLowerCase();
      
      final QuerySnapshot snapshot = await _firestore
          .collection(collection)
          .orderBy('name')
          .get();

      // Perform client-side filtering since Firestore doesn't support case-insensitive search
      return snapshot.docs
          .map((doc) => MarketProductModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id))
          .where((product) => product.name.toLowerCase().contains(query))
          .toList();
    } catch (e) {
      throw Exception('Failed to search products: ${e.toString()}');
    }
  }

  // Update product
  Future<void> updateProduct(String productId, MarketProductModel product) async {
    try {
      await _firestore.collection(collection).doc(productId).update(product.toJson());
    } catch (e) {
      throw Exception('Failed to update product: ${e.toString()}');
    }
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection(collection).doc(productId).delete();
    } catch (e) {
      throw Exception('Failed to delete product: ${e.toString()}');
    }
  }

  // Fetch top rated products
  Future<List<MarketProductModel>> fetchTopRatedProducts({int limit = 10}) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collection)
          .orderBy('rating', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => MarketProductModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch top rated products: ${e.toString()}');
    }
  }

  // Fetch products within budget
  Future<List<MarketProductModel>> fetchProductsWithinBudget(double budget) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collection)
          .where('price', isLessThanOrEqualTo: budget)
          .orderBy('price', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MarketProductModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch products within budget: ${e.toString()}');
    }
  }
} 