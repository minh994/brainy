import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Lớp quản lý cấu hình từ file .env
class EnvConfig {
  // Singleton instance
  static final EnvConfig _instance = EnvConfig._internal();

  // Factory constructor
  factory EnvConfig() => _instance;

  // Private constructor
  EnvConfig._internal();

  /// Khởi tạo cấu hình, load file .env
  Future<void> initialize() async {
    try {
      await dotenv.load();
      debugPrint('EnvConfig: .env file loaded successfully');
    } catch (e) {
      debugPrint('EnvConfig: Error loading .env file - $e');
    }
  }

  /// Lấy giá trị từ .env theo key
  String get(String key, {String defaultValue = ''}) {
    try {
      return dotenv.env[key] ?? defaultValue;
    } catch (e) {
      debugPrint('EnvConfig: Error getting value for key $key - $e');
      return defaultValue;
    }
  }

  /// Lấy giá trị boolean từ .env theo key
  bool getBool(String key, {bool defaultValue = false}) {
    try {
      final value = dotenv.env[key]?.toLowerCase();
      if (value == null) return defaultValue;
      return value == 'true' || value == '1' || value == 'yes';
    } catch (e) {
      debugPrint('EnvConfig: Error getting boolean value for key $key - $e');
      return defaultValue;
    }
  }

  /// Lấy giá trị int từ .env theo key
  int getInt(String key, {int defaultValue = 0}) {
    try {
      final value = dotenv.env[key];
      if (value == null) return defaultValue;
      return int.tryParse(value) ?? defaultValue;
    } catch (e) {
      debugPrint('EnvConfig: Error getting int value for key $key - $e');
      return defaultValue;
    }
  }

  // API configuration
  String get apiBaseUrl =>
      get('API_BASE_URL', defaultValue: 'http://localhost/api');
  int get apiTimeout => getInt('API_TIMEOUT', defaultValue: 30000);

  // Authentication
  String get authTokenKey => get('AUTH_TOKEN_KEY', defaultValue: 'auth_token');
  String get refreshTokenKey =>
      get('REFRESH_TOKEN_KEY', defaultValue: 'refresh_token');

  // Application settings
  String get appName => get('APP_NAME', defaultValue: 'Brainy');
  String get appVersion => get('APP_VERSION', defaultValue: '1.0.0');
  String get appEnv => get('APP_ENV', defaultValue: 'development');

  // Feature flags
  bool get enableAnalytics => getBool('ENABLE_ANALYTICS', defaultValue: false);
  bool get enableCrashReporting =>
      getBool('ENABLE_CRASH_REPORTING', defaultValue: false);
  bool get enablePushNotifications =>
      getBool('ENABLE_PUSH_NOTIFICATIONS', defaultValue: false);
}
