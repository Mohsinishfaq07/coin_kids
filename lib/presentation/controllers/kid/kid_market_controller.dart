import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_kids/core/constants/analytics_constants.dart';
import 'package:coin_kids/core/theme/color_theme.dart';
import 'package:coin_kids/core/utils/toast_util.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/data/models/goal_model.dart';
import 'package:coin_kids/data/models/market_product_model.dart';
import 'package:coin_kids/data/models/wishlist_model.dart';
import 'package:coin_kids/data/remote_services/analytics_service.dart';
import 'package:coin_kids/data/remote_services/goal_service.dart';
import 'package:coin_kids/data/remote_services/market_service.dart';
import 'package:coin_kids/data/remote_services/wishlist_service.dart';
import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/generated_assets/assets.dart';
import 'package:coin_kids/presentation/components/kid/kid_button.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/dialogs/kid/kid_dialog.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../dialogs/common/loading_dialog.dart';
import '../kid/kid_appbar_controller.dart';
import '../parent/parent_market_controller.dart';

class KidMarketController extends GetxController {
  final MarketService _marketService = Get.find<MarketService>();
  final WishlistService _wishlistService = Get.find<WishlistService>();
  final AppStateController _appState = Get.find();
  final KidAppBarController appBarController = Get.find<KidAppBarController>();
  final GoalService goalService = Get.find<GoalService>();

  // All products fetched from server (source of truth)
  final RxList<MarketProductModel> _allProducts = <MarketProductModel>[].obs;

  // Filtered/Searched products (what we show in UI)
  final RxList<MarketProductModel> displayProducts = <MarketProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;

  // Filter states
  final Rx<FilterType> activeFilter = FilterType.all.obs;
  final RxList<AgeRange> selectedAgeRanges = <AgeRange>[].obs;
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

  final ScrollController scrollController = ScrollController();
  final RxBool showFilters = true.obs;

  final RxInt wishlistItemCount = 0.obs;

  final RxBool showPointer = true.obs;
  final RxBool showWishlistTutorial = false.obs;
  // static const String hasSeenWishlistTutorial = 'hasSeenWishlistTutorial';
  final analytics = Get.find<AnalyticsService>();

  @override
  void onInit() {
    super.onInit();

    ever(appBarController.searchQuery, (query) {
      updateSearch(query);
    });
    _screenStartTime = DateTime.now();
    logScreenTime();

    fetchProducts();
    _initializeWishlist();
    _setupWishlistListener();
    _setupListeners();
    checkTutorialState();
  }

  void _initializeWishlist() {
    final kid = _appState.currentKid.value;

    if (kid != null) {
      _wishlistService.refreshWishlistStatuses(kid.kidId);
    }
  }

  void updateSearch(String query) {
    searchQuery.value = query.trim();
    applyFilters(); // Apply filters immediately when search changes
  }

