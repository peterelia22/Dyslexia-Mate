class QuizResult {
  final String question;
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final double duration;

  QuizResult({
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.duration,
  });

  String get status => isCorrect ? "صحيح" : "خطأ";
}
