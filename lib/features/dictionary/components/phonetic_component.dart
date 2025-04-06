import 'package:flutter/material.dart';

class Phonetic extends StatelessWidget {
  final String? phonetic;
  final String? phoneticText;
  final Color backgroundColor;

  const Phonetic({
    Key? key,
    required this.phonetic,
    required this.phoneticText,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            phonetic ?? '',
            style: textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          phoneticText ?? '',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
