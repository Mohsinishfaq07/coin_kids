import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguageController extends GetxController {
  // Loading state
  final RxBool isLoading = false.obs;

  // Available languages
  final List<Map<String, dynamic>> languages = [
    {'name': 'English', 'locale': const Locale('en', 'US'), 'flag': '🇺🇸'},
    {'name': 'Spanish', 'locale': const Locale('es', 'ES'), 'flag': '🇪🇸'},
    {'name': 'Arabic', 'locale': const Locale('ar', 'SA'), 'flag': '🇸🇦'},
    {'name': 'French', 'locale': const Locale('fr', 'FR'), 'flag': '🇫🇷'},
    {'name': 'German', 'locale': const Locale('de', 'DE'), 'flag': '🇩🇪'},
  ];

  // Currently selected language
  final Rx<Locale> selectedLocale = Get.locale != null
      ? Rx<Locale>(Get.locale!)
      : Rx<Locale>(const Locale('en', 'US'));

  // Key for storing language preference
  static const String languageKey = 'app_language';

  @override
  void onInit() {
    super.onInit();
    loadSavedLanguage();
  }

  // Load saved language preference
  Future<void> loadSavedLanguage() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final String? languageCode = prefs.getString(languageKey);
      final String? countryCode = prefs.getString('${languageKey}_country');

      if (languageCode != null) {
        selectedLocale.value = Locale(languageCode, countryCode ?? '');
        await updateAppLanguage(selectedLocale.value);
      }
    } catch (e) {
      debugPrint('Error loading language preference: $e');
      Get.snackbar(
        'Error',
        'Failed to load language preference',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Change app language
  Future<void> changeLanguage(Locale locale) async {
    try {
      isLoading.value = true;

      // Update selected locale
      selectedLocale.value = locale;

      // Update app locale
      await updateAppLanguage(locale);

      // Save preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(languageKey, locale.languageCode);
      await prefs.setString('${languageKey}_country', locale.countryCode ?? '');

      // Show success message

    } catch (e) {
      debugPrint('Error changing language: $e');
      Get.snackbar(
        'Error',
        'Failed to change language',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update app language
  Future<void> updateAppLanguage(Locale locale) async {
    await Get.updateLocale(locale);
  }

  // Check if a language is currently selected
  bool isSelected(Locale locale) {
    return selectedLocale.value.languageCode == locale.languageCode;
  }
}
