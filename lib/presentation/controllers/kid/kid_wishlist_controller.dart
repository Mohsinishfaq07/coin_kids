import 'package:coin_kids/data/models/wishlist_model.dart';
import 'package:coin_kids/data/remote_services/wishlist_service.dart';
import 'package:coin_kids/presentation/controllers/common/app_state_controller.dart';
import 'package:coin_kids/presentation/controllers/kid/kid_appbar_controller.dart';
import 'package:get/get.dart';

class KidWishlistController extends GetxController {
  final WishlistService _wishlistService = Get.find<WishlistService>();
  final AppStateController _appState = Get.find();
  final KidAppBarController appBarController = Get.find<KidAppBarController>();

  final RxList<WishlistModel> wishlistItems = <WishlistModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();

    fetchWishlist();
  }

  @override
  void onReady() {
    appBarController.configureForWishlist();
    super.onReady();
  }

  Future<void> fetchWishlist() async {
    isLoading.value = true;
    error.value = '';

    try {
      final kid = _appState.currentKid.value;
      if (kid == null) throw Exception('Child not found');

      final items = await _wishlistService.fetchWishlist(kid.kidId);
      wishlistItems.value = items;
    } catch (e) {
      error.value = 'Failed to load wishlist items';
      Get.log(e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      await _wishlistService.removeFromWishlist(productId);
      wishlistItems.removeWhere((item) => item.productId == productId);
    } catch (e) {
      Get.log('Failed to remove item from wishlist: $e');
    }
  }
}
