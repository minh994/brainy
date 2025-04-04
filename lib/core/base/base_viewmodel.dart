import 'package:flutter/material.dart';

enum ViewState { idle, busy, error }

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  String _errorMessage = '';

  ViewState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isBusy => _state == ViewState.busy;
  bool get isIdle => _state == ViewState.idle;
  bool get isError => _state == ViewState.error;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  void setError(String message) {
    _errorMessage = message;
    _state = ViewState.error;
    notifyListeners();
  }

  Future<T> runBusyFuture<T>(Future<T> future) async {
    try {
      setState(ViewState.busy);
      final result = await future;
      setState(ViewState.idle);
      return result;
    } catch (e) {
      setError(e.toString());
      rethrow;
    }
  }
}
