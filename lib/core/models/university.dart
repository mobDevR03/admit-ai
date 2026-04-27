class University {
  final String name;
  final String country;
  final String city;
  final String description;
  final String imageUrl;
  final int duolingo;
  final double ielts;
  final int toefl;

  final int tuition;
  final double acceptanceRate;

  const University({
    required this.name,
    required this.country,
    required this.city,
    required this.description,
    required this.imageUrl,
    required this.duolingo,
    required this.ielts,
    required this.toefl,
    
    required this.tuition,
    required this.acceptanceRate,
  });

  factory University.fromMap(Map<String, dynamic> map) {
    return University(
      name: map['name'] ?? '',
      country: map['country'] ?? '',
      city: map['city'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageURL'] ?? '',
      duolingo: map['Duolingo'] ?? 0,
      ielts: (map['IELTS'] ?? 0).toDouble(),
      toefl: map['TOEFL'] ?? 0,
      tuition: map['tuition'] ?? 0,
      acceptanceRate: (map['acceptanceRate'] ?? 0).toDouble(),
    );
  }
}