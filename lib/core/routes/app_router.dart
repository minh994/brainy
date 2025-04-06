import 'package:flutter/material.dart';

import '../../features/auth/views/login_view.dart';
import '../../features/auth/views/signup_view.dart';
import '../../features/home/screens/main_screen.dart';
import '../../features/vocabulary/vocabulary_routes.dart';
import '../../features/vocabulary/screens/vocabulary_list_screen.dart';
import '../../features/grammar/grammar_routes.dart';

class AppRouter {
  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String vocabulary = '/vocabulary';
  static const String vocabularyDetail = VocabularyRoutes.vocabularyDetail;
  static const String grammar = GrammarRoutes.grammar;
  static const String grammarCategoryDetail = GrammarRoutes.categoryDetail;
  static const String grammarLessonDetail = GrammarRoutes.lessonDetail;

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // First check if the route is a vocabulary feature route
    if (settings.name?.startsWith('/vocabulary/') ?? false) {
      return VocabularyRoutes.generateRoute(settings);
    }

    // Check if the route is a grammar feature route
    if (settings.name?.startsWith('/grammar/') ?? false) {
      return GrammarRoutes.generateRoute(settings);
    }

    // If not, handle with main router
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupView());
      case home:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case vocabulary:
        return MaterialPageRoute(builder: (_) => const VocabularyListScreen());
      case grammar:
        return GrammarRoutes.generateRoute(settings);
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

  // Navigation methods
  static Future<T?> navigateTo<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    RouteTransitionType transitionType = RouteTransitionType.fade,
  }) {
    return Navigator.of(context).pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> navigateToReplacement<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    RouteTransitionType transitionType = RouteTransitionType.fade,
  }) {
    return Navigator.of(context).pushReplacementNamed<T, dynamic>(
      routeName,
      arguments: arguments,
    );
  }

  static Future<T?> navigateToAndClearStack<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
    RouteTransitionType transitionType = RouteTransitionType.fade,
  }) {
    return Navigator.of(context).pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static void navigateBack<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop<T>(result);
  }
}

// Enum for different transition types
enum RouteTransitionType {
  none,
  fade,
  slideRight,
  slideUp,
}
