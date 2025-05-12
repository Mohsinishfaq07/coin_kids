import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/data/models/market_product_model.dart';
import 'package:coin_kids/data/models/wishlist_model.dart';
import 'package:coin_kids/data/remote_services/auth_service.dart';
import 'package:coin_kids/data/remote_services/market_service.dart';
import 'package:coin_kids/data/remote_services/wishlist_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/analytics_constants.dart';
import '../../../data/remote_services/analytics_service.dart';

enum FilterType { all, age, budget, rating }

enum AgeRange { all, zeroToTwo, threeToFive, sixToNine, tenToTwelve, thirteenToSixteen, sixteenPlus }

class ParentMarketController extends GetxController {
  final MarketService _marketService = Get.find<MarketService>();
  final WishlistService _wishlistService = Get.find<WishlistService>();
  final AuthService _authService = Get.find();
  final analytics = Get.find<AnalyticsService>();
  final RxList<AgeRange> selectedAgeRanges = <AgeRange>[].obs;


  // All products fetched from server (source of truth)
  final RxList<MarketProductModel> _allProducts = <MarketProductModel>[].obs;

  // Filtered/Searched products (what we show in UI)
  final RxList<MarketProductModel> displayProducts = <MarketProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;

  // Filter states
  final Rx<FilterType> activeFilter = FilterType.all.obs;
  final Rx<AgeRange> selectedAgeRange = AgeRange.all.obs;
  final RxDouble minBudget = 0.0.obs;
  final RxDouble maxBudget = 0.0.obs;
  final RxDouble selectedMinBudget = 0.0.obs;
  final RxDouble selectedMaxBudget = 0.0.obs;
  final RxDouble minRating = 0.0.obs;
  final RxDouble maxRating = 5.0.obs;
  final RxDouble selectedMinRating = 0.0.obs;
  final RxDouble selectedMaxRating = 5.0.obs;

  // Track active filters separately
  final RxBool isAgeFilterActive = false.obs;
  final RxBool isBudgetFilterActive = false.obs;
  final RxBool isRatingFilterActive = false.obs;

  // Add new property to track if products were ever loaded
  final RxBool isInitialized = false.obs;

  // Track loading state for each product
  final RxMap<String, bool> loadingItems = <String, bool>{}.obs;

