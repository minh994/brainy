import 'package:flutter/material.dart';
import '../../viewmodels/learn_viewmodel.dart';

class LearningControls extends StatelessWidget {
  final LearnViewModel model;
  final VoidCallback onFlip;
  final VoidCallback onSkip;
  final VoidCallback onLearned;

  const LearningControls({
    super.key,
    required this.model,
    required this.onFlip,
    required this.onSkip,
    required this.onLearned,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Skip button
          _buildControlButton(
            label: 'Skip',
            icon: Icons.swipe_left,
            color: Colors.redAccent,
            onPressed: onSkip,
          ),

          // Flip button (show/hide definition)
          _buildControlButton(
            label: 'Flip',
            icon: Icons.flip,
            color: Colors.blueAccent,
            onPressed: onFlip,
          ),

          // Mark as learned
          _buildControlButton(
            label: 'Learned',
            icon: Icons.swipe_right,
            color: Colors.green,
            onPressed: onLearned,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: color,
          disabledColor: Colors.grey[300],
          iconSize: 28,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: onPressed != null ? color : Colors.grey[400],
          ),
        ),
      ],
    );
  }
}
