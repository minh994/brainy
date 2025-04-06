import 'package:flutter/material.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/models/api_response.dart';
import '../models/category_model.dart';
import '../../../core/repositories/abstract/grammar_repository.dart';

class GrammarListViewModel extends BaseViewModel {
  final GrammarRepository _grammarRepository;

  GrammarListViewModel({required GrammarRepository grammarRepository})
      : _grammarRepository = grammarRepository;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  Future<void> loadCategories() async {
    setBusy(true);
    setError(null);

    try {
      final ApiResponse<List<Category>> response =
          await _grammarRepository.getCategories();

      if (response.success && response.data != null) {
        _categories = response.data!;
        setBusy(false);
      } else {
        setError(response.message ?? 'Failed to load grammar categories');
      }
    } catch (e) {
      debugPrint('Error loading grammar categories: $e');
      setError(e.toString());
      setBusy(false);
    }
  }
}
