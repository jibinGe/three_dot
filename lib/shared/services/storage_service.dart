import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final _secureStorage = FlutterSecureStorage();

  // Keys
  static const String tokenKey = 'auth_token';
  static const String rememberMeKey = 'remember_me';
  static const String userDataKey = 'user_data';

  // Token methods
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: tokenKey);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: tokenKey);
  }

  // Remember me methods
  Future<void> saveRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(rememberMeKey, value);
    debugPrint("RememberMe value saved in SharedPreferences: $value");
  }

  Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool(rememberMeKey) ?? false;
    debugPrint("RememberMe value retrieved: $rememberMe");
    return rememberMe;
  }

  // User data methods
  Future<void> saveUserData(String userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userDataKey, userData);
  }

  Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userDataKey);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
