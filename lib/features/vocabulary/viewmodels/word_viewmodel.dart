import '../../../core/base/base_viewmodel.dart';
import '../models/word.dart';

class WordViewModel extends BaseViewModel {
  Word? _word;

  Word? get word => _word;

  Future<void> loadWordDetails(String wordText) async {
    try {
      await runBusyFuture(_fetchWordDetails(wordText));
    } catch (e) {
      setError('Failed to load word details: ${e.toString()}');
    }
  }

  // Simulated API call
  Future<void> _fetchWordDetails(String wordText) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // For demo purposes, return mock data
    _word = Word(
      text: 'Example',
      pronunciation: 'ig-ˈzam-pəl',
      definitions: [
        'A representative form or pattern',
        'A typical instance or case',
        'A punishment given as a warning or deterrent',
        'A parallel or similar case that constitutes a model or precedent',
      ],
      examples: [
        'She set a good example for the children.',
        'The teacher gave several examples to illustrate the concept.',
        'This painting is a fine example of his early work.',
      ],
    );
  }
}
