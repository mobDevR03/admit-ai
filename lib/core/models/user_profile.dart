class UserProfile {
  String? country;
  String? level;
  String? goal;
  String? academicLevel;
  List<String> exams;

  UserProfile({
    this.country,
    this.goal,
    this.academicLevel,
    this.level,
    List<String>? exams,
  }) : exams = exams ?? [];
}
