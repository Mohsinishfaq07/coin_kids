import 'package:coin_kids/di/routes/app_pages.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:get/get.dart';
import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';

class KidAppBarController extends GetxController {
  final AppStateController appState = Get.find<AppStateController>();

  // Visibility flags
  final showBackButton = false.obs;
  final showProfile = true.obs;
  final showTitle = false.obs;
  final showSearch = false.obs;
  final showSpendingCard = true.obs;
  final showCoinKidsCard = true.obs;
  final showTotalCard = true.obs;

  // Showcase flags
  final showTotalMoneySpotlight = false.obs;

  final searchQuery = ''.obs;
  final title = ''.obs;

  // Add this observable
  final RxBool showAddMoneyGlow = true.obs;
  // Guard flags to avoid redundant reconfiguration

  @override
  void onInit() {
    super.onInit();
    initializeGlowState();
  }

  Future<void> initializeGlowState() async {
    try {
      final shouldGlow = await SharedPreferencesHelper.getBool(
        SharedPreferencesHelper.showAddMoneyGlow,
      );
      Get.log("Loading glow state: $shouldGlow");
      showAddMoneyGlow.value = shouldGlow ?? true;
    } catch (e) {
      Get.log("Error loading glow state: $e");
      showAddMoneyGlow.value = true;
    }
  }

  // bool shouldShowRequestMoneySpotlight() {
  //   if (appState.currentKid.value == null || appState.currentParent.value == null) {
  //     return false;
  //   }
  //
  //   final jarNotCreated = appState.currentKid.value!.wallet.spendingJar.color == 0;
  //   final noBalance = appState.currentKid.value!.wallet.spendingJar.balance == 0;
  //
  //   final result = jarNotCreated && noBalance && showTotalMoneySpotlight.value;
  //
  //   Get.log("shouldShowRequestMoneySpotlight: $result");
  //
  //   return result;
  // }

  // Configure the app bar for different screens
  void configureForHome() {
    // Only apply when we're actually on the KidBase route
    final route = Get.currentRoute;
    if (route != Routes.kidBase) return;
    showBackButton.value = false;
    showProfile.value = true;
    showTitle.value = false;
    showSearch.value = false;
    showSpendingCard.value = false;
    showCoinKidsCard.value = false;
    showTotalCard.value = true;
  }

  void configureForDetail({required String title}) {
    showBackButton.value = true;
    showProfile.value = false;
    showTitle.value = true;
    showSearch.value = false;
    showSpendingCard.value = true;
    showCoinKidsCard.value = true;
    showTotalCard.value = true;
    this.title.value = title;
  }

  void configureForSearch() {
    showBackButton.value = true;
    showProfile.value = false;
    showTitle.value = false;
    showSearch.value = true;
    showSpendingCard.value = false;
    showCoinKidsCard.value = false;
    showTotalCard.value = true;
  }

  void toggleProfile(bool value) => showProfile.value = value;

  void toggleTotalCard(bool value) => showTotalCard.value = value;

  void toggleSpendingCard(bool value) => showSpendingCard.value = value;

  void toggleSearch(bool value) => showSearch.value = value;

  void toggleBackButton(bool value) => showBackButton.value = value;

  void toggleTitle(bool value) => showTitle.value = value;

  void toggleCoinKidsCard(bool value) => showCoinKidsCard.value = value;

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void updateTitle(String newTitle) {
    title.value = newTitle;
  }

  void resetToDefault() {
    showBackButton.value = false;
    showProfile.value = true;
    showTitle.value = false;
    // showSpendingCard.value = true;
    // showCoinKidsCard.value = true;
    showTotalCard.value = true;
    showSearch.value = false;
    searchQuery.value = '';
    title.value = '';
  }

  void configureForAddMoney() {
    toggleProfile(false);
    toggleSearch(false);
    toggleSpendingCard(true);
    toggleTotalCard(false);
    toggleBackButton(true);
    toggleTitle(true);
  }

  void configureForMarket() {
    toggleProfile(false);
    toggleSearch(true);
    toggleSpendingCard(true);
    toggleTotalCard(false);
    toggleBackButton(false);
    toggleTitle(false);
  }

  void configureForTransfer() {
    showBackButton.value = true;
    showProfile.value = false;
    showTitle.value = true;
    showSpendingCard.value = true;
    showCoinKidsCard.value = false;
    showTotalCard.value = false;
    showSearch.value = false;
  }

  void configureForGoalSetup() {
    // Only apply when we're on goal-related routes to avoid late post-frame flips
    final route = Get.currentRoute;
    if (route != Routes.kidGoalDetailsScreen && route != Routes.kidGoalSummary) {
      return;
    }
    showBackButton.value = true;
    showProfile.value = false;
    showTitle.value = true;
    showSearch.value = false;
    showSpendingCard.value = true;
    showCoinKidsCard.value = true;
    showTotalCard.value = false;
  }

  void configureForWishlist() {
    showBackButton.value = true;
    showProfile.value = false;
    showTitle.value = true;
    showSearch.value = false;
    showSpendingCard.value = true;
    showCoinKidsCard.value = false;
    showTotalCard.value = false;
  }

  Future<void> stopAddMoneyGlow() async {
    try {
      Get.log("Stopping glow animation...");
      showAddMoneyGlow.value = false;
      await SharedPreferencesHelper.saveBool(
        SharedPreferencesHelper.showAddMoneyGlow,
        false,
      );
      Get.log("Glow animation stopped and saved to preferences");
    } catch (e) {
      Get.log("Error stopping glow animation: $e");
    }
  }

  // Add method to reset glow if needed
  Future<void> resetGlowState() async {
    showAddMoneyGlow.value = true;
    await SharedPreferencesHelper.saveBool(
      SharedPreferencesHelper.showAddMoneyGlow,
      true,
    );
  }
}
