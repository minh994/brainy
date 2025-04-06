import 'package:flutter/material.dart';
import '../../../core/base/base_view.dart';
import '../../../core/dependency_injection/locator.dart';
import '../../../core/models/word_model.dart';
import '../../../core/widgets/busy_indicator.dart';
import '../../dictionary/views/dictionary_detail_view.dart';
import '../viewmodels/learn_viewmodel.dart';
import 'learning_mode_screen.dart';

class LearnView extends StatefulWidget {
  const LearnView({super.key});

  @override
  State<LearnView> createState() => _LearnViewState();
}

class _LearnViewState extends State<LearnView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<LearnViewModel>(
      viewModelBuilder: () => locator<LearnViewModel>(),
      onModelReady: (model) => model.loadLearningWords(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return const Scaffold(
            body: Center(child: BusyIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Learning Words',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    '${model.learningWords.length} words',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: model.learningWords.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: model.learningWords.length,
                  itemBuilder: (context, index) {
                    final word = model.learningWords[index];
                    return _buildWordItem(word, model);
                  },
                ),
          floatingActionButton: model.learningWords.isNotEmpty
              ? FloatingActionButton.extended(
                  onPressed: () =>
                      _showStartLearningBottomSheet(context, model),
                  label: const Text('Start Learning',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      )),
                  icon: const Icon(Icons.play_arrow,
                      size: 18, color: Colors.white),
                  backgroundColor: Theme.of(context).primaryColor,
                )
              : null,
        );
      },
    );
  }

  void _showStartLearningBottomSheet(
      BuildContext context, LearnViewModel model) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StartLearningBottomSheet(
        wordsCount: model.learningWords.length,
        onStartLearning: () {
          Navigator.pop(context);
          _navigateToLearningMode(context);
        },
      ),
    );
  }

  void _navigateToLearningMode(BuildContext context) {
    // Navigate to the learning mode screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LearningModeScreen(mode: 'flashcard'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Learning Words',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Words you are learning will appear here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWordItem(Word word, LearnViewModel model) {
    final String translationText =
        word.senses.isNotEmpty ? word.senses.first.definition : '';

    // Get POS color and display name
    final Color posColor = word.getPosColor();
    final String posDisplayName = word.pos;

    return Dismissible(
      key: Key(word.id),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        color: Colors.green,
        child: const Row(
          children: [
            Icon(Icons.check, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Mastered',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.grey,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Skip',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.close, color: Colors.white),
          ],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Left to right swipe (Mastered)
          model.setWordLearned(word.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Word marked as mastered')),
          );
        } else {
          // Right to left swipe (Skip)
          model.setWordSkipped(word.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Word skipped')),
          );
        }
      },
      child: GestureDetector(
        onTap: () => _navigateToWordDetails(context, word),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row with word, phonetic and POS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Word and phonetic
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                word.word,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              // AudioButton(
                              //   onTap: () => model.playAudio(word.phonetic),
                              //   backgroundColor: Colors.blueAccent,
                              //   isPlaying: model.isPlayingAudio,
                              //   size: 16,
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // POS badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: posColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: posColor,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        posDisplayName,
                        style: TextStyle(
                          fontSize: 10,
                          color: posColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                // Definition
                const SizedBox(height: 12),
                Text(
                  translationText,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),

                // Learning indicator
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildLearningIndicator(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLearningIndicator() {
    return Row(
      children: [
        const Text(
          'Learning',
          style: TextStyle(
            fontSize: 10,
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  void _navigateToWordDetails(BuildContext context, Word word) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WordDetailsScreen(word: word),
      ),
    );
  }
}

class _StartLearningBottomSheet extends StatelessWidget {
  final int wordsCount;
  final VoidCallback onStartLearning;

  const _StartLearningBottomSheet({
    required this.wordsCount,
    required this.onStartLearning,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            const Text(
              'Ready to Learn?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              'You have $wordsCount words to learn. Start a focused learning session now to improve your vocabulary.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24),

            // Learning modes
            _buildLearningModeOption(
              context,
              title: 'Flashcard Mode',
              description: 'Review words with flashcards',
              icon: Icons.view_carousel_outlined,
              isRecommended: false,
            ),
            const SizedBox(height: 12),
            _buildLearningModeOption(
              context,
              title: 'Quiz Mode',
              description: 'Test your knowledge with quizzes',
              icon: Icons.quiz_outlined,
              isRecommended: false,
            ),
            const SizedBox(height: 32),

            // Start button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onStartLearning,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Start Learning',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningModeOption(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required bool isRecommended,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRecommended
              ? Theme.of(context).primaryColor
              : Colors.grey[300]!,
          width: isRecommended ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: isRecommended
                  ? Theme.of(context).primaryColor
                  : Colors.grey[700],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isRecommended
                              ? Theme.of(context).primaryColor
                              : Colors.black87,
                        ),
                      ),
                      if (isRecommended) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Recommended',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            Radio(
              value: isRecommended,
              groupValue: true,
              onChanged: (value) {},
              activeColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
