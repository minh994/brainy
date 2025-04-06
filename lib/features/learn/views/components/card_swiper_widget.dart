import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../viewmodels/learn_viewmodel.dart';
import 'flashcard_widget.dart';

class CardSwiperWidget extends StatelessWidget {
  final LearnViewModel model;
  final CardSwiperController controller;
  final int currentIndex;
  final bool showDefinition;
  final Function(int) onIndexChanged;
  final VoidCallback onDefinitionToggle;
  final VoidCallback onComplete;

  const CardSwiperWidget({
    super.key,
    required this.model,
    required this.controller,
    required this.currentIndex,
    required this.showDefinition,
    required this.onIndexChanged,
    required this.onDefinitionToggle,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Card swiper
        Expanded(
          child: CardSwiper(
            controller: controller,
            cardsCount: model.learningWords.length,
            onSwipe: (previousIndex, currentIndex, direction) {
              // Update current index
              if (currentIndex != null) {
                onIndexChanged(currentIndex);
              }

              // Check if we've reached the end of the cards
              if (currentIndex == null) {
                // All cards have been swiped
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  onComplete();
                });
              }

              // Handle word status based on swipe direction
              if (previousIndex < model.learningWords.length) {
                final swipedWord = model.learningWords[previousIndex];

                if (direction == CardSwiperDirection.left) {
                  // Left swipe - skip
                  model.setWordSkipped(swipedWord.id);

                  // If this was the last card, show completion
                  if (previousIndex == model.learningWords.length - 1) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      onComplete();
                    });
                  }
                } else if (direction == CardSwiperDirection.right) {
                  // Right swipe - mark as learned
                  model.setWordLearned(swipedWord.id);

                  // If this was the last card, show completion
                  if (previousIndex == model.learningWords.length - 1) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      onComplete();
                    });
                  }
                }
              }

              return true;
            },
            allowedSwipeDirection: const AllowedSwipeDirection.symmetric(
              horizontal: true,
              vertical: false,
            ),
            numberOfCardsDisplayed: 3,
            backCardOffset: const Offset(20, 20),
            padding: const EdgeInsets.all(24.0),
            cardBuilder:
                (context, index, percentThresholdX, percentThresholdY) {
              final word = model.learningWords[index];
              return FlashcardWidget(
                word: word,
                model: model,
                index: index,
                currentIndex: currentIndex,
                showDefinition: showDefinition,
                onTap: onDefinitionToggle,
              );
            },
          ),
        ),
      ],
    );
  }
}
