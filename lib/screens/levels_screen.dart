import 'package:flutter/material.dart';
import '../services/progress_service.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({super.key});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> with TickerProviderStateMixin {
  final _progressService = ProgressService();
  int _unlockedLevel = 1;
  Map<int, int> _levelScores = {};
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await _progressService.getProgress();
    setState(() {
      _unlockedLevel = progress.unlockedLevel;
      _levelScores = progress.levelScores;
    });
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade600, Colors.indigo.shade700],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade50,
              Colors.white,
            ],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: GridView.builder(
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
              final hasPlayed = score > 0;
              final passed = score >= 5;

              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 300 + (index * 20)),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Hero(
                  tag: 'level_$level',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isUnlocked
                          ? () => Navigator.of(context).pushNamed(
                                '/quiz',
                                arguments: level,
                              )
                          : null,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: isUnlocked
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: hasPlayed
                                      ? (passed
                                          ? [Colors.green.shade300, Colors.green.shade500]
                                          : [Colors.orange.shade300, Colors.orange.shade500])
                                      : [Colors.blue.shade300, Colors.blue.shade500],
                                )
                              : null,
                          color: !isUnlocked ? Colors.grey[300] : null,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isUnlocked
                              ? [
                                  BoxShadow(
                                    color: (hasPlayed
                                            ? (passed ? Colors.green : Colors.orange)
                                            : Colors.blue)
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!isUnlocked)
                              const Icon(Icons.lock, color: Colors.grey, size: 28)
                            else if (hasPlayed)
                              Icon(
                                passed ? Icons.star : Icons.replay,
                                color: Colors.white,
                                size: 28,
                              )
                            else
                              const Icon(
                                Icons.play_circle_outline,
                                color: Colors.white,
                                size: 28,
                              ),
                            const SizedBox(height: 4),
                            Text(
                              '$level',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isUnlocked ? Colors.white : Colors.grey,
                              ),
                            ),
                            if (isUnlocked && hasPlayed)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$score/10',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: passed ? Colors.green.shade700 : Colors.orange.shade700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}