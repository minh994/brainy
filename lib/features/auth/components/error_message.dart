import 'package:flutter/material.dart';

/// A component for displaying error messages
class ErrorMessage extends StatelessWidget {
  final String? errorMessage;
  final EdgeInsets padding;
  final TextStyle? style;

  const ErrorMessage({
    Key? key,
    this.errorMessage,
    this.padding = const EdgeInsets.only(bottom: 16.0),
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (errorMessage == null || errorMessage!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: padding,
      child: Text(
        errorMessage!,
        style: style ??
            const TextStyle(
              color: Colors.red,
              fontSize: 14,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
