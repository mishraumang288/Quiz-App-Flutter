import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import '../models/question.dart';

class QuestionService {
  final String assetPath;

  QuestionService({this.assetPath = 'lib/assets/questions.json'});

  Future<List<Question>> loadAll() async {
    final data = await rootBundle.loadString(assetPath);
    final list = json.decode(data) as List<dynamic>;
    return list.map((e) => Question.fromJson(e)).toList();
  }

  /// Returns all 10 questions for a specific level
  Future<List<Question>> getQuestionsForLevel(int level) async {
    final all = await loadAll();
    // Filter questions by level
    final levelQuestions = all.where((q) => q.level == level).toList();
    return levelQuestions;
  }

  /// Returns up to [count] random questions (shuffled) from asset.
  Future<List<Question>> getRandomQuiz({int count = 50}) async {
    final all = await loadAll();
    final rnd = Random();
    all.shuffle(rnd);
    if (all.length <= count) return all;
    return all.sublist(0, count);
  }
}
