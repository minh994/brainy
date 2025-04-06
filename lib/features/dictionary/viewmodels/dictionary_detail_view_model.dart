import 'package:flutter/material.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/enums/word_status_enum.dart';
import '../../../core/models/word_model.dart';
import '../../../core/repositories/abstract/word_repository.dart';
import '../../../core/services/audio/audio_service.dart';

class DictionaryDetailViewModel extends BaseViewModel {
  final WordRepository _wordRepository;
  final AudioService _audioService;
  final Word _word;
  bool _isPremium = false;
  bool _isMastered = false;

  DictionaryDetailViewModel({
    required WordRepository wordRepository,
    required AudioService audioService,
    required Word word,
  })  : _wordRepository = wordRepository,
        _audioService = audioService,
        _word = word;

  Word get word => _word;
  bool get isPremium => _isPremium;
  bool get isMastered => _isMastered;
  bool get isPlaying => _audioService.isPlaying;

  void setIsPremium(bool value) {
    _isPremium = value;
    notifyListeners();
  }

  void setIsMastered(bool value) {
    _isMastered = value;
    notifyListeners();
  }

  Future<void> playPhoneticAudio() async {
    if (_word.phonetic != null) {
      await _audioService.playAudio(_word.phonetic);
      notifyListeners();
    }
  }

  Future<void> playPhoneticAmAudio() async {
    if (_word.phoneticAm != null) {
      await _audioService.playAudio(_word.phoneticAm);
      notifyListeners();
    }
  }

  Future<bool> masterWord() async {
    setBusy(true);

    try {
      final response = await _wordRepository.updateWordStatus(
        wordId: _word.id,
        status: WordStatus.learned.value,
      );

      if (response.success) {
        setIsMastered(true);
        setBusy(false);
        debugPrint('Word mastered: ${_word.id}');
        return true;
      } else {
        setError(response.message ?? 'Failed to master word');
        return false;
      }
    } catch (e) {
      setError(e.toString());
      return false;
    } finally {
      setBusy(false);
    }
  }

  @override
  void dispose() {
    // No need to dispose audio service as it's a singleton
    super.dispose();
  }
}
