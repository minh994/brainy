import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../../core/base/base_view.dart';
import '../../../core/dependency_injection/locator.dart';
import '../../../core/widgets/busy_indicator.dart';
import '../components/vocabulary_card.dart';
import '../viewmodels/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final CardSwiperController _cardController = CardSwiperController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  void _onSkip(HomeViewModel model) {
    // Get current word and update its status
    if (_currentIndex < model.words.length) {
      final currentWord = model.words[_currentIndex];
      model.setWordSkipped(currentWord.id);

      // Show feedback to user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Word skipped')),
      );
    }

    // Swipe the card manually to the left
    _cardController.swipe(CardSwiperDirection.left);
  }

  void _onLearn(HomeViewModel model) {
    // Get current word and update its status
    if (_currentIndex < model.words.length) {
      final currentWord = model.words[_currentIndex];
      model.setWordLearning(currentWord.id);

      // Show feedback to user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to learning list')),
      );
    }

    // Swipe the card manually to the right
    _cardController.swipe(CardSwiperDirection.right);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      viewModelBuilder: () => locator<HomeViewModel>(),
      onModelReady: (model) => model.loadWords(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return const Center(child: BusyIndicator());
        }

        if (model.hasError && model.words.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${model.errorMessage}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: model.loadWords,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (model.words.isEmpty) {
          return const Center(
            child: Text('No vocabulary words available'),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Expanded(
                child: CardSwiper(
                  controller: _cardController,
                  cardsCount: model.words.length,
                  onSwipe: (previousIndex, currentIndex, direction) {
                    // Update current index
                    if (currentIndex != null) {
                      _currentIndex = currentIndex;
                    }

                    // Handle end of cards
                    if (currentIndex == null) {
                      // All cards have been swiped
                      model.loadMoreWords();
                    }

                    // Update word status based on swipe direction if not handled by buttons
                    if (previousIndex < model.words.length) {
                      final swipedWord = model.words[previousIndex];

                      if (direction == CardSwiperDirection.left) {
                        // Left swipe - mark as skipped
                        model.setWordSkipped(swipedWord.id);
                      } else if (direction == CardSwiperDirection.right) {
                        // Right swipe - mark as learning
                        model.setWordLearning(swipedWord.id);
                      }
                    }

                    return true;
                  },
                  numberOfCardsDisplayed: 3,
                  backCardOffset: const Offset(20, 20),
                  padding: const EdgeInsets.all(24.0),
                  cardBuilder:
                      (context, index, percentThresholdX, percentThresholdY) {
                    final word = model.words[index];
                    return VocabularyCard(
                      word: word,
                      onSkip: () => _onSkip(model),
                      onLearn: () => _onLearn(model),
                      onAudioTapPhonetic: () => model.playAudio(word.phonetic),
                      onAudioTapPhoneticAm: () =>
                          model.playAudio(word.phoneticAm),
                      isPlayingAudio: model.isPlayingAudio,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
