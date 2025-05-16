import 'package:coin_kids/data/local_services/shared_preferences_helper.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:get/get.dart';

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

  @override
  void onInit() {
    super.onInit();

    showTotalMoneySpotlight.value = SharedPreferencesHelper.getBool(SharedPreferencesHelper.showTotalMoneySpotlight) ?? true;
  }

  bool shouldShowRequestMoneySpotlight() {
    if (appState.currentKid.value == null || appState.currentParent.value == null) {
      return false;
    }

    final isParentOpened = appState.currentKid.value!.isConnected;
    final jarNotCreated = appState.currentKid.value!.wallet.spendingJar.color == 0;
    final noBalance = appState.currentKid.value!.wallet.spendingJar.balance == 0;

    final result = isParentOpened && jarNotCreated && noBalance && showTotalMoneySpotlight.value;

    Get.log("shouldShowRequestMoneySpotlight: $result");

    return result;
  }

  // Configure the app bar for different screens
  void configureForHome() {
    showBackButton.value = false;
    showProfile.value = true;
    showTitle.value = false;
    showSearch.value = false;
    showSpendingCard.value = true;
    showCoinKidsCard.value = true;
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
    showSpendingCard.value = true;
    showCoinKidsCard.value = true;
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
}
