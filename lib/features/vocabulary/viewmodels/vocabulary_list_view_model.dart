import '../../../core/base/base_view_model.dart';

class VocabularyListViewModel extends BaseViewModel {
  // Placeholder for future implementation

  void fetchVocabularyList() {
    // This will be implemented when we connect to the real API
    setBusy(true);
    // Simulating API call
    Future.delayed(const Duration(seconds: 1), () {
      setBusy(false);
    });
  }
}
