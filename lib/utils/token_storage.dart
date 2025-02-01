import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();

  // Save a token with a given key
  static Future<void> saveToken(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      print('$key saved successfully'); // Optional: Debugging log
    } catch (e) {
      throw Exception('Error saving token: $e');
    }
  }

  
  static Future<String?> getToken(String key) async {
    try {
      final value = await _storage.read(key: key);
      if (value == null || value.isEmpty) {
        throw Exception('Token not found for key: $key');
      }
      return value;
    } catch (e) {
      throw Exception('Error retrieving token: $e');
    }
  }

  
  static Future<void> deleteToken(String key) async {
    try {
      await _storage.delete(key: key);
      print('$key deleted successfully'); // Optional: Debugging log
    } catch (e) {
      throw Exception('Error deleting token: $e');
    }
  }

  // Check if a token exists
  static Future<bool> hasToken(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null && value.isNotEmpty;
    } catch (e) {
      throw Exception('Error checking token: $e');
    }
  }
}
