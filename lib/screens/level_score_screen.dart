import 'package:flutter/material.dart';
import 'dart:math' as math;

class LevelScoreScreen extends StatefulWidget {
  final int level;
  final int score;
  final int totalQuestions;
  final List<bool> answerResults;

  const LevelScoreScreen({
    super.key,
    required this.level,
    required this.score,
    required this.totalQuestions,
    required this.answerResults,
  });

  @override
  State<LevelScoreScreen> createState() => _LevelScoreScreenState();
}

class _LevelScoreScreenState extends State<LevelScoreScreen>
    with TickerProviderStateMixin {
  late AnimationController _trophyController;
  late AnimationController _scoreController;
  late AnimationController _fadeController;
  late Animation<double> _trophyAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<int> _scoreCountAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _trophyController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _trophyAnimation = CurvedAnimation(
      parent: _trophyController,
      curve: Curves.elasticOut,
    );
    
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _trophyController, curve: Curves.easeInOut),
    );

    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scoreCountAnimation = IntTween(begin: 0, end: widget.score).animate(
      CurvedAnimation(parent: _scoreController, curve: Curves.easeOut),
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _trophyController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _scoreController.forward();
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _trophyController.dispose();
    _scoreController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = (widget.score / widget.totalQuestions * 100).round();
    final passed = widget.score >= 5;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Level Complete'),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Trophy or Status Icon with Animation
              ScaleTransition(
                scale: _trophyAnimation,
                child: AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: passed ? _rotationAnimation.value : 0,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (passed ? Colors.amber : Colors.grey).withOpacity(0.2),
                          boxShadow: [
                            BoxShadow(
                              color: (passed ? Colors.amber : Colors.grey).withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(
                          passed ? Icons.emoji_events : Icons.refresh_rounded,
                          size: 100,
                          color: passed ? Colors.amber : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Level Title
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Level ${widget.level}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),

              // Status Text
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  passed ? 'Congratulations! 🎉' : 'Keep Practicing! 💪',
                  style: TextStyle(
                    fontSize: 24,
                    color: passed ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),

              // Score Card
              FadeTransition(
                opacity: _fadeAnimation,
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: passed
                            ? [Colors.green.shade50, Colors.green.shade100]
                            : [Colors.orange.shade50, Colors.orange.shade100],
                      ),
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          'Your Score',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        AnimatedBuilder(
                          animation: _scoreCountAnimation,
                          builder: (context, child) {
                            return Text(
                              '${_scoreCountAnimation.value} / ${widget.totalQuestions}',
                              style: const TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: (passed ? Colors.green : Colors.orange).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$percentage%',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: passed ? Colors.green.shade700 : Colors.orange.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Question Results
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: List.generate(
                            widget.answerResults.length,
                            (index) => TweenAnimationBuilder<double>(
                              duration: Duration(milliseconds: 300 + (index * 50)),
                              tween: Tween(begin: 0.0, end: 1.0),
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: child,
                                );
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.answerResults[index]
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,
                                  border: Border.all(
                                    color: widget.answerResults[index]
                                        ? Colors.green
                                        : Colors.red,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  widget.answerResults[index] ? Icons.check : Icons.close,
                                  color: widget.answerResults[index]
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Passing Criteria
                // Passing Criteria banner removed
              const Spacer(),

              // Action Buttons
              FadeTransition(
                opacity: _fadeAnimation,
                child: Row(
                  children: [
                    if (!passed)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacementNamed(
                              '/quiz',
                              arguments: widget.level,
                            );
                          },
                          icon: const Icon(Icons.replay, size: 22),
                          label: const Text(
                            'Try Again',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            elevation: 8,
                            shadowColor: Colors.orange.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    if (!passed) const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          Navigator.of(context).pushReplacementNamed('/levels');
                        },
                        icon: Icon(
                          passed ? Icons.arrow_forward : Icons.grid_view,
                          size: 22,
                        ),
                        label: Text(
                          passed ? 'Next Level' : 'All Levels',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: passed ? Colors.green : Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor:
                              (passed ? Colors.green : Colors.blue).withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
