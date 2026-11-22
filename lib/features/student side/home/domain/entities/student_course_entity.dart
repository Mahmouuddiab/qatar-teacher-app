class StudentCourseEntity {
  final int id;
  final int teacherId;
  final String teacherName;
  final String title;
  final String subject;
  final String description;
  final String level;
  final num pricePerSessionQAR;
  final int durationMinutes;
  final String sessionMode;
  final bool isActive;
  final DateTime createdAt;

  const StudentCourseEntity({
    required this.id,
    required this.teacherId,
    required this.teacherName,
    required this.title,
    required this.subject,
    required this.description,
    required this.level,
    required this.pricePerSessionQAR,
    required this.durationMinutes,
    required this.sessionMode,
    required this.isActive,
    required this.createdAt,
  });
}