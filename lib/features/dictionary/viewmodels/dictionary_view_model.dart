import 'package:flutter/material.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/enums/word_status_enum.dart';
import '../../../core/models/word_model.dart';
import '../../../core/repositories/abstract/word_repository.dart';

class DictionaryViewModel extends BaseViewModel {
  final WordRepository _wordRepository;

  List<Word> _words = [];
  List<Word> _filteredWords = [];
  String _query = '';
  WordStatus _activeStatus = WordStatus.all;

  // Status counts - these will be populated from API
  final Map<WordStatus, int> _statusCounts = {
    WordStatus.all: 0,
    WordStatus.learning: 0,
    WordStatus.learned: 0,
    WordStatus.skip: 0,
  };

  // Color mapping for parts of speech
  final Map<String, Color> _posColors = {
    // Full words
    'noun': Colors.purple,
    'verb': Colors.blue,
    'adjective': Colors.green,
    'adverb': Colors.amber,
    'preposition': Colors.orange,
    'conjunction': Colors.red,
    'pronoun': Colors.teal,
    'determiner': Colors.brown,
    'interjection': Colors.deepPurple,

    // Abbreviations for backward compatibility
    'n': Colors.purple,
    'v': Colors.blue,
    'adj': Colors.green,
    'adv': Colors.amber,
    'prep': Colors.orange,
    'conj': Colors.red,
    'pron': Colors.teal,
    'det': Colors.brown,
    'interj': Colors.deepPurple,
  };

  DictionaryViewModel({
    required WordRepository wordRepository,
  }) : _wordRepository = wordRepository;

  List<Word> get words => _words;
  List<Word> get filteredWords => _filteredWords;
  WordStatus get activeStatus => _activeStatus;
  Map<WordStatus, int> get statusCounts => _statusCounts;

  // Get color for part of speech
  Color getPosColor(String pos) {
    // First try direct match with the lowercase pos
    final normalizedPos = pos.toLowerCase().trim();
    if (_posColors.containsKey(normalizedPos)) {
      return _posColors[normalizedPos]!;
    }

    // Then try matching only the first part (e.g., "noun (plural)" → "noun")
    final firstPart = normalizedPos.split(' ').first.split('.').first;
    if (_posColors.containsKey(firstPart)) {
      return _posColors[firstPart]!;
    }

    // Default color if no match
    return Colors.grey;
  }

  // Get a user-friendly display name for the part of speech
  String getPosDisplayName(String pos) {
    // Already lowercase and looks good, use as is
    return pos.toLowerCase().trim();
  }

  Future<void> loadWords() async {
    setBusy(true);
    setError(null);

    try {
      // First load all words to get the total count
      final response = await _wordRepository.getWords();

      if (response.success && response.data != null) {
        _words = response.data!;
        _statusCounts[WordStatus.all] = _words.length;

        // Then load status counts
        await _loadStatusCounts();

        // Then apply filters based on active status
        await _loadWordsByStatus();

        setBusy(false);
      } else {
        setError(response.message ?? 'Failed to load words');
        setBusy(false);
      }
    } catch (e) {
      setError(e.toString());
      setBusy(false);
    }
  }

  Future<void> _loadStatusCounts() async {
    try {
      // Learning status count
      final learningResponse = await _wordRepository.getWordsByStatus(
        status: WordStatus.learning.value,
        limit: 1,
      );
      if (learningResponse.success) {
        _statusCounts[WordStatus.learning] = learningResponse.totalCount ?? 0;
        debugPrint('Learning count: ${learningResponse.totalCount ?? 0}');
      } else {
        debugPrint('Error getting learning count: ${learningResponse.message}');
      }

      // Mastered status count
      final masteredResponse = await _wordRepository.getWordsByStatus(
        status: WordStatus.learned.value,
        limit: 1,
      );
      if (masteredResponse.success) {
        _statusCounts[WordStatus.learned] = masteredResponse.totalCount ?? 0;
        debugPrint('Mastered count: ${masteredResponse.totalCount ?? 0}');
      } else {
        debugPrint('Error getting mastered count: ${masteredResponse.message}');
      }

      // Skipped status count
      final skippedResponse = await _wordRepository.getWordsByStatus(
        status: WordStatus.skip.value,
        limit: 1,
      );
      if (skippedResponse.success) {
        _statusCounts[WordStatus.skip] = skippedResponse.totalCount ?? 0;
        debugPrint('Skipped count: ${skippedResponse.totalCount ?? 0}');
      } else {
        debugPrint('Error getting skipped count: ${skippedResponse.message}');
      }

      notifyListeners();
    } catch (e) {
      // Just log the error but don't stop the main flow
      debugPrint('Error loading status counts: $e');
    }
  }

  void searchWords(String query) {
    _query = query.toLowerCase().trim();
    _applySearchFilter();
  }

  Future<void> setActiveStatus(WordStatus status) async {
    if (_activeStatus == status) return;

    _activeStatus = status;
    await _loadWordsByStatus();
  }

  Future<void> _loadWordsByStatus() async {
    setBusy(true);

    try {
      if (_activeStatus == WordStatus.all) {
        // For "All" status, use the main words list
        final response = await _wordRepository.getWords();
        if (response.success && response.data != null) {
          _words = response.data!;
          _applySearchFilter();
        }
      } else {
        // For specific status, call the status-filtered endpoint
        final response = await _wordRepository.getWordsByStatus(
          status: _activeStatus.value,
          page: 1,
          limit: 50, // Adjust based on your needs
        );

        if (response.success && response.data != null) {
          _words = response.data!;
          _applySearchFilter();
        }
      }
    } catch (e) {
      setError('Error loading words: $e');
    } finally {
      setBusy(false);
    }
  }

  void _applySearchFilter() {
    if (_query.isEmpty) {
      _filteredWords = _words;
    } else {
      _filteredWords = _words
          .where((word) =>
              word.word.toLowerCase().contains(_query) ||
              (word.senses.isNotEmpty &&
                  word.senses.first.definition.toLowerCase().contains(_query)))
          .toList();
    }

    notifyListeners();
  }
}
