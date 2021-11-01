class ProfessorRating {
  String professorFirst;
  String professorLast;
  String id;
  String legacyId;
  String professorRating;

  ProfessorRating({
    required this.professorFirst,
    required this.professorLast,
    required this.id,
    required this.legacyId,
    required this.professorRating,
  });

  factory ProfessorRating.fromJson(Map<String, dynamic> json) {
    return ProfessorRating(
      professorFirst: json['professorFirst'],
      professorLast: json['professorLast'],
      id: json['id'],
      legacyId: json['legacyId'],
      professorRating: json['professorRating'],
    );
  }
}
