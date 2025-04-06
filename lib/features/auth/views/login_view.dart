import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/base/base_view.dart';
import '../../../core/dependency_injection/locator.dart';
import '../../../core/routes/app_router.dart';
import '../viewmodels/login_view_model.dart';
import '../components/auth_text_field.dart';
import '../components/auth_submit_button.dart';
import '../components/auth_redirect_text.dart';
import '../components/error_message.dart';
import '../components/social_login_buttons.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      _usernameController.text = 'ngodat123';
      _passwordController.text = 'Code26102003';
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      viewModelBuilder: () => locator<LoginViewModel>(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        'Welcome to Brainy',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Login to continue',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      AuthTextField(
                        controller: _usernameController,
                        labelText: 'Username',
                        prefixIcon: const Icon(Icons.person),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ErrorMessage(
                          errorMessage:
                              model.hasError ? model.errorMessage : null),
                      AuthSubmitButton(
                        text: 'Login',
                        isLoading: model.isBusy,
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final success = await model.login(
                              _usernameController.text,
                              _passwordController.text,
                            );

                            if (success && mounted) {
                              AppRouter.navigateToReplacement(
                                  context, AppRouter.home);
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      SocialLoginButtons(
                        isLoading: model.isBusy,
                        onGooglePressed: () async {
                          await model.loginWithGoogle();
                        },
                        onFacebookPressed: () async {
                          await model.loginWithFacebook();
                        },
                      ),
                      const SizedBox(height: 24),
                      AuthRedirectText(
                        text: "Don't have an account?",
                        linkText: 'Sign up',
                        isLoading: model.isBusy,
                        onPressed: () {
                          AppRouter.navigateTo(context, model.getSignupRoute());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
