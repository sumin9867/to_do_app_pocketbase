// lib/core/utils/token_storage.dart

import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalStorage {
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id'; // New key for user ID

  // Save the token in shared preferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Retrieve the token from shared preferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Remove the token from shared preferences
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // Save the user ID in shared preferences
  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId); // Save the user ID
  }

  // Retrieve the user ID from shared preferences
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey); // Retrieve the user ID
  }

  // Remove the user ID from shared preferences
  Future<void> clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey); // Remove the user ID
  }
}
