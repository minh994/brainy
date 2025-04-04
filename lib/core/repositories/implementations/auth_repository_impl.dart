import 'dart:convert';

import '../../models/api_response.dart';
import '../../models/auth_models.dart';
import '../../services/http/brainy_api_client.dart';
import '../../services/storage/storage_service.dart';
import '../abstract/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final BrainyApiClient apiClient;
  final StorageService storageService;

  AuthRepositoryImpl({
    required this.apiClient,
    required this.storageService,
  });

  @override
  Future<ApiResponse<AuthResponse>> login(LoginRequest request) async {
    final response = await apiClient.post<AuthResponse>(
      '/auth/login',
      request.toJson(),
      (json) => AuthResponse.fromJson(json),
      requiresAuth: false,
    );

    if (response.success && response.data != null) {
      await saveUser(response.data!.user);
      await saveToken(response.data!.token);
    }

    return response;
  }

  @override
  Future<ApiResponse<AuthResponse>> register(RegisterRequest request) async {
    final response = await apiClient.post<AuthResponse>(
      '/auth/register',
      request.toJson(),
      (json) => AuthResponse.fromJson(json),
      requiresAuth: false,
    );

    if (response.success && response.data != null) {
      await saveUser(response.data!.user);
      await saveToken(response.data!.token);
    }

    return response;
  }

  @override
  Future<ApiResponse<void>> logout(String refreshToken) async {
    try {
      // Call logout endpoint if needed
      // await apiClient.post('/auth/logout', {'refresh_token': refreshToken}, (json) => null);

      // Clear local storage
      await clearAuthData();

      return ApiResponse.success(data: null);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  @override
  Future<ApiResponse<AuthToken>> refreshToken(String refreshToken) async {
    try {
      final response = await apiClient.post<Map<String, dynamic>>(
        '/auth/refresh',
        {'refresh_token': refreshToken},
        (json) => json,
        requiresAuth: false,
      );

      if (response.success && response.data != null) {
        final token = AuthToken(
          accessToken: response.data!['access_token'] ?? '',
          refreshToken: response.data!['refresh_token'] ?? '',
          expiresIn: response.data!['expires_in'] ?? 0,
        );
        await saveToken(token);
        return ApiResponse.success(data: token);
      }

      return ApiResponse.error(message: response.message);
    } catch (e) {
      return ApiResponse.error(message: e.toString());
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  @override
  Future<AuthToken?> getToken() async {
    final tokenJson = await storageService.get('auth_token');
    if (tokenJson != null) {
      try {
        return AuthToken.fromJson(json.decode(tokenJson));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<User?> getUser() async {
    final userJson = await storageService.get('current_user');
    if (userJson != null) {
      try {
        return User.fromJson(json.decode(userJson));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> saveToken(AuthToken token) async {
    await storageService.set('auth_token', json.encode(token.toJson()));
  }

  @override
  Future<void> saveUser(User user) async {
    await storageService.set('current_user', json.encode(user.toJson()));
  }

  @override
  Future<void> clearAuthData() async {
    await storageService.remove('current_user');
    await storageService.remove('auth_token');
  }

  // Additional methods for social login
  Future<ApiResponse<AuthResponse>> googleLogin(String idToken) async {
    final response = await apiClient.post<AuthResponse>(
      '/auth/google',
      {'id_token': idToken},
      (json) => AuthResponse.fromJson(json),
      requiresAuth: false,
    );

    if (response.success && response.data != null) {
      await saveUser(response.data!.user);
      await saveToken(response.data!.token);
    }

    return response;
  }

  Future<ApiResponse<AuthResponse>> facebookLogin(String accessToken) async {
    final response = await apiClient.post<AuthResponse>(
      '/auth/facebook',
      {'access_token': accessToken},
      (json) => AuthResponse.fromJson(json),
      requiresAuth: false,
    );

    if (response.success && response.data != null) {
      await saveUser(response.data!.user);
      await saveToken(response.data!.token);
    }

    return response;
  }
}
