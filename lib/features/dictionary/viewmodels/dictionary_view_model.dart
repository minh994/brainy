import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/enums/word_status_enum.dart';
import '../../../core/models/word_model.dart';
import '../../../core/repositories/abstract/word_repository.dart';

class DictionaryViewModel extends BaseViewModel {
  final WordRepository _wordRepository;

  DictionaryViewModel({required WordRepository wordRepository})
      : _wordRepository = wordRepository;

  // Current filter status
  WordStatus _activeStatus = WordStatus.all;
  WordStatus get activeStatus => _activeStatus;

  // Status counts
  final Map<WordStatus, int> _statusCounts = {};
  Map<WordStatus, int> get statusCounts => _statusCounts;

  // Pagination controllers for each status
  late final PagingController<int, Word> allWordsPagingController =
      PagingController<int, Word>(
    getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
    fetchPage: _fetchAllWordsPage,
  );

  late final PagingController<int, Word> learningWordsPagingController =
      PagingController<int, Word>(
    getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
    fetchPage: (pageKey) => _fetchStatusWordsPage(pageKey, WordStatus.learning),
  );

  late final PagingController<int, Word> learnedWordsPagingController =
      PagingController<int, Word>(
    getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
    fetchPage: (pageKey) => _fetchStatusWordsPage(pageKey, WordStatus.learned),
  );

  late final PagingController<int, Word> skippedWordsPagingController =
      PagingController<int, Word>(
    getNextPageKey: (state) => (state.keys?.last ?? 0) + 1,
    fetchPage: (pageKey) => _fetchStatusWordsPage(pageKey, WordStatus.skip),
  );

  // Search query
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // Audio playback status
  bool _isPlayingAudio = false;
  bool get isPlayingAudio => _isPlayingAudio;

  // Constants
  static const int _pageSize = 10;

  @override
  void dispose() {
    allWordsPagingController.dispose();
    learningWordsPagingController.dispose();
    learnedWordsPagingController.dispose();
    skippedWordsPagingController.dispose();
    super.dispose();
  }

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

  Color getPosColor(String pos) {
    return _posColors[pos.toLowerCase()] ?? Colors.grey;
  }

  // Initialize pagination controllers and load initial data
  Future<void> loadWords() async {
    setBusy(true);

    try {
      // Load status counts
      await _loadStatusCounts();

      setBusy(false);
    } catch (e) {
      setError(e.toString());
      setBusy(false);
    }
  }

  // Load counts for all statuses
  Future<void> _loadStatusCounts() async {
    try {
      // All words count
      final allWordsResponse =
          await _wordRepository.getWordsPaginated(page: 1, limit: 10);
      if (allWordsResponse.success && allWordsResponse.totalCount != null) {
        _statusCounts[WordStatus.all] = allWordsResponse.totalCount!;
      }

      // Learning words count
      final learningWordsResponse = await _wordRepository.getWordsByStatus(
          status: WordStatus.learning.value, page: 1, limit: 10);
      if (learningWordsResponse.success &&
          learningWordsResponse.totalCount != null) {
        _statusCounts[WordStatus.learning] = learningWordsResponse.totalCount!;
      }

      // Learned words count
      final learnedWordsResponse = await _wordRepository.getWordsByStatus(
          status: WordStatus.learned.value, page: 1, limit: 10);
      if (learnedWordsResponse.success &&
          learnedWordsResponse.totalCount != null) {
        _statusCounts[WordStatus.learned] = learnedWordsResponse.totalCount!;
      }

      // Skipped words count
      final skippedWordsResponse = await _wordRepository.getWordsByStatus(
          status: WordStatus.skip.value, page: 1, limit: 10);
      if (skippedWordsResponse.success &&
          skippedWordsResponse.totalCount != null) {
        _statusCounts[WordStatus.skip] = skippedWordsResponse.totalCount!;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading status counts: $e');
    }
  }

  // Fetch a page of words for All status
  Future<List<Word>> _fetchAllWordsPage(int pageKey) async {
    try {
      final response = await _wordRepository.getWordsPaginated(
          page: pageKey, limit: _pageSize);

      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw Exception(response.message ?? 'Failed to load words');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Fetch a page of words for a specific status
  Future<List<Word>> _fetchStatusWordsPage(
      int pageKey, WordStatus status) async {
    try {
      final response = await _wordRepository.getWordsByStatus(
          status: status.value, page: pageKey, limit: _pageSize);

      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw Exception(response.message ?? 'Failed to load words');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Helper to get the appropriate controller for a status
  PagingController<int, Word> _getPagingControllerForStatus(WordStatus status) {
    switch (status) {
      case WordStatus.all:
        return allWordsPagingController;
      case WordStatus.learning:
        return learningWordsPagingController;
      case WordStatus.learned:
        return learnedWordsPagingController;
      case WordStatus.skip:
        return skippedWordsPagingController;
    }
  }

  // Get the current paging controller based on active status
  PagingController<int, Word> get currentPagingController =>
      _getPagingControllerForStatus(_activeStatus);

  // Set active filter status
  void setActiveStatus(WordStatus status) {
    if (_activeStatus != status) {
      _activeStatus = status;
      notifyListeners();
    }
  }

  // Search words
  void searchWords(String query) {
    _searchQuery = query;

    // Reset all pagination controllers
    allWordsPagingController.refresh();
    learningWordsPagingController.refresh();
    learnedWordsPagingController.refresh();
    skippedWordsPagingController.refresh();

    notifyListeners();
  }

  // Audio playback indicator
  void setPlayingAudio(bool isPlaying) {
    _isPlayingAudio = isPlaying;
    notifyListeners();
  }

  // Play audio
  Future<void> playAudio(String audioUrl) async {
    if (audioUrl.isEmpty) return;

    setPlayingAudio(true);

    // Audio playback logic would go here

    // Simulate audio playback completion after 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    setPlayingAudio(false);
  }
}
