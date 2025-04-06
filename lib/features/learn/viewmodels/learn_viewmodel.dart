import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/enums/word_status_enum.dart';
import '../../../core/models/word_model.dart';
import '../../../core/repositories/abstract/word_repository.dart';
import '../../../core/services/audio/audio_service.dart';

class LearnViewModel extends BaseViewModel {
  final WordRepository _wordRepository;
  final AudioService _audioService;

  List<Word> _learningWords = [];

  LearnViewModel({
    required WordRepository wordRepository,
    required AudioService audioService,
  })  : _wordRepository = wordRepository,
        _audioService = audioService;

  List<Word> get learningWords => _learningWords;
  bool get isPlayingAudio => _audioService.isPlaying;

  Future<void> loadLearningWords() async {
    setBusy(true);
    setError(null);

    try {
      final response = await _wordRepository.getWordsByStatus(
        status: WordStatus.learning.value,
        page: 1,
        limit: 100, // Adjust based on your needs
      );

      if (response.success && response.data != null) {
        _learningWords = response.data!;
        notifyListeners();
      } else {
        setError(response.message ?? 'Failed to load learning words');
      }
    } catch (e) {
      setError(e.toString());
      if (kDebugMode) {
        print('Error loading learning words: $e');
      }
    } finally {
      setBusy(false);
    }
  }

  Future<void> playAudio(String phonetic) async {
    if (phonetic.isEmpty) return;
    await _audioService.playAudio(phonetic);
    notifyListeners();
  }

  Future<void> setWordLearned(String wordId) async {
    try {
      final response = await _wordRepository.updateWordStatus(
        wordId: wordId,
        status: WordStatus.learned.value,
      );

      if (response.success) {
        _learningWords.removeWhere((word) => word.id == wordId);
        notifyListeners();
      }
    } catch (e) {
      setError(e.toString());
      if (kDebugMode) {
        print('Error marking word as learned: $e');
      }
    }
  }

  Future<void> setWordSkipped(String wordId) async {
    try {
      final response = await _wordRepository.updateWordStatus(
        wordId: wordId,
        status: WordStatus.skip.value,
      );

      if (response.success) {
        _learningWords.removeWhere((word) => word.id == wordId);
        notifyListeners();
      }
    } catch (e) {
      setError(e.toString());
      if (kDebugMode) {
        print('Error marking word as skipped: $e');
      }
    }
  }
}