  final RxInt wishlistItemCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    _initializeWishlist();
    _setupWishlistListener();
    ever(searchQuery, (_) => applyFilters());
    ever(activeFilter, (_) => applyFilters());
    ever(selectedAgeRange, (_) => applyFilters());
    ever(selectedMinBudget, (_) => applyFilters());
    ever(selectedMaxBudget, (_) => applyFilters());
    ever(selectedMinRating, (_) => applyFilters());
    ever(selectedMaxRating, (_) => applyFilters());
    _screenStartTime = DateTime.now();
    logScreenTime();
  }

  void _initializeWishlist() {
    // Only initialize if we have a parent
    if (_authService.userId.isNotEmpty) {
      _wishlistService.refreshWishlistStatuses(_authService.userId);
    }
  }

  void _setupWishlistListener() {
    ever(_wishlistService.wishlistItems, (items) {
      wishlistItemCount.value = items.length;
    });
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  void setFilter(FilterType type) {
    if (type == FilterType.all) {
      resetAllFilters();
    }
    activeFilter.value = type;
  }

  // void setAgeRange(AgeRange range) {
  //   if (range == AgeRange.all) {
  //     isAgeFilterActive.value = false;
  //   } else {
  //     isAgeFilterActive.value = true;
  //   }
  //   selectedAgeRange.value = range;
  // }
  void setAgeRange(List<AgeRange> ranges) {
    selectedAgeRanges.value = ranges;
    isAgeFilterActive.value = ranges.isNotEmpty;
    applyFilters();
  }


  void setBudgetRange(double min, double max) {
    if (min == minBudget.value && max == maxBudget.value) {
      isBudgetFilterActive.value = false;
    } else {
      isBudgetFilterActive.value = true;
    }
    selectedMinBudget.value = min;
    selectedMaxBudget.value = max;
  }

  void setRatingRange(double min, double max) {
    if (min == minRating.value && max == maxRating.value) {
      isRatingFilterActive.value = false;
    } else {
      isRatingFilterActive.value = true;
    }
    selectedMinRating.value = min;
    selectedMaxRating.value = max;
  }

  void resetAllFilters() {
    selectedAgeRange.value = AgeRange.all;
    selectedMinBudget.value = minBudget.value;
    selectedMaxBudget.value = maxBudget.value;
    selectedMinRating.value = minRating.value;
    selectedMaxRating.value = maxRating.value;
    isAgeFilterActive.value = false;
    isBudgetFilterActive.value = false;
    isRatingFilterActive.value = false;
    activeFilter.value = FilterType.all;
  }
  String getAgeRangeText() {
    if (selectedAgeRanges.isEmpty) return '';
    if (selectedAgeRanges.length == 1) {
      return getSingleAgeRangeText(selectedAgeRanges.first);
    }
    return '${selectedAgeRanges.length} age groups';
  }

  String getSingleAgeRangeText(AgeRange range) {
    switch (range) {
      case AgeRange.all:
        return 'All Ages';
      case AgeRange.zeroToTwo:
        return '0-2';
      case AgeRange.threeToFive:
        return '3-5';
      case AgeRange.sixToNine:
        return '6-9';
      case AgeRange.tenToTwelve:
        return '10-12';
      case AgeRange.thirteenToSixteen:
        return '13-16';
      case AgeRange.sixteenPlus:
        return '16+';
    }
  }

  (int, int) getAgeRangeValues(AgeRange range) {
    switch (range) {
      case AgeRange.all:
        return (0, 99);
      case AgeRange.zeroToTwo:
        return (0, 2);
      case AgeRange.threeToFive:
        return (3, 5);
      case AgeRange.sixToNine:
        return (6, 9);
      case AgeRange.tenToTwelve:
        return (10, 12);
      case AgeRange.thirteenToSixteen:
        return (13, 16);
      case AgeRange.sixteenPlus:
        return (16, 99);
    }
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      error.value = '';

      final products = await _marketService.fetchAllProducts();
      _allProducts.value = products;

      // Set initial budget range based on products
      if (products.isNotEmpty) {
        minBudget.value = products.map((p) => p.price).reduce(min);
        maxBudget.value = products.map((p) => p.price).reduce(max);
        selectedMinBudget.value = minBudget.value;
        selectedMaxBudget.value = maxBudget.value;
      }

      displayProducts.value = products;
      isInitialized.value = true; // Set to true once products are loaded initially
    } catch (e) {
      error.value = 'Failed to fetch products: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    var filtered = _allProducts.where((product) {
      // Apply search filter
      if (searchQuery.isNotEmpty && !product.name.toLowerCase().contains(searchQuery.value.toLowerCase())) {
        return false;
      }

      // Apply age filter if active
      if (isAgeFilterActive.value && selectedAgeRange.value != AgeRange.all) {
        final (minAge, maxAge) = getAgeRangeValues(selectedAgeRange.value);
        if (product.minAge > maxAge || product.maxAge < minAge) {
          return false;
        }
      }

      // Apply budget filter if active
      if (isBudgetFilterActive.value) {
        if (product.price < selectedMinBudget.value || product.price > selectedMaxBudget.value) {
          return false;
        }
      }

      // Apply rating filter if active
      if (isRatingFilterActive.value) {
        if (product.rating < selectedMinRating.value || product.rating > selectedMaxRating.value) {
          return false;
        }
      }

      return true;
    }).toList();

    displayProducts.value = filtered;
  }

  Future<void> toggleWishlist(MarketProductModel product) async {
    if (loadingItems[product.id!] == true) return;

    final initialIsInWishlist = _wishlistService.isInWishlist(product.id!);

    try {
      final parentId = _authService.userId;
      if (parentId.isEmpty) {
        throw Exception('Parent not found');
      }

      loadingItems[product.id!] = true;
      loadingItems.refresh();

      if (initialIsInWishlist) {
        // Add timeout to Firestore operation
        await _wishlistService.removeFromWishlist(product.id!).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('Connection timed out. Please check your internet connection.');
          },
        );
      } else {
        final wishlistModel = WishlistModel.fromProduct(parentId, product);
        await _wishlistService.addToWishlist(wishlistModel).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('Connection timed out. Please check your internet connection.');
          },
        );
      }
    } on TimeoutException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'Operation timed out',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error, color: Colors.white),
      );

      // Restore the initial state
      if (initialIsInWishlist) {
        _wishlistService.wishlistItems[product.id!] = product.id!;
      } else {
        _wishlistService.wishlistItems.remove(product.id!);
      }
      _wishlistService.wishlistItems.refresh();
    } on FirebaseException catch (e) {
      String message = 'Failed to update wishlist';
      if (e.code == 'network-request-failed') {
        message = 'No internet connection. Please try again when online.';
      } else if (e.code == 'permission-denied') {
        message = 'You don\'t have permission to perform this action.';
      }

      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error, color: Colors.white),
      );

      // Restore the initial state
      if (initialIsInWishlist) {
        _wishlistService.wishlistItems[product.id!] = product.id!;
      } else {
        _wishlistService.wishlistItems.remove(product.id!);
      }
      _wishlistService.wishlistItems.refresh();
    } catch (e) {
      // Restore the initial state
      if (initialIsInWishlist) {
        _wishlistService.wishlistItems[product.id!] = product.id!;
      } else {
        _wishlistService.wishlistItems.remove(product.id!);
      }
      _wishlistService.wishlistItems.refresh();

      Get.log('Failed to update wishlist: ${e.toString()}');
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      loadingItems[product.id!] = false;
      loadingItems.refresh();
    }
  }

  bool isItemLoading(String productId) {
    return loadingItems[productId] ?? false;
  }

  bool isInWishlist(String productId) {
    return _wishlistService.isInWishlist(productId);
  }

  DateTime? _screenStartTime;

  @override
  void onClose() {
    logScreenTime();
    super.onClose();
  }

  Future<void> logScreenTime() async {
    if (_screenStartTime != null) {
      final endTime = DateTime.now();
      final durationInSeconds = endTime.difference(_screenStartTime!).inSeconds;
      analytics.screenTime(AnalyticsScreenNames.parentMarket,durationInSeconds.toString());
    }
    FirebaseAnalytics.instance.logScreenView(
      screenName: AnalyticsScreenNames.parentMarket,
    );
  }


}
