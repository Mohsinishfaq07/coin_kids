import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _preferences;

  static String isEverLoggedIn = "isEverLoggedIn";
  static String lastLoggedInRole = "lastLoggedInRole";
  static String isKidOnboarded = "isKidOnboarded";
  static String hasShownKidsZoneShowcase = "hasShownKidsZoneShowcase";
  static String goalAchievementNotificationEnabled = "hasShownKidsZoneShowcase";
  static String moneyRequestNotificationEnabled = "hasShownKidsZoneShowcase";
  // static String goalAchievementNotificationEnabled =
  //       "goalAchievementNotificationEnabled";
  //   static String moneyRequestNotificationEnabled =
  //       "moneyRequestNotificationEnabled";
  static String showcaseMoneyJarKey = "showcaseMoneyJarKey";
  static String showKidsNotifications = "showKidsNotifications";
  static String showTotalMoneySpotlight = "showTotalMoneySpotlight";

  // Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Save a string value
  static Future<void> saveString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  // Get a string value
  static String? getString(String key) {
    return _preferences?.getString(key);
  }

  // Save an integer value
  static Future<void> saveInt(String key, int value) async {
    await _preferences?.setInt(key, value);
  }

  // Get an integer value
  static int? getInt(String key) {
    return _preferences?.getInt(key);
  }

  // Save a boolean value
  static Future<void> saveBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  // Get a boolean value
  static bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  // Remove a value
  static Future<void> remove(String key) async {
    await _preferences?.remove(key);
  }

  // Clear all values
  static Future<void> clear() async {
    await _preferences?.clear();
  }
}
