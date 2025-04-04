import 'package:flutter/material.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/models/word_model.dart';
import '../../../core/repositories/abstract/word_repository.dart';

class HomeViewModel extends BaseViewModel {
  final WordRepository _wordRepository;

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

  Future<void> playAudio() async {
    if (_isPlayingAudio) return;

    _isPlayingAudio = true;
    notifyListeners();

    try {
      // Simulate audio playback
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      setError('Error playing audio: ${e.toString()}');
    } finally {
      _isPlayingAudio = false;
      notifyListeners();
    }
  }
}
