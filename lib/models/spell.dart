class Spell {
  final String spellName;
  final String use;

  Spell({required this.spellName, required this.use});

  factory Spell.fromJson(Map<String, dynamic> json) {
    return Spell(
      spellName: json['spell'] ?? 'Unknown',
      use: json['use'] ?? '-',
    );
  }

  Map<String, dynamic> toJson() {
    return {'spell': spellName, 'use': use};
  }
}
