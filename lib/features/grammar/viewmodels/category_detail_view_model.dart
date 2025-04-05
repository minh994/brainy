import 'package:flutter/material.dart';
import '../../../core/base/base_view_model.dart';
import '../models/category_model.dart';
import '../models/lesson_model.dart';
import '../repositories/abstract/grammar_repository.dart';

class CategoryDetailViewModel extends BaseViewModel {
  final GrammarRepository _grammarRepository;

  CategoryDetailViewModel({required GrammarRepository grammarRepository})
      : _grammarRepository = grammarRepository;

  Category? _category;
  Category? get category => _category;
  List<Lesson> get lessons => _category?.lessons ?? [];

  Future<void> loadCategoryDetail(String categoryId) async {
    setBusy(true);
    setError(null);

    try {
      final response =
          await _grammarRepository.getCategoryWithLessons(categoryId);

      if (response.success && response.data != null) {
        _category = response.data;
        setBusy(false);
      } else {
        setError(response.message ?? 'Failed to load category details');
      }
    } catch (e) {
      debugPrint('Error loading category detail: $e');
      setError(e.toString());
      setBusy(false);
    }
  }
}
