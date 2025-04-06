import 'package:flutter/material.dart';
import '../../../core/routes/app_router.dart';

class VocabularyListView extends StatelessWidget {
  const VocabularyListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample list of vocabulary words
    final List<Map<String, dynamic>> words = [
      {'id': '1', 'term': 'apple', 'translation': 'quả táo'},
      {'id': '2', 'term': 'book', 'translation': 'quyển sách'},
      {'id': '3', 'term': 'car', 'translation': 'xe hơi'},
      {'id': '4', 'term': 'dog', 'translation': 'con chó'},
      {'id': '5', 'term': 'elephant', 'translation': 'con voi'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vocabulary'),
      ),
      body: ListView.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          return ListTile(
            title: Text(word['term']),
            subtitle: Text(word['translation']),
            onTap: () {
              AppRouter.navigateTo(
                context,
                AppRouter.vocabularyDetail,
                arguments: word['id'],
              );
            },
          );
        },
      ),
    );
  }
}