  void setFilter(FilterType type) {
    if (type == FilterType.all) {
      resetAllFilters();
    }
    activeFilter.value = type;
  }

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
    selectedAgeRanges.clear();
    selectedMinBudget.value = minBudget.value;
    selectedMaxBudget.value = maxBudget.value;
    selectedMinRating.value = minRating.value;
    selectedMaxRating.value = maxRating.value;
    isAgeFilterActive.value = false;
    isBudgetFilterActive.value = false;
    isRatingFilterActive.value = false;
    activeFilter.value = FilterType.all;
    searchQuery.value = '';
    applyFilters();
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
        return '0-2 years';
      case AgeRange.threeToFive:
        return '3-5 years';
      case AgeRange.sixToNine:
        return '6-9 years';
      case AgeRange.tenToTwelve:
        return '10-12 years';
      case AgeRange.thirteenToSixteen:
        return '13-16 years';
      case AgeRange.sixteenPlus:
        return '16+ years';
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
      isInitialized.value =
          true; // Set to true once products are loaded initially
    } catch (e) {
      error.value = 'Failed to fetch products: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    if (_allProducts.isEmpty) return;

    var filtered = _allProducts.where((product) {
      // Apply search filter
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        final name = product.name.toLowerCase();
        if (!name.contains(query)) {
          return false;
        }
      }

      // Apply age filter if active
      if (isAgeFilterActive.value && selectedAgeRanges.isNotEmpty) {
        bool matchesAnyRange = false;
        for (var range in selectedAgeRanges) {
          final (minAge, maxAge) = getAgeRangeValues(range);
          if (!(product.minAge > maxAge || product.maxAge < minAge)) {
            matchesAnyRange = true;
            break;
          }
        }
        if (!matchesAnyRange) return false;
      }

      // Apply budget filter if active
      if (isBudgetFilterActive.value) {
        if (product.price < selectedMinBudget.value ||
            product.price > selectedMaxBudget.value) {
          return false;
        }
      }

      // Apply rating filter if active
      if (isRatingFilterActive.value) {
        if (product.rating < selectedMinRating.value ||
            product.rating > selectedMaxRating.value) {
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
      final kid = _appState.currentKid.value;

      if (kid == null) {
        throw Exception('Child not found');
      }

      loadingItems[product.id!] = true;
      loadingItems.refresh();

      if (initialIsInWishlist) {
        // Add timeout to Firestore operation
        await _wishlistService.removeFromWishlist(product.id!).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException(
                'Connection timed out. Please check your internet connection.');
          },
        );
      } else {
        final wishlistModel = WishlistModel.fromProduct(kid.kidId, product);
        await _wishlistService.addToWishlist(wishlistModel).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException(
                'Connection timed out. Please check your internet connection.');
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

  void hideFilters() {
    if (showFilters.value) {
      showFilters.value = false;
    }
  }

  void showFilter() {
    if (!showFilters.value) {
      showFilters.value = true;
    }
  }

  void _setupListeners() {
    // Listen to all filter changes and apply filters
    ever(searchQuery, (_) => applyFilters());
    ever(selectedAgeRanges, (_) => applyFilters());
    ever(selectedMinBudget, (_) => applyFilters());
    ever(selectedMaxBudget, (_) => applyFilters());
    ever(selectedMinRating, (_) => applyFilters());
    ever(selectedMaxRating, (_) => applyFilters());
    ever(isAgeFilterActive, (_) => applyFilters());
    ever(isBudgetFilterActive, (_) => applyFilters());
    ever(isRatingFilterActive, (_) => applyFilters());
  }

  void _setupWishlistListener() {
    ever(_wishlistService.wishlistItems, (items) {
      wishlistItemCount.value = items.length;
    });
  }

  @override
  void onClose() {
    // appBarController.resetToDefault();
    scrollController.dispose();
    logScreenTime();

    super.onClose();
  }

  Future<void> checkTutorialState() async {
    // Check favorite tutorial state
    final hasSeenFavoriteTutorial = SharedPreferencesHelper.getBool(
            SharedPreferencesHelper.hasSeenMarketTutorial) ??
        false;
    showPointer.value = !hasSeenFavoriteTutorial;

    // Initially hide wishlist tutorial, it will be shown after favorite tutorial
    showWishlistTutorial.value = false;
  }

  Future<void> dismissFavoriteTutorial() async {
    showPointer.value = false;
    await SharedPreferencesHelper.saveBool(
        SharedPreferencesHelper.hasSeenMarketTutorial, true);

    // After favorite tutorial is dismissed, check if wishlist tutorial should be shown
    final hasSeenWishlist = SharedPreferencesHelper.getBool(
            SharedPreferencesHelper.hasSeenWishlistTutorial) ??
        false;
    if (!hasSeenWishlist) {
      showWishlistTutorial.value = true;
    }
  }

  Future<void> dismissWishlistTutorial() async {
    showWishlistTutorial.value = false;
    await SharedPreferencesHelper.saveBool(
        SharedPreferencesHelper.hasSeenWishlistTutorial, true);
  }

  bool handleAddToGoalValidation() {
    final kid = _appState.currentKid.value;
    if (kid == null) {
      ToastUtil.showToast('Session expired');
      return false;
    }

    final spendingJarColor = kid.wallet.spendingJar.color;
    if (spendingJarColor == 0) {
      _showCreateJarDialog();
      return false;
    }
    return true;
  }

  void _showCreateJarDialog() {
    KidDialog.show(
      dismissible: true,
      emoji: Assets.emojiSad,
      title: "Create Jar First",
      subtitle: "You need to create a spending jar before adding goals",
      buttons: [
        KidButton(
          text: "OK",
          onTap: () {
            Get.back();
          },
          baseColor: AppColors.btnColorGreen,
          iconPath: Assets.icCross,
          iconPosition: IconPosition.left,
        ),
      ],
    );
  }

  void addToGoal(MarketProductModel product) async {
    showLoadingDialog("Adding to Goal");

    try {
      // First check if goal already exists for this product

      // If goal doesn't exist or has accepted/rejected/deleted status, proceed with creation
      final goalId = await goalService.addToGoalsWithProduct(product);

      if (goalId == null) {
        Get.back(); // Close loading dialog
        ToastUtil.showToast("Failed to add Goal");
        return;
      }

      Get.back(); // Close loading dialog

      // Show success dialog
      await KidDialogWithCross.show(
        emoji: Assets.icClap,
        title: 'Goal Created!',
        subtitle: 'The goal was added \n successfully',
        buttons: [
          KidButton(
            text: 'See Goal',
            onTap: () async {
              Get.offNamed(Routes.kidGoalDetailsScreen,
                  arguments: goalId);
              // Get.back(); // Close success dialog
              // Get.until((route) => route.settings.name == Routes.kidBase);
              // Get.toNamed(Routes.kidGoalDetailsScreen, arguments: goalId);
            },
            baseColor: AppColors.btnColorGreen,
          ),
        ],
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.log(e.toString(), isError: true);
      ToastUtil.showToast("Failed to add Goal");
      Get.until((route) => route.settings.name == Routes.kidBase);
    }
  }

  DateTime? _screenStartTime;

  Future<void> logScreenTime() async {
    if (_screenStartTime != null) {
      final endTime = DateTime.now();
      final durationInSeconds = endTime.difference(_screenStartTime!).inSeconds;
      analytics.screenTime(
          AnalyticsScreenNames.kidMarketScreen, durationInSeconds.toString());
    }
    FirebaseAnalytics.instance.logScreenView(
      screenName: AnalyticsScreenNames.kidMarketScreen,
    );
  }
}
