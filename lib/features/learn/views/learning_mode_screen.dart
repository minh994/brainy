import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../../core/base/base_view.dart';
import '../../../core/dependency_injection/locator.dart';
import '../../../core/widgets/busy_indicator.dart';
import '../viewmodels/learn_viewmodel.dart';
import 'components/card_swiper_widget.dart';
import 'components/completion_screen.dart';
import 'components/learning_controls.dart';

class LearningModeScreen extends StatefulWidget {
  final String mode;

  const LearningModeScreen({
    super.key,
    required this.mode,
  });

  @override
  State<LearningModeScreen> createState() => _LearningModeScreenState();
}

class _LearningModeScreenState extends State<LearningModeScreen> {
  final CardSwiperController _cardController = CardSwiperController();
  int _currentIndex = 0;
  bool _showDefinition = false;

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

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

        if (model.learningWords.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Learning Mode'),
            ),
            body: const Center(
              child: Text('No words to learn'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.mode == 'flashcard' ? 'Flashcard Mode' : 'Quiz Mode',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Show confirmation dialog if there are still cards left
                if (_currentIndex < model.learningWords.length - 1) {
                  _showExitConfirmationDialog(context);
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    '${_currentIndex + 1}/${model.learningWords.length}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: (_currentIndex + 1) / model.learningWords.length,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),

              // Flashcard content
              Expanded(
                child: CardSwiperWidget(
                  model: model,
                  controller: _cardController,
                  currentIndex: _currentIndex,
                  showDefinition: _showDefinition,
                  onIndexChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                      _showDefinition = false;
                    });
                  },
                  onDefinitionToggle: () {
                    setState(() {
                      _showDefinition = !_showDefinition;
                    });
                  },
                  onComplete: () => _showCompletionScreen(context),
                ),
              ),

              // Bottom controls
              LearningControls(
                model: model,
                onFlip: () {
                  setState(() {
                    _showDefinition = !_showDefinition;
                  });
                },
                onSkip: () => _handleSkip(model),
                onLearned: () => _handleLearned(model),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleSkip(LearnViewModel model) {
    // Check if this is the last item
    if (_currentIndex == model.learningWords.length - 1) {
      // Mark as skipped
      model.setWordSkipped(model.learningWords[_currentIndex].id);
      // Show completion screen
      _showCompletionScreen(context);
    } else {
      // Skip the current word
      _cardController.swipe(CardSwiperDirection.left);
    }
  }

  void _handleLearned(LearnViewModel model) {
    // Check if this is the last item
    if (_currentIndex == model.learningWords.length - 1) {
      // Mark as learned
      model.setWordLearned(model.learningWords[_currentIndex].id);
      // Show completion screen
      _showCompletionScreen(context);
    } else {
      // Mark as learned and swipe
      _cardController.swipe(CardSwiperDirection.right);
    }
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit Learning Mode'),
          content: const Text(
              'Are you sure you want to exit? Your progress will be saved.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous screen
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  void _showCompletionScreen(BuildContext context) {
    showCompletionScreen(
      context: context,
      onReturnToLearningView: () {
        Navigator.of(context).pop(); // Go back to previous screen
      },
      onStartAgain: () {
        setState(() {
          _currentIndex = 0;
          _showDefinition = false;
        });
      },
    );
  }
}
