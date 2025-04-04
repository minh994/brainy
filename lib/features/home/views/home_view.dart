import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../../core/base/base_view.dart';
import '../../../core/dependency_injection/locator.dart';
import '../../../core/widgets/busy_indicator.dart';
import '../../vocabulary/components/vocabulary_card.dart';
import '../viewmodels/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final CardSwiperController _cardController = CardSwiperController();

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  void _onSkip() {
    // Swipe the card manually to the left
    _cardController.swipe(CardSwiperDirection.left);
  }

  void _onLearn() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adding word to learning list...')),
    );
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
              const SizedBox(height: 20),
              Expanded(
                child: CardSwiper(
                  controller: _cardController,
                  cardsCount: model.words.length,
                  onSwipe: (previousIndex, currentIndex, direction) {
                    // Handle card swipe
                    if (currentIndex == null) {
                      // All cards have been swiped
                      model.loadMoreWords();
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
                      onSkip: _onSkip,
                      onLearn: _onLearn,
                      onAudioTap: model.playAudio,
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
