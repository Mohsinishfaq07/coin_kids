import 'package:coin_kids/data/models/wishlist_model.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/wishlist_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParentWishlistController extends GetxController {
  final WishlistService _wishlistService = Get.find<WishlistService>();
  final AuthService _authService = Get.find<AuthService>();

  final RxList<WishlistModel> wishlistItems = <WishlistModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  Future<void> fetchWishlist() async {
    try {
      isLoading.value = true;
      error.value = '';

      final parentId = _authService.userId;
      if (parentId.isEmpty) {
        throw Exception('No kid selected');
      }

      final items = await _wishlistService.fetchKidWishlist(parentId);
      wishlistItems.value = items;
    } catch (e) {
      error.value = 'Failed to load wishlist: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      // Remove item from local list first for immediate UI update
      final index = wishlistItems.indexWhere((item) => item.productId == productId);
      if (index != -1) {
        wishlistItems.removeAt(index);
      }

      // Then remove from backend
      await _wishlistService.removeFromWishlist(productId);
    } catch (e) {
      // If backend call fails, revert the local change
      await fetchWishlist();
      Get.snackbar(
        'Error',
        'Failed to remove item from wishlist',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
