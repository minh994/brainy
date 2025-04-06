import 'package:flutter/material.dart';

/// A component for switching between login and signup
class AuthRedirectText extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthRedirectText({
    Key? key,
    required this.text,
    required this.linkText,
    this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        TextButton(
          onPressed: isLoading ? null : onPressed,
          child: Text(linkText),
        ),
      ],
    );
  }
}
