class PlayerModel {
  final int energyPoints;
  final String lastEnergyIncrease;
  final List<String> unlockedSkills;

  PlayerModel({
    required this.energyPoints,
    required this.lastEnergyIncrease,
    required this.unlockedSkills,
  });

  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    return PlayerModel(
      energyPoints: map['energyPoints'] ?? 0,
      lastEnergyIncrease: map['lastTimeEnergyIncreasedUTC'] ?? 'غير محدد',
      unlockedSkills: List<String>.from(map['unlockedSkillNames'] ?? []),
    );
  }
}
