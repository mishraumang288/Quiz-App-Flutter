import 'dart:async';

import 'package:flutter/material.dart';

import '../models/question.dart';
import '../services/question_service.dart';
import '../services/progress_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  final QuestionService _service = QuestionService();
  final ProgressService _progress = ProgressService();
  List<Question> _questions = [];
  int _currentLevel = 1;
  int _index = 0;
  int _score = 0;
  bool _loading = true;

  // timer
  static const int _initialTime = 20; // default 20 seconds per question
  int _timeLeft = _initialTime;
  Timer? _timer;

  // selection state
  int? _selectedIndex;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is int) {
        _currentLevel = args;
      }
      _loadQuestions();
    });
  }

  Future<void> _loadQuestions() async {
    final question = await _service.getQuestionForLevel(_currentLevel);
    setState(() {
      _questions = [question];
      _loading = false;
      _index = 0;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _timeLeft = _initialTime);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        return;
      }
      setState(() {
        _timeLeft -= 1;
        if (_timeLeft <= 0) {
          t.cancel();
          _onTimeUp();
        }
      });
    });
  }

  void _onTimeUp() {
    setState(() {
      _answered = true;
      _selectedIndex = null;
    });
    _finishLevel(passed: false);
  }

  void _selectOption(int i) {
    if (_answered) {
      return;
    }
    _timer?.cancel();
    final q = _questions[_index];
    final correct = i == q.answerIndex;
    setState(() {
      _selectedIndex = i;
      _answered = true;
      if (correct) _score += 1;
    });
    _finishLevel(passed: correct);
  }

  Future<void> _finishLevel({required bool passed}) async {
    // Save progress
    await _progress.updateProgress(_currentLevel, passed ? 1 : 0);
    
    // Show result after a brief delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      _showResult(passed: passed);
    });
  }

  void _showResult({required bool passed}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(passed ? 'Level Complete!' : 'Try Again'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              passed ? Icons.star_rounded : Icons.refresh_rounded,
              size: 64,
              color: passed ? Colors.amber : Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              passed
                  ? 'Congratulations! You\'ve completed Level $_currentLevel!'
                  : 'Keep practicing to pass Level $_currentLevel',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          if (!passed)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restart();
              },
              child: const Text('Try Again'),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/levels');
            },
            child: const Text('Back to Levels'),
          ),
        ],
      ),
    );
  }

  void _restart() {
    setState(() {
      _loading = true;
      _questions = [];
      _index = 0;
      _score = 0;
      _selectedIndex = null;
      _answered = false;
    });
    _loadQuestions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KBC - Quiz'),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 12),
                  Expanded(child: _buildQuestionCard()),
                  const SizedBox(height: 12),
                  _buildFooter(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    final total = _questions.length;
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: (_index + 1) / total,
            backgroundColor: Colors.grey[300],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Level ${_index + 1} / $total'),
            Text('Score: $_score'),
          ],
        ),
      ],
    );
  }

  Widget _buildQuestionCard() {
    final q = _questions[_index];
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Card(
        key: ValueKey(q.id),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      q.question,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildTimerCircle(),
                ],
              ),
              const SizedBox(height: 16),
              ...List.generate(q.options.length, (i) => _buildOption(i, q)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerCircle() {
    final pct = _timeLeft / _initialTime;
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                value: pct,
                strokeWidth: 4,
                color: pct > 0.4 ? Colors.green : Colors.red,
                backgroundColor: Colors.grey[200],
              ),
            ),
            Text('$_timeLeft', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildOption(int i, Question q) {
    final option = q.options[i];
    Color? color;
    if (_answered) {
      if (i == q.answerIndex) {
        color = Colors.green[300];
      } else if (_selectedIndex != null && i == _selectedIndex) {
        color = Colors.red[300];
      } else {
        color = Colors.grey[100];
      }
    } else {
      color = Colors.white;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => _selectOption(i),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  child: Text(String.fromCharCode(65 + i)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(option)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: _restart,
          icon: const Icon(Icons.refresh),
          label: const Text('Restart'),
        ),
        Text('${_index + 1} / ${_questions.length}'),
      ],
    );
  }
}
