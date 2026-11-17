class UpdateCourseParams {
  final int id;
  final String title;
  final String subject;
  final String description;
  final String level;
  final num pricePerSessionQAR;
  final int durationMinutes;
  final String sessionMode;
  final bool isActive;

  const UpdateCourseParams({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.level,
    required this.pricePerSessionQAR,
    required this.durationMinutes,
    required this.sessionMode,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'subject': subject,
    'description': description,
    'level': level,
    'pricePerSessionQAR': pricePerSessionQAR,
    'durationMinutes': durationMinutes,
    'sessionMode': sessionMode,
    'isActive': isActive,
  };
}