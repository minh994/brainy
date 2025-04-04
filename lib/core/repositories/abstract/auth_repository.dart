import '../../models/api_response.dart';
import '../../models/auth_models.dart';

abstract class AuthRepository {
  /// Register a new user
  Future<ApiResponse<AuthResponse>> register(RegisterRequest request);

  /// Login a user with username and password
  Future<ApiResponse<AuthResponse>> login(LoginRequest request);

  /// Logout the current user
  Future<ApiResponse<void>> logout(String refreshToken);

  /// Refresh the access token using a refresh token
  Future<ApiResponse<AuthToken>> refreshToken(String refreshToken);

  /// Get the current authentication status
  Future<bool> isAuthenticated();

  /// Get the current user's token
  Future<AuthToken?> getToken();

  /// Save token to persistent storage
  Future<void> saveToken(AuthToken token);

  /// Save user data to persistent storage
  Future<void> saveUser(User user);

  /// Get the current user from persistent storage
  Future<User?> getUser();

  /// Clear all authentication data
  Future<void> clearAuthData();
}
