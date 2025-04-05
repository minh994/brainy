import 'package:flutter/material.dart';
import '../../../core/dependency_injection/locator.dart';
import '../../../core/repositories/abstract/word_repository.dart';
import '../../../core/widgets/busy_indicator.dart';
import '../../../core/models/word_model.dart';
import '../components/vocabulary_card.dart';

class VocabularyDetailScreen extends StatefulWidget {
  final String wordId;

  const VocabularyDetailScreen({
    Key? key,
    required this.wordId,
  }) : super(key: key);

  @override
  State<VocabularyDetailScreen> createState() => _VocabularyDetailScreenState();
}

class _VocabularyDetailScreenState extends State<VocabularyDetailScreen> {
  late final WordRepository _wordRepository;
  Word? _word;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isPlayingAudio = false;

  @override
  void initState() {
    super.initState();
    _wordRepository = locator<WordRepository>();
    _loadWord();
  }

  Future<void> _loadWord() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _wordRepository.getWordById(widget.wordId);
      if (response.success && response.data != null) {
        setState(() {
          _word = response.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _playAudio() async {
    if (_isPlayingAudio || _word == null) return;

    final audioUrl = _word!.phonetic ?? _word!.phoneticAm;
    if (audioUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No audio available for this word')),
      );
      return;
    }

    setState(() {
      _isPlayingAudio = true;
    });

    try {
      // Simulate audio playback
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error playing audio: $e')),
      );
    } finally {
      setState(() {
        _isPlayingAudio = false;
      });
    }
  }

  void _onSkip() {
    // Handle skip action
    Navigator.pop(context);
  }

  void _onLearn() {
    // Handle learn action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adding word to learning list...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: _buildContent(),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: BusyIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: $_errorMessage',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadWord,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_word == null) {
      return const Center(
        child: Text('Word not found'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: VocabularyCard(
        word: _word!,
        onSkip: _onSkip,
        onLearn: _onLearn,
        onAudioTapPhonetic: _playAudio,
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Learn',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: 'Dictionary',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.insert_chart),
          label: 'Statistic',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
