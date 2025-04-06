import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/dependency_injection/locator.dart';
import 'core/routes/app_router.dart';
import 'core/themes/app_theme.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'core/config/env_config.dart';

Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment configuration
  await EnvConfig().initialize();

  // Set up dependency injection
  await setupLocator();

  runApp(const BrainyApp());
}

class BrainyApp extends StatelessWidget {
  const BrainyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => locator<AuthController>(),
      child: MaterialApp(
        title: EnvConfig().appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRouter.login,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
