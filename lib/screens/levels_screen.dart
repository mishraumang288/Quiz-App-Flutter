import 'package:flutter/material.dart';
import '../services/progress_service.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({super.key});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  final _progressService = ProgressService();
  int _unlockedLevel = 1;
  Map<int, int> _levelScores = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await _progressService.getProgress();
    setState(() {
      _unlockedLevel = progress.unlockedLevel;
      _levelScores = progress.levelScores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 50,
        itemBuilder: (context, index) {
          final level = index + 1;
          final isUnlocked = level <= _unlockedLevel;
          final score = _levelScores[level] ?? 0;

          return InkWell(
            onTap: isUnlocked
                ? () => Navigator.of(context).pushNamed(
                      '/quiz',
                      arguments: level,
                    )
                : null,
            child: Container(
              decoration: BoxDecoration(
                color: isUnlocked
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isUnlocked) const Icon(Icons.lock, color: Colors.grey),
                  Text(
                    'Level $level',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isUnlocked ? null : Colors.grey,
                    ),
                  ),
                  if (isUnlocked && score > 0)
                    Text(
                      '$score/1',
                      style: TextStyle(
                        fontSize: 12,
                        color: score == 1 ? Colors.green : Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}