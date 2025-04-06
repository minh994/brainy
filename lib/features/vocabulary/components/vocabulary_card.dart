import 'package:flutter/material.dart';
import '../../../core/models/word_model.dart';

class VocabularyCard extends StatefulWidget {
  final Word word;
  final VoidCallback? onSkip;
  final VoidCallback? onLearn;
  final VoidCallback? onAudioTapPhonetic;
  final VoidCallback? onAudioTapPhoneticAm;

  const VocabularyCard({
    Key? key,
    required this.word,
    this.onSkip,
    this.onLearn,
    this.onAudioTapPhonetic,
    this.onAudioTapPhoneticAm,
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
                _buildTabButton('New', Colors.green, isActive: true),
                const SizedBox(width: 8),
                _buildTabButton(widget.word.pos, widget.word.getPosColor()),
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
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.word.word,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // Phonetic
                  if (widget.word.phoneticText != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            onTap: widget.onAudioTapPhonetic,
                            borderRadius: BorderRadius.circular(8),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: Icon(Icons.volume_up,
                                  size: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.word.phoneticText!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 5),
                  if (widget.word.phoneticAmText != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            onTap: widget.onAudioTapPhoneticAm,
                            borderRadius: BorderRadius.circular(8),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: Icon(Icons.volume_up,
                                  size: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.word.phoneticAmText!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),

                  // Translation (definition in Russian)
                  if (currentSense != null)
                    Text(
                      currentSense!.definition,
                      style: const TextStyle(
                        fontSize: 13,
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
                            onAudioTap: widget.onAudioTapPhonetic,
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

  Widget _buildTabButton(String text, Color? color, {bool isActive = false}) {
    Color? backgroundColor;
    if (isActive) {
      backgroundColor = Colors.green.withOpacity(0.5);
    } else {
      backgroundColor = color?.withOpacity(0.1);
    }
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color ?? Colors.grey[200]!),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: isActive ? Colors.grey[800] : color,
        ),
      ),
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
      title: Text(
        example,
        style: const TextStyle(
          fontSize: 11,
        ),
      ),
    );
  }
}
