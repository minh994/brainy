import 'package:brainy_flutter/core/base/base_view.dart';
import 'package:brainy_flutter/core/dependency_injection/locator.dart';
import 'package:brainy_flutter/core/models/word_model.dart';
import 'package:brainy_flutter/core/widgets/audio_button.dart';
import 'package:brainy_flutter/features/dictionary/viewmodels/dictionary_detail_view_model.dart';
import 'package:flutter/material.dart';

class WordDetailsScreen extends StatelessWidget {
  final Word word;

  const WordDetailsScreen({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return BaseView<DictionaryDetailViewModel>(
      viewModelBuilder: () => locator<DictionaryDetailViewModel>(param1: word),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Word Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: 'Roboto',
              ),
            ),
            actions: [
              if (!model.isMastered)
                TextButton(
                  onPressed: () => _onMastered(context, model),
                  child: Text(
                    'Mastered',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
            ],
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  void _onMastered(
      BuildContext context, DictionaryDetailViewModel model) async {
    final success = await model.masterWord();
    if (success && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildBody(BuildContext context, DictionaryDetailViewModel model) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final word = model.word;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              word.word,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "A. Class: ${word.pos}",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Roboto',
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "B. Phonetic",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Roboto',
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            // Phonetic
            if (word.phoneticText != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AudioButton(
                    onTap: () => model.playPhoneticAudio(),
                    backgroundColor: Colors.blueAccent,
                    isPlaying: model.isPlaying,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    word.phoneticText!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 5),
            if (word.phoneticAmText != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AudioButton(
                    onTap: () => model.playPhoneticAmAudio(),
                    backgroundColor: Colors.redAccent,
                    isPlaying: model.isPlaying,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    word.phoneticAmText!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            const SizedBox(height: 8),
            Text(
              "C. Definition",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'Roboto',
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 8),
            ...List.generate(word.senses.length, (index) {
              final sense = word.senses[index];
              return Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ${sense.definition}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontFamily: 'Roboto',
                          ),
                    ),
                    const SizedBox(height: 8),
                    if (sense.examples.isNotEmpty) ...[
                      const Text("Examples:"),
                      const SizedBox(height: 8),
                      ...List.generate(
                        sense.examples.length,
                        (index) {
                          final example = sense.examples[index];
                          return Text(
                            '${index + 1}.${example.cf.isNotEmpty ? ' (${example.cf})' : ''} ${example.x}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  fontFamily: 'Roboto',
                                ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
