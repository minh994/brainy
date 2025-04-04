abstract class StorageService {
  /// Get a value from storage by key
  Future<String?> get(String key);

  /// Save a value to storage
  Future<void> set(String key, String value);

  /// Remove a value from storage
  Future<void> remove(String key);

  /// Clear all stored values
  Future<void> clear();

  /// Check if a key exists in storage
  Future<bool> containsKey(String key);
}
