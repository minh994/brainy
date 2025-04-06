import 'package:brainy_flutter/features/dictionary/views/dictionary_detail_view.dart';
import 'package:flutter/material.dart';
import '../../../core/base/base_view.dart';
import '../../../core/dependency_injection/locator.dart';
import '../../../core/enums/word_status_enum.dart';
import '../../../core/models/word_model.dart';
import '../../../core/widgets/busy_indicator.dart';
import '../viewmodels/dictionary_view_model.dart';

class DictionaryView extends StatefulWidget {
  const DictionaryView({super.key});

  @override
  State<DictionaryView> createState() => _DictionaryViewState();
}

class _DictionaryViewState extends State<DictionaryView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<DictionaryViewModel>(
      viewModelBuilder: () => locator<DictionaryViewModel>(),
      onModelReady: (model) => model.loadWords(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return const Center(child: BusyIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Oxford 5000',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )),
            actions: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  // Menu action
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search, size: 18),
                    suffixIcon: const Icon(Icons.mic, size: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 4,
                    ),
                  ),
                  onChanged: (query) {
                    model.searchWords(query);
                  },
                ),
              ),

              // Filter chips
              SizedBox(
                height: 30,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    // All words filter
                    _buildFilterChip(
                      context,
                      WordStatus.all,
                      model.statusCounts[WordStatus.all] ?? 0,
                      Colors.green,
                      model.activeStatus == WordStatus.all,
                      () => model.setActiveStatus(WordStatus.all),
                    ),
                    const SizedBox(width: 10),

                    // Learning filter
                    _buildFilterChip(
                      context,
                      WordStatus.learning,
                      model.statusCounts[WordStatus.learning] ?? 0,
                      Colors.blue,
                      model.activeStatus == WordStatus.learning,
                      () => model.setActiveStatus(WordStatus.learning),
                    ),
                    const SizedBox(width: 10),

                    // Mastered filter
                    _buildFilterChip(
                      context,
                      WordStatus.learned,
                      model.statusCounts[WordStatus.learned] ?? 0,
                      Colors.black,
                      model.activeStatus == WordStatus.learned,
                      () => model.setActiveStatus(WordStatus.learned),
                    ),
                    const SizedBox(width: 10),

                    // Skipped filter
                    _buildFilterChip(
                      context,
                      WordStatus.skip,
                      model.statusCounts[WordStatus.skip] ?? 0,
                      Colors.grey,
                      model.activeStatus == WordStatus.skip,
                      () => model.setActiveStatus(WordStatus.skip),
                    ),
                  ],
                ),
              ),

              // Word list
              Expanded(
                child: model.filteredWords.isEmpty
                    ? const Center(child: Text('No words found'))
                    : ListView.builder(
                        itemCount: model.filteredWords.length,
                        itemBuilder: (context, index) {
                          final word = model.filteredWords[index];
                          return _buildWordItem(word, model);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToWordDetails(BuildContext context, Word word) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WordDetailsScreen(word: word),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    WordStatus status,
    int count,
    Color color,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? color : Colors.grey.shade300,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive ? color : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: color),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              status.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? color : Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              count.toString(),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordItem(Word word, DictionaryViewModel model) {
    final String translationText =
        word.senses.isNotEmpty ? word.senses.first.definition : '';

    // Get POS color and display name
    final Color posColor = word.getPosColor();
    final String posDisplayName = word.pos;

    return GestureDetector(
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
                            InkWell(
                              onTap: () {
                                // Play pronunciation
                              },
                              child: Icon(Icons.volume_up,
                                  size: 16,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // POS badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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

              // Learning status indicator
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildLearningStatusIndicator(word, model),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLearningStatusIndicator(Word word, DictionaryViewModel model) {
    // Determine status based on current filter and fallback logic
    final String status = model.activeStatus != WordStatus.all
        ? model.activeStatus.label
        : _determineFallbackStatus(word);

    final Color statusColor = _getStatusColor(status);

    return Row(
      children: [
        Text(
          status,
          style: TextStyle(
            fontSize: 10,
            color: statusColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  String _determineFallbackStatus(Word word) {
    // Simple deterministic approach for demo
    final wordHash = word.word.length + word.word.codeUnitAt(0);

    if (wordHash % 10 < 3) {
      return WordStatus.learning.label;
    } else if (wordHash % 10 < 5) {
      return WordStatus.learned.label;
    } else if (wordHash % 10 < 6) {
      return WordStatus.skip.label;
    } else {
      return "New";
    }
  }

  Color _getStatusColor(String status) {
    if (status == WordStatus.learning.label) {
      return Colors.blue;
    } else if (status == WordStatus.learned.label) {
      return Colors.black;
    } else if (status == WordStatus.skip.label) {
      return Colors.grey;
    } else {
      return Colors.green; // For "New" or other statuses
    }
  }
}
