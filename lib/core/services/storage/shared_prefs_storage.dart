import 'package:shared_preferences/shared_preferences.dart';
import 'storage_service.dart';
import 'package:flutter/foundation.dart' show debugPrint;

class SharedPrefsStorage implements StorageService {
  late SharedPreferences _prefs;
  bool _initialized = false;

  /// Initialize shared preferences
  Future<void> init() async {
    if (!_initialized) {
      debugPrint('SharedPrefsStorage: Initializing SharedPreferences');
      try {
        _prefs = await SharedPreferences.getInstance();
        _initialized = true;
        debugPrint('SharedPrefsStorage: Successfully initialized');
      } catch (e) {
        debugPrint('SharedPrefsStorage: Error initializing: $e');
        rethrow;
      }
    }
  }

  @override
  Future<String?> get(String key) async {
    await _ensureInitialized();
    return _prefs.getString(key);
  }

  @override
  Future<void> set(String key, String value) async {
    await _ensureInitialized();
    await _prefs.setString(key, value);
  }

  @override
  Future<void> remove(String key) async {
    await _ensureInitialized();
    await _prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    await _ensureInitialized();
    await _prefs.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    await _ensureInitialized();
    return _prefs.containsKey(key);
  }

  /// Ensure shared preferences is initialized before use
  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      debugPrint('SharedPrefsStorage: Auto-initializing in _ensureInitialized');
      await init();
    }
  }
}
