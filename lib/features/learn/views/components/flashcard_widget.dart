import 'package:flutter/material.dart';
import '../../../../core/models/word_model.dart';
import '../../../../core/widgets/audio_button.dart';
import '../../viewmodels/learn_viewmodel.dart';

class FlashcardWidget extends StatelessWidget {
  final Word word;
  final LearnViewModel model;
  final int index;
  final int currentIndex;
  final bool showDefinition;
  final VoidCallback onTap;

  const FlashcardWidget({
    super.key,
    required this.word,
    required this.model,
    required this.index,
    required this.currentIndex,
    required this.showDefinition,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentCard = index == currentIndex;
    final shouldShowDefinition = isCurrentCard && showDefinition;

    return GestureDetector(
      onTap: isCurrentCard ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Card header with POS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: word.getPosColor().withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    word.pos,
                    style: TextStyle(
                      color: word.getPosColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        shouldShowDefinition ? 'Definition' : 'Word',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Hint about swipe actions
                      Icon(
                        Icons.swipe,
                        size: 18,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Card content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: shouldShowDefinition
                      ? _buildDefinitionView(word)
                      : _buildWordView(word, model, context),
                ),
              ),
            ),

            // Tap instruction
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app,
                    size: 16,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tap to ${shouldShowDefinition ? 'show word' : 'show definition'}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordView(Word word, LearnViewModel model, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          word.word,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (word.phonetic != null && word.phonetic!.isNotEmpty)
              Text(
                word.phoneticText ?? '',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            const SizedBox(width: 8),
            AudioButton(
              onTap: () => model.playAudio(word.phonetic ?? ''),
              backgroundColor: Theme.of(context).primaryColor,
              isPlaying: model.isPlayingAudio,
              size: 18,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDefinitionView(Word word) {
    final String definition = word.senses.isNotEmpty
        ? word.senses.first.definition
        : 'No definition available';

    // Get examples if available
    final List<String> examples = [];
    if (word.senses.isNotEmpty && word.senses.first.examples.isNotEmpty) {
      for (var example in word.senses.first.examples) {
        examples.add(example.x);
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          definition,
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey[800],
          ),
          textAlign: TextAlign.center,
        ),
        if (examples.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text(
            'Example:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            examples.first,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
