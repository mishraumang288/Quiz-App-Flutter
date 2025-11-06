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

  Future<ProgressData> getProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedLevel = prefs.getInt(_keyUnlockedLevel) ?? 1;
    
    // Load all level scores
    final levelScores = <int, int>{};
    for (var i = 1; i <= unlockedLevel; i++) {
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
    
    // Save the score for this level
    await prefs.setInt('$_keyScorePrefix$level', score);

    // If passed (score = 1) and it's the current max level, unlock next
    if (score == 1) {
      final currentUnlocked = prefs.getInt(_keyUnlockedLevel) ?? 1;
      if (level == currentUnlocked) {
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