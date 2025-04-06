import 'package:flutter/material.dart';
import 'models/lesson_model.dart';
import 'views/category_detail_view.dart';
import 'views/grammar_view.dart';
import 'views/lesson_detail_view.dart';

class GrammarRoutes {
  // Route names
  static const String grammar = '/grammar';
  static const String categoryDetail = '/grammar/category';
  static const String lessonDetail = '/grammar/lesson';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (settings.name == grammar) {
      return MaterialPageRoute(builder: (_) => const GrammarView());
    }

    if (settings.name == categoryDetail) {
      final String categoryId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => CategoryDetailView(categoryId: categoryId),
      );
    }

    if (settings.name == lessonDetail) {
      final Lesson lesson = settings.arguments as Lesson;
      return MaterialPageRoute(
        builder: (_) => LessonDetailView(lesson: lesson),
      );
    }

    // If route not found, return default error route
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No grammar route defined for ${settings.name}'),
        ),
      ),
    );
  }
}
