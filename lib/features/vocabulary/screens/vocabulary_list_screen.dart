import 'package:flutter/material.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/models/word_model.dart';

class VocabularyListScreen extends StatelessWidget {
  const VocabularyListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock data
    final List<Map<String, dynamic>> mockWordsData = [
      {
        "id": "0115a61c-0252-4b1d-835b-dbbde3a31217",
        "word": "attain",
        "pos": "verb",
        "phonetic_text": "/əˈteɪn/",
        "senses": [
          {
            "id": "9240f62b-2b80-4c5b-a133-0c50dd7b4858",
            "definition": "to succeed in getting something",
            "examples": [
              {
                "id": "19fff10d-e660-4622-9f29-5003e7d3b5d7",
                "cf": "",
                "x":
                    "We only consider applicants who have attained a high level of academic achievement."
              }
            ]
          }
        ]
      },
      {
        "id": "1115a61c-0252-4b1d-835b-dbbde3a31218",
        "word": "recursion",
        "pos": "noun",
        "phonetic_text": "/rɪˈkɜːrʒn/",
        "senses": [
          {
            "id": "1240f62b-2b80-4c5b-a133-0c50dd7b4859",
            "definition": "a function that calls itself",
            "examples": [
              {
                "id": "29fff10d-e660-4622-9f29-5003e7d3b5d8",
                "cf": "",
                "x":
                    "Understanding recursion is the key to solving this complex problem."
              }
            ]
          }
        ]
      },
      {
        "id": "2115a61c-0252-4b1d-835b-dbbde3a31219",
        "word": "persistent",
        "pos": "adjective",
        "phonetic_text": "/pəˈsɪstənt/",
        "senses": [
          {
            "id": "2240f62b-2b80-4c5b-a133-0c50dd7b4860",
            "definition": "continuing to exist or occur over a long period",
            "examples": [
              {
                "id": "39fff10d-e660-4622-9f29-5003e7d3b5d9",
                "cf": "",
                "x": "He has a persistent cough that won't go away."
              }
            ]
          }
        ]
      }
    ];

    // Convert mock data to Word objects
    final List<Word> words =
        mockWordsData.map((data) => Word.fromJson(data)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vocabulary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: words.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final word = words[index];
          String? definition =
              word.senses.isNotEmpty ? word.senses.first.definition : null;

          return ListTile(
            title: Text(
              word.word,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (word.phoneticText != null)
                  Text(
                    word.phoneticText!,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                if (definition != null)
                  Text(
                    definition,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              AppRouter.navigateTo(
                context,
                AppRouter.vocabularyDetail,
                arguments: word.id,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new word
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
