import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../data/models/market_product_model.dart';

enum FilterType { all, age, budget }

class MarketController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<MarketProductModel> products = <MarketProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 10000.0.obs;
  final RxDouble minRating = 0.0.obs;
  final RxDouble maxRating = 5.0.obs;
  final RxInt minAge = 0.obs;
  final RxInt maxAge = 99.obs;

  final RxString searchQuery = ''.obs;

  final Rx<FilterType> currentFilter = FilterType.all.obs;

  List<dynamic> get filteredProducts => products.where((product) {
        final bool priceInRange =
            product.price >= minPrice.value && product.price <= maxPrice.value;
        final bool ratingInRange = product.rating >= minRating.value &&
            product.rating <= maxRating.value;
        final bool ageInRange =
            product.minAge >= minAge.value && product.maxAge <= maxAge.value;

        final bool matchesSearch = searchQuery.isEmpty ||
            product.name
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase());

        return priceInRange && ratingInRange && ageInRange && matchesSearch;
      }).toList();

  void updatePriceRange(double min, double max) {
    minPrice.value = min;
    maxPrice.value = max;
  }

  void updateRatingRange(double min, double max) {
    minRating.value = min;
    maxRating.value = max;
  }

  void updateAgeRange(int min, int max) {
    minAge.value = min;
    maxAge.value = max;
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  void updateFilter(FilterType type) {
    currentFilter.value = type;
  }

  void resetFilters() {
    updatePriceRange(0, 10000);
    updateAgeRange(0, 99);
    updateRatingRange(0, 5);
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      error.value = '';

      final snapshot = await _firestore.collection('products').get();
      final productList = snapshot.docs
          .map((doc) => MarketProductModel.fromJson(doc.data(), id: doc.id))
          .toList();

      products.value = productList;
    } catch (e) {
      error.value = 'Failed to fetch products: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<MarketProductModel?> getProductById(String id) async {
    try {
      final doc = await _firestore.collection('products').doc(id).get();
      if (!doc.exists) {
        error.value = 'Product not found';
        return null;
      }
      return MarketProductModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id);
    } catch (e) {
      error.value = 'Failed to fetch product: ${e.toString()}';
      return null;
    }
  }
}
