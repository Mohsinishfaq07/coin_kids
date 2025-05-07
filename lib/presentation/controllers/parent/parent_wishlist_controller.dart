import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/data/models/wishlist_model.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/wishlist_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParentWishlistController extends GetxController {
  final WishlistService _wishlistService = Get.find<WishlistService>();
  final AuthService _authService = Get.find<AuthService>();
  final analytics = Get.find<AnalyticsService>();


  final RxList<WishlistModel> wishlistItems = <WishlistModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  DateTime? _screenStartTime;


  @override
  void onInit() {
    super.onInit();
    _screenStartTime = DateTime.now();
    logScreenTime();
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


  @override
  void onClose() {
    logScreenTime();
    super.onClose();
  }

  Future<void> logScreenTime() async {
    if (_screenStartTime != null) {
      final endTime = DateTime.now();
      final durationInSeconds = endTime.difference(_screenStartTime!).inSeconds;
      analytics.screenTime(AnalyticsScreenNames.signIn,durationInSeconds.toString());
    }
    FirebaseAnalytics.instance.logScreenView(
      screenName: AnalyticsScreenNames.signIn,
    );
  }

}
