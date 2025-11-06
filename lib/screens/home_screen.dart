import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KBC Quiz'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lightbulb,
                        size: 80,
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Welcome to KBC Quiz!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          'Test your knowledge with questions from Science, Technology, and General Knowledge',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).pushNamed('/levels'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        icon: const Icon(Icons.grid_view),
                        label: const Text(
                          'Select Level',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pushNamed(
                          '/quiz',
                          arguments: 1, // Start with level 1
                        ),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text(
                          'Quick Start',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Developer credits at bottom
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Developed by Umang Mishra and Achyuttam Bakshi',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}