import 'package:flutter/material.dart';
import 'screens/vocabulary_detail_screen.dart';

class VocabularyRoutes {
  static const String vocabularyDetail = '/vocabulary/detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case vocabularyDetail:
        final String wordId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => VocabularyDetailScreen(wordId: wordId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
