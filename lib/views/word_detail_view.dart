import 'package:flutter/material.dart';

class WordDetailView extends StatelessWidget {
  const WordDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // New word badge
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'New',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'My words',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Word and pronunciation
                    const Text(
                      'recursion',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '[rɪˈkɜːʃən]',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Translation
                    const Text(
                      'từ vựng',
                      style: TextStyle(
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Example sentences
                    _ExampleItem(
                      text: 'Understanding recursion is the key to solving this complex problem.',
                    ),
                    const SizedBox(height: 16),
                    _ExampleItem(
                      text: 'The function calls itself, creating a recursion that continues until a base condition is met.',
                    ),
                    const SizedBox(height: 16),
                    _ExampleItem(
                      text: 'Recursion is the capacity to embed phrases inside one another.',
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom navigation
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.skip_previous),
                      label: const Text('Skip'),
                      style: TextButton.styleFrom(foregroundColor: Colors.grey),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.volume_up),
                      color: Colors.grey,
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Text('Learn'),
                      label: const Icon(Icons.skip_next),
                      style: TextButton.styleFrom(foregroundColor: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom navigation bar
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            currentIndex: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'Learn',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Dictionary',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Statistic',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExampleItem extends StatelessWidget {
  final String text;

  const _ExampleItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Icon(
            Icons.volume_up,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
} 