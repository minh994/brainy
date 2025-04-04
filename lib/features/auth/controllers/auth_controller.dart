import 'package:flutter/foundation.dart';

import '../../../core/models/api_response.dart';
import '../../../core/models/auth_models.dart';
import '../../../core/repositories/abstract/auth_repository.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  authenticating,
  error
}

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthStatus _status = AuthStatus.initial;
  User? _currentUser;
  String? _errorMessage;

  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository {
    _checkAuthStatus();
  }

  // Getters
  AuthStatus get status => _status;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // Check if user is authenticated
  Future<void> _checkAuthStatus() async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    final isAuth = await _authRepository.isAuthenticated();
    if (isAuth) {
      final user = await _authRepository.getUser();
      if (user != null) {
        _currentUser = user;
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } else {
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  // Login with email and password
  Future<bool> login(String username, String password) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    final request = LoginRequest(username: username, password: password);
    final response = await _authRepository.login(request);

    return _handleAuthResponse(response);
  }

  // Register a new user
  Future<bool> register(
      String username, String email, String password, String fullName) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    final request = RegisterRequest(
      username: username,
      email: email,
      password: password,
      fullName: fullName,
    );

    final response = await _authRepository.register(request);

    return _handleAuthResponse(response);
  }

  // Logout
  Future<bool> logout() async {
    final token = await _authRepository.getToken();
    if (token != null) {
      await _authRepository.logout(token.refreshToken);
    }

    await _authRepository.clearAuthData();
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();

    return true;
  }

  // Handle auth response
  bool _handleAuthResponse(ApiResponse<AuthResponse> response) {
    if (response.success && response.data != null) {
      _currentUser = response.data!.user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.message;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Google login
  Future<bool> googleLogin(String idToken) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    // This would use the auth repository's googleLogin method
    // For now, we'll just return false
    return false;
  }

  // Facebook login
  Future<bool> facebookLogin(String accessToken) async {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    // This would use the auth repository's facebookLogin method
    // For now, we'll just return false
    return false;
  }
}
