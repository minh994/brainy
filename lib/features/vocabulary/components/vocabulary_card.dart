import 'package:flutter/material.dart';
import '../../../core/models/word_model.dart';

class VocabularyCard extends StatefulWidget {
  final Word word;
  final VoidCallback? onSkip;
  final VoidCallback? onLearn;
  final VoidCallback? onAudioTap;

  const VocabularyCard({
    Key? key,
    required this.word,
    this.onSkip,
    this.onLearn,
    this.onAudioTap,
  }) : super(key: key);

  @override
  State<VocabularyCard> createState() => _VocabularyCardState();
}

class _VocabularyCardState extends State<VocabularyCard> {
  final int _currentSenseIndex = 0;
  final int _currentExampleIndex = 0;

  Sense? get currentSense {
    if (widget.word.senses.isEmpty) return null;
    if (_currentSenseIndex >= widget.word.senses.length) {
      return widget.word.senses.first;
    }
    return widget.word.senses[_currentSenseIndex];
  }

  Example? get currentExample {
    if (currentSense == null || currentSense!.examples.isEmpty) return null;
    if (_currentExampleIndex >= currentSense!.examples.length) {
      return currentSense!.examples.first;
    }
    return currentSense!.examples[_currentExampleIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with navigation tabs
            Row(
              children: [
                _buildTabButton('New', isActive: true),
                const SizedBox(width: 8),
                _buildTabButton('My words', isActive: false),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Word
                  Text(
                    widget.word.word,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Phonetic
                  if (widget.word.phoneticText != null)
                    Text(
                      widget.word.phoneticText!,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 24),

                  // Translation (definition in Russian)
                  if (currentSense != null)
                    Text(
                      currentSense!.definition,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 24),

                  const Divider(),

                  // Examples
                  if (currentExample != null)
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          ExampleItem(
                            example: currentExample!.x,
                            onAudioTap: widget.onAudioTap,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Bottom controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Skip'),
                  onPressed: widget.onSkip,
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up, size: 32),
                  onPressed: widget.onAudioTap,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Learn'),
                  onPressed: widget.onLearn,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, {required bool isActive}) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor:
            isActive ? Colors.green.withOpacity(0.1) : Colors.grey[200],
        foregroundColor: isActive ? Colors.green : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: () {},
      child: Text(text),
    );
  }
}

class ExampleItem extends StatelessWidget {
  final String example;
  final VoidCallback? onAudioTap;

  const ExampleItem({
    Key? key,
    required this.example,
    this.onAudioTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.arrow_drop_down),
      title: Text(
        example,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.volume_up),
        onPressed: onAudioTap,
      ),
    );
  }
}
