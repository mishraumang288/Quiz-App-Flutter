import 'package:shared_preferences/shared_preferences.dart';

class ProgressData {
  final int unlockedLevel;
  final Map<int, int> levelScores;

  ProgressData({
    required this.unlockedLevel,
    required this.levelScores,
  });
}

class ProgressService {
  static const _keyUnlockedLevel = 'unlockedLevel';
  static const _keyScorePrefix = 'level_score_';
  static const int questionsPerLevel = 10;

  Future<ProgressData> getProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedLevel = prefs.getInt(_keyUnlockedLevel) ?? 1;
    
    // Load all level scores
    final levelScores = <int, int>{};
    for (var i = 1; i <= 50; i++) {
      final score = prefs.getInt('$_keyScorePrefix$i') ?? 0;
      if (score > 0) {
        levelScores[i] = score;
      }
    }

    return ProgressData(
      unlockedLevel: unlockedLevel,
      levelScores: levelScores,
    );
  }

  Future<void> updateProgress(int level, int score) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save the score for this level (score is out of 10)
    final currentScore = prefs.getInt('$_keyScorePrefix$level') ?? 0;
    if (score > currentScore) {
      await prefs.setInt('$_keyScorePrefix$level', score);
    }

    // Unlock next level if current level is passed (score >= 5 out of 10)
    if (score >= 5) {
      final currentUnlocked = prefs.getInt(_keyUnlockedLevel) ?? 1;
      if (level == currentUnlocked && level < 50) {
        await prefs.setInt(_keyUnlockedLevel, level + 1);
      }
    }
  }

  Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.setInt(_keyUnlockedLevel, 1);
  }
}