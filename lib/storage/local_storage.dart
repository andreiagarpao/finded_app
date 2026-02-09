import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // ADD THIS IMPORT

class LocalStorageService {
  static SharedPreferences? _prefs;

  // Initialize
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save data
  static Future<bool> saveString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  static Future<bool> saveBool(String key, bool value) async {
    return await _prefs?.setBool(key, value) ?? false;
  }

  // NEW: Save list of strings (for inquiries as JSON)
  static Future<bool> saveStringList(String key, List<String> value) async {
    return await _prefs?.setStringList(key, value) ?? false;
  }

  // Retrieve data
  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  // NEW: Get list of strings
  static List<String>? getStringList(String key) {
    return _prefs?.getStringList(key);
  }

  // Remove data
  static Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }

  // Clear all
  static Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }

  // NEW: Clear only auth data (keep inquiries)
  static Future<void> clearAuthData() async {
    await remove('isLoggedIn');
    await remove('username');
    await remove('userId');
    await remove('isAdmin');
    await remove('selectedSchool');
    // Don't remove 'inquiries' key - this keeps the data
  }
}