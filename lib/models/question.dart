class Question {
  final String id;
  final String question;
  final List<String> options;
  final int answerIndex;
  final String category;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.category,
  });

  factory Question.fromJson(Map<String, dynamic> j) => Question(
        id: j['id'] as String,
        question: j['question'] as String,
        options: List<String>.from(j['options'] as List<dynamic>),
        answerIndex: j['answerIndex'] as int,
        category: j['category'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'options': options,
        'answerIndex': answerIndex,
        'category': category,
      };
}
