import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/enums/word_status_enum.dart';
import '../../../core/models/word_model.dart';
import '../../../core/repositories/abstract/word_repository.dart';

class HomeViewModel extends BaseViewModel {
  final WordRepository _wordRepository;
  AudioPlayer? _audioPlayer;

  List<Word> _words = [];
  int _currentPage = 1;
  final int _limit = 10;
  bool _isPlayingAudio = false;

  HomeViewModel({
    required WordRepository wordRepository,
  }) : _wordRepository = wordRepository;

  List<Word> get words => _words;
  bool get isPlayingAudio => _isPlayingAudio;

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
    if (_isPlayingAudio || audioUrl == null || audioUrl.isEmpty) return;

    _isPlayingAudio = true;
    notifyListeners();

    try {
      debugPrint('Playing audio: $audioUrl');

      // Create a new instance each time to avoid issues
      _audioPlayer?.dispose();
      _audioPlayer = AudioPlayer();

      await _audioPlayer?.setUrl(audioUrl);
      await _audioPlayer?.play();
    } catch (e) {
      debugPrint('Error playing audio: $e');
    } finally {
      _isPlayingAudio = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    _audioPlayer = null;
    super.dispose();
  }
}
