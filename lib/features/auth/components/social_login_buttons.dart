import 'package:flutter/material.dart';

/// A component for social login buttons (Google, Facebook, etc.)
class SocialLoginButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;

  const SocialLoginButtons({
    Key? key,
    this.isLoading = false,
    this.onGooglePressed,
    this.onFacebookPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('or'),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Google'),
                onPressed: isLoading ? null : onGooglePressed,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.facebook),
                label: const Text('Facebook'),
                onPressed: isLoading ? null : onFacebookPressed,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
