import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/data/models/product_model.dart';
import 'package:get/get.dart';

class MarketController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

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
          .map((doc) => ProductModel.fromJson(doc.data()))
          .toList();
      
      products.value = productList;
    } catch (e) {
      error.value = 'Failed to fetch products: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<ProductModel?> getProductById(String id) async {
    try {
      final doc = await _firestore.collection('products').doc(id).get();
      if (!doc.exists) {
        error.value = 'Product not found';
        return null;
      }
      return ProductModel.fromJson(doc.data()!);
    } catch (e) {
      error.value = 'Failed to fetch product: ${e.toString()}';
      return null;
    }
  }
} 