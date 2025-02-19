import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteController extends GetxController {
  RxList<Map<String, dynamic>> favoriteList = <Map<String, dynamic>>[].obs;

  final String _favoriteKey = "favorites";

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedFavorites = prefs.getString(_favoriteKey);
    if (storedFavorites != null) {
      List<dynamic> decodedList = jsonDecode(storedFavorites);
      favoriteList.value = decodedList.cast<Map<String, dynamic>>();
    }
  }

  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_favoriteKey, jsonEncode(favoriteList));

    Get.log('saved items: ${jsonEncode(favoriteList)}');
  }

  bool isFavorite(Map<String, dynamic> item) {
    return favoriteList.any((element) => mapEquals(element, item));
  }

  Future<void> addFavorite(Map<String, dynamic> item) async {
    if (!isFavorite(item)) {
      favoriteList.add(item);
      await _saveFavorites();
    } else {
      Get.log('item is already in favorite');
    }
  }

  Future<void> removeFavorite(Map<String, dynamic> item) async {
    favoriteList.removeWhere((element) => mapEquals(element, item));
    await _saveFavorites();
  }

  bool mapEquals(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    return const MapEquality().equals(map1, map2);
  }
}
