import '../../models/api_response.dart';
import '../../models/auth_models.dart';
import '../../models/word_models.dart';

abstract class UserRepository {
  /// Get all users
  Future<ApiResponse<List<User>>> getAllUsers();

  /// Get a user by ID
  Future<ApiResponse<User>> getUserById(String userId);

  /// Create a new user
  Future<ApiResponse<User>> createUser(RegisterRequest request);

  /// Update a user
  Future<ApiResponse<User>> updateUser(
      String userId, Map<String, dynamic> data);

  /// Delete a user
  Future<ApiResponse<void>> deleteUser(String userId);

  /// Get user progress
  Future<ApiResponse<List<Progress>>> getUserProgress(String userId);

  /// Update user progress
  Future<ApiResponse<bool>> updateUserProgress(
    String userId,
    String wordId,
    Map<String, dynamic> data,
  );

  /// Delete user progress
  Future<ApiResponse<void>> deleteUserProgress(String userId, String wordId);

  /// Get user notes
  Future<ApiResponse<List<Note>>> getUserNotes(String userId);

  /// Save user note
  Future<ApiResponse<bool>> saveUserNote(
    String userId,
    String wordId,
    String note,
  );

  /// Delete user note
  Future<ApiResponse<void>> deleteUserNote(String userId, String wordId);
}
