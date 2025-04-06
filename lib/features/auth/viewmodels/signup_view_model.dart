import '../../../core/base/base_view_model.dart';
import '../../../core/repositories/abstract/auth_repository.dart';
import '../../../core/models/auth_models.dart';

class SignupViewModel extends BaseViewModel {
  final AuthRepository _authRepository;

  SignupViewModel({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  /// Register a new user
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    setBusy(true);
    setError(null);

    try {
      final request = RegisterRequest(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
      );

      final response = await _authRepository.register(request);

      if (response.success && response.data != null) {
        // The signup endpoint doesn't return tokens, so we can't authenticate yet
        // We'll just indicate success so the UI can redirect to login
        return true;
      } else {
        setError(response.message);
        return false;
      }
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setBusy(false);
    }
  }
}
