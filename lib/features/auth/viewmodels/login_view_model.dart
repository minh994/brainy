import '../../../core/base/base_view_model.dart';
import '../../../core/models/auth_models.dart';
import '../../../core/repositories/abstract/auth_repository.dart';
import '../../../core/routes/app_router.dart';

class LoginViewModel extends BaseViewModel {
  final AuthRepository _authRepository;

  LoginViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository;

  /// Login with username and password
  Future<bool> login(String username, String password) async {
    clearError();
    setBusy(true);

    try {
      final request = LoginRequest(username: username, password: password);
      final response = await _authRepository.login(request);

      if (!response.success) {
        setError(response.message);
        return false;
      }

      return true;
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setBusy(false);
    }
  }

  /// Login with Google
  Future<bool> loginWithGoogle() async {
    // This would be implemented when we have GoogleSignIn integration
    setError('Google login is not implemented yet');
    return false;
  }

  /// Login with Facebook
  Future<bool> loginWithFacebook() async {
    // This would be implemented when we have FacebookLogin integration
    setError('Facebook login is not implemented yet');
    return false;
  }

  /// Navigate to signup page
  String getSignupRoute() {
    return AppRouter.signup;
  }
}
