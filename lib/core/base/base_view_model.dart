import 'package:flutter/foundation.dart';

/// A base class for all view models.
///
/// This class provides common functionality for view models,
/// such as loading state, error handling, and disposal.
abstract class BaseViewModel extends ChangeNotifier {
  bool _isBusy = false;
  bool _isDisposed = false;
  String? _errorMessage;

  /// Whether the view model is currently busy (e.g., loading data).
  bool get isBusy => _isBusy;

  /// Whether the view model has an error.
  bool get hasError => _errorMessage != null;

  /// The error message, if any.
  String? get errorMessage => _errorMessage;

  /// Sets the busy state and notifies listeners.
  ///
  /// This method is used to indicate that the view model is performing
  /// an operation and the UI should show a loading indicator.
  @protected
  void setBusy(bool value) {
    if (_isDisposed) return;
    _isBusy = value;
    notifyListeners();
  }

  /// Sets an error message and notifies listeners.
  ///
  /// This method is used to indicate that an error occurred and the UI
  /// should show an error message.
  @protected
  void setError(String? message) {
    if (_isDisposed) return;
    _errorMessage = message;
    notifyListeners();
  }

  /// Clears the error message and notifies listeners.
  @protected
  void clearError() {
    if (_isDisposed) return;
    _errorMessage = null;
    notifyListeners();
  }

  /// Runs the provided future and handles busy state and errors.
  ///
  /// This method is used to wrap asynchronous operations and
  /// automatically handle the busy state and error handling.
  Future<T?> runBusyFuture<T>(Future<T> future,
      {bool catchErrors = true}) async {
    setBusy(true);
    clearError();

    try {
      final result = await future;
      return result;
    } catch (e) {
      if (catchErrors) {
        setError(e.toString());
        return null;
      } else {
        rethrow;
      }
    } finally {
      setBusy(false);
    }
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
