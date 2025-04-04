import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/auth_controller.dart';
import 'views/login_view.dart';
import 'views/signup_view.dart';
import 'views/home_view.dart';
import 'views/word_detail_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthController(),
      child: MaterialApp(
        title: 'Brainy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/word',
        routes: {
          '/login': (context) => const LoginView(),
          '/home': (context) => const HomeView(),
          '/signup': (context) => const SignupView(),
         // '/home': (context) => const HomeView(),
          '/word': (context) => const WordDetailView(),
        },
      ),
    );
  }
}
