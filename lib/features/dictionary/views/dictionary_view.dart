import 'package:flutter/material.dart';
import '../../../core/base/base_view.dart';
import '../../../core/dependency_injection/locator.dart';
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
            title: const Text('Oxford 5000'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: Icon(Icons.mic),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                    ),
                    onChanged: (query) {
                      model.searchWords(query);
                    },
                  ),
                ),
              ),

              // Filter chips
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    _buildFilterChip(
                        'New', 4261, Colors.green, model.activeFilter == 'New',
                        () {
                      model.setActiveFilter('New');
                    }),
                    const SizedBox(width: 10),
                    _buildFilterChip('Learned', 523, Colors.black,
                        model.activeFilter == 'Learned', () {
                      model.setActiveFilter('Learned');
                    }),
                    const SizedBox(width: 10),
                    _buildFilterChip('Learning', 126, Colors.blue,
                        model.activeFilter == 'Learning', () {
                      model.setActiveFilter('Learning');
                    }),
                    const SizedBox(width: 10),
                    _buildFilterChip('Skipped', 0, Colors.grey,
                        model.activeFilter == 'Skipped', () {
                      model.setActiveFilter('Skipped');
                    }),
                  ],
                ),
              ),

              // Word list
              Expanded(
                child: ListView.builder(
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

  Widget _buildFilterChip(
      String label, int count, Color color, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isActive ? color : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: color),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isActive ? color : Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              count.toString(),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
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

    final String wordStatus = model.getWordStatus(word);
    final Color statusColor = _getStatusColor(wordStatus);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  word.word,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      wordStatus,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              translationText,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Learning':
        return Colors.blue;
      case 'Learned':
        return Colors.black;
      case 'Skipped':
        return Colors.grey;
      case 'New':
      default:
        return Colors.green;
    }
  }
}
