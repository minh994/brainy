import 'package:flutter/material.dart';

import '../../features/auth/views/login_view.dart';
import '../../features/auth/views/signup_view.dart';
import '../../features/home/views/home_view.dart';
import '../../features/vocabulary/views/vocabulary_list_view.dart';

class AppRouter {
  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String vocabulary = '/vocabulary';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupView());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case vocabulary:
        return MaterialPageRoute(builder: (_) => const VocabularyListView());
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
