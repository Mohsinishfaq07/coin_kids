import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:get/get.dart';

class KidAppBarController extends GetxController {
  final appState = Get.find<AppStateController>();

  final showProfile = true.obs;
  final showTotalCard = true.obs;
  final showSpendingCard = true.obs;
  final showCoinKidsCard = true.obs;
  final showSearch = false.obs;
  final showBackButton = false.obs;
  final showTitle = false.obs;
  final searchQuery = ''.obs;
  final title = ''.obs;

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

  void configureForMarket() {
    toggleProfile(false);
    toggleSearch(true);
    toggleSpendingCard(true);
    toggleTotalCard(false);
    toggleCoinKidsCard(false);
    toggleBackButton(false);
    toggleTitle(false);
  }

  void configureForDetail() {
    toggleProfile(false);
    toggleSearch(false);
    toggleSpendingCard(true);
    toggleBackButton(true);
    toggleTitle(true);
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
    showTitle.value = false;
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
