import 'package:flutter/material.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/dependency_injection/locator.dart';
import '../../../core/base/base_view.dart';
import '../../../core/widgets/logo.dart';
import '../components/auth_text_field.dart';
import '../components/auth_submit_button.dart';
import '../components/auth_redirect_text.dart';
import '../components/error_message.dart';
import '../viewmodels/signup_view_model.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<SignupViewModel>(
      viewModelBuilder: () => locator<SignupViewModel>(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Logo(),
                  const SizedBox(height: 24),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthTextField(
                          controller: _nameController,
                          labelText: 'Full Name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: _usernameController,
                          labelText: 'Username',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            if (value.length < 3) {
                              return 'Username must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: _emailController,
                          labelText: 'Email Address',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: _passwordController,
                          labelText: 'Password',
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: _confirmPasswordController,
                          labelText: 'Confirm Password',
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ErrorMessage(
                          errorMessage:
                              model.hasError ? model.errorMessage : null,
                        ),
                        AuthSubmitButton(
                          text: 'Sign Up',
                          isLoading: model.isBusy,
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final success = await model.register(
                                username: _usernameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                fullName: _nameController.text,
                              );

                              if (success && mounted) {
                                // Show success dialog then navigate to login
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title:
                                        const Text('Registration Successful'),
                                    content: const Text(
                                        'Your account has been created successfully. Please log in with your credentials.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          AppRouter.navigateToReplacement(
                                              context, AppRouter.login);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  AuthRedirectText(
                    text: "Already have an account?",
                    linkText: 'Log In',
                    onPressed: () {
                      AppRouter.navigateToReplacement(context, AppRouter.login);
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
