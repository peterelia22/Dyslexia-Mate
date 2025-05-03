enum ExerciseType {
  visualDiscrimination,
  auditoryMemory,
  phonologicalAwareness,
  rapidAutomatizedNaming,
  letterKnowledge,
}

class Exercise {
  final String question;
  final List<String>? choices;
  final String answer;
  final ExerciseType type;
  final String? sequence;
  final String? imageEmoji;

  Exercise({
    required this.question,
    this.choices,
    required this.answer,
    required this.type,
    this.sequence,
    this.imageEmoji,
  });
}
