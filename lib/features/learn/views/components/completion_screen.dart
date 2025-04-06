import 'package:flutter/material.dart';

class CompletionScreen extends StatelessWidget {
  final VoidCallback onReturnToLearningView;
  final VoidCallback onStartAgain;

  const CompletionScreen({
    super.key,
    required this.onReturnToLearningView,
    required this.onStartAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40),
          // Success icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 72,
            ),
          ),
          const SizedBox(height: 24),
          // Congratulations text
          const Text(
            'Congratulations!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'You\'ve completed all the cards in this session. Keep up the good work!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Stats
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.trending_up,
                  label: 'Progress',
                  value: '100%',
                  color: Colors.blue,
                ),
                _buildStatItem(
                  icon: Icons.timer,
                  label: 'Time',
                  value: 'Great',
                  color: Colors.orange,
                ),
                _buildStatItem(
                  icon: Icons.auto_awesome,
                  label: 'Streak',
                  value: '+1',
                  color: Colors.purple,
                ),
              ],
            ),
          ),
          const Spacer(),
          // Buttons
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: onReturnToLearningView,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Return to Learning View',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onStartAgain,
                  child: Text(
                    'Start Again',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

void showCompletionScreen({
  required BuildContext context,
  required VoidCallback onReturnToLearningView,
  required VoidCallback onStartAgain,
}) {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CompletionScreen(
      onReturnToLearningView: () {
        Navigator.of(context).pop(); // Close bottom sheet
        onReturnToLearningView();
      },
      onStartAgain: () {
        Navigator.of(context).pop(); // Close bottom sheet
        onStartAgain();
      },
    ),
  );
}
