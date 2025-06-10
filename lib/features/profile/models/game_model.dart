class GameModel {
  final String gameType;
  final int correctScore;
  final int incorrectScore;
  final List<Map<String, dynamic>> rounds;

  GameModel({
    required this.gameType,
    required this.correctScore,
    required this.incorrectScore,
    required this.rounds,
  });

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      gameType: map['gameType'] ?? '',
      correctScore: map['correctScore'] ?? 0,
      incorrectScore: map['incorrectScore'] ?? 0,
      rounds: List<Map<String, dynamic>>.from(map['rounds'] ?? []),
    );
  }

  String get gameNameInArabic {
    switch (gameType) {
      case 'draw_letter':
        return 'رسم الحروف';
      case 'letter_hunt':
        return 'البحث عن الحروف';
      case 'object_detection':
        return 'اكتشاف الأشياء';
      default:
        return gameType;
    }
  }
}
