import 'package:flutter/material.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/models/word_model.dart';
import '../../../core/repositories/abstract/word_repository.dart';

class DictionaryViewModel extends BaseViewModel {
  final WordRepository _wordRepository;

  List<Word> _words = [];
  List<Word> _filteredWords = [];
  String _query = '';
  String _activeFilter = 'New'; // Default filter

  // Status counts
  int newCount = 4261;
  int learnedCount = 523;
  int learningCount = 126;
  int skippedCount = 0;

  DictionaryViewModel({
    required WordRepository wordRepository,
  }) : _wordRepository = wordRepository;

  List<Word> get words => _words;
  List<Word> get filteredWords => _filteredWords;
  String get activeFilter => _activeFilter;

  Future<void> loadWords() async {
    setBusy(true);
    setError(null);

    try {
      final response = await _wordRepository.getWords();

      if (response.success && response.data != null) {
        _words = response.data!;
        _applyFilters();
        setBusy(false);
      } else {
        setError(response.message ?? 'Failed to load words');
      }
    } catch (e) {
      setError(e.toString());
      setBusy(false);
    }
  }

  void searchWords(String query) {
    _query = query.toLowerCase().trim();
    _applyFilters();
  }

  void setActiveFilter(String filter) {
    _activeFilter = filter;
    _applyFilters();
  }

  void _applyFilters() {
    // Start with all words
    var filtered = _words;

    // Apply search query if not empty
    if (_query.isNotEmpty) {
      filtered = filtered
          .where((word) =>
              word.word.toLowerCase().contains(_query) ||
              (word.senses.isNotEmpty &&
                  word.senses.first.definition.toLowerCase().contains(_query)))
          .toList();
    }

    // Apply status filter
    if (_activeFilter.isNotEmpty) {
      // This is simplified - in a real app, words would have a status field
      // For demo, we're using a basic approach for filtering
      if (_activeFilter != 'All') {
        filtered = filtered
            .where((word) => getWordStatus(word) == _activeFilter)
            .toList();
      }
    }

    _filteredWords = filtered;
    notifyListeners();
  }

  String getWordStatus(Word word) {
    // In a real app, this would come from the word model
    // For this demo, we'll use a simple deterministic approach
    final wordHash = word.word.length + word.word.codeUnitAt(0);

    // Distribute words across statuses based on a simple hash
    if (wordHash % 10 < 3) {
      return 'Learning';
    } else if (wordHash % 10 < 5) {
      return 'Learned';
    } else if (wordHash % 10 < 6) {
      return 'Skipped';
    } else {
      return 'New';
    }
  }
}
