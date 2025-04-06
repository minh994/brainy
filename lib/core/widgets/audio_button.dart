import 'package:flutter/material.dart';

class AudioButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color backgroundColor;
  final bool isPlaying;
  final double size;

  const AudioButton({
    Key? key,
    required this.onTap,
    this.backgroundColor = Colors.blueAccent,
    this.isPlaying = false,
    this.size = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Icon(
            isPlaying ? Icons.volume_off : Icons.volume_up,
            size: size,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
