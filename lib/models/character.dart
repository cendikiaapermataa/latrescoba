class Character {
  final String fullName;
  final String nickname;
  final String hogwartsHouse;
  final String interpretedBy;
  final List<dynamic> children;
  final String image;
  final String birthdate;

  Character({
    required this.fullName,
    required this.nickname,
    required this.hogwartsHouse,
    required this.interpretedBy,
    required this.children,
    required this.image,
    required this.birthdate,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      fullName: json['fullName'] ?? 'Unknown',
      nickname: json['nickname'] ?? '-',
      hogwartsHouse: json['hogwartsHouse'] ?? '-',
      interpretedBy: json['interpretedBy'] ?? '-',
      children: json['children'] ?? [],
      image: json['image'] ?? '',
      birthdate: json['birthdate'] ?? '-',
    );
  }
}
