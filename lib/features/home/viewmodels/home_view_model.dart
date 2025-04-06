import 'package:flutter/material.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/enums/word_status_enum.dart';
import '../../../core/models/word_model.dart';
import '../../../core/repositories/abstract/word_repository.dart';
import '../../../core/services/audio/audio_service.dart';

class HomeViewModel extends BaseViewModel {
  final WordRepository _wordRepository;
  final AudioService _audioService;

  List<Word> _words = [];
  int _currentPage = 1;
  final int _limit = 10;

  HomeViewModel({
    required WordRepository wordRepository,
    required AudioService audioService,
  })  : _wordRepository = wordRepository,
        _audioService = audioService;

  List<Word> get words => _words;
  bool get isPlayingAudio => _audioService.isPlaying;

  Future<void> loadWords() async {
    setBusy(true);
    setError(null);

    try {
      final response = await _wordRepository.getWordsPaginated(
        page: _currentPage,
        limit: _limit,
      );

      if (response.success && response.data != null) {
        _words = response.data!;
        setBusy(false);
      } else {
        setError(response.message ?? 'Failed to load words');
      }
    } catch (e) {
      setError(e.toString());
      setBusy(false);
    }
  }

  Future<void> loadMoreWords() async {
    _currentPage++;
    await loadWords();
  }

  // Update word status to 'learning'
  Future<bool> setWordLearning(String wordId) async {
    return await _updateWordStatus(wordId, WordStatus.learning);
  }

  // Update word status to 'skip'
  Future<bool> setWordSkipped(String wordId) async {
    return await _updateWordStatus(wordId, WordStatus.skip);
  }

  // Update word status to 'learned'
  Future<bool> setWordLearned(String wordId) async {
    return await _updateWordStatus(wordId, WordStatus.learned);
  }

  // Generic method to update word status
  Future<bool> _updateWordStatus(String wordId, WordStatus status) async {
    try {
      final response = await _wordRepository.updateWordStatus(
        wordId: wordId,
        status: status.value,
      );

      if (response.success) {
        debugPrint('Word status updated: $wordId -> ${status.value}');
        return true;
      } else {
        debugPrint('Failed to update word status: ${response.message}');
        return false;
      }
    } catch (e) {
      debugPrint('Error updating word status: $e');
      return false;
    }
  }

  Future<void> playAudio(String? audioUrl) async {
    await _audioService.playAudio(audioUrl);
    notifyListeners();
  }

  @override
  void dispose() {
    // No need to dispose audio service as it's a singleton
    super.dispose();
  }
}
