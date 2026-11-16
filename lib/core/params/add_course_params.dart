class AddCourseParams {
  final String title;
  final String subject;
  final String description;
  final String level;
  final num pricePerSessionQAR;
  final int durationMinutes;
  final String sessionMode;

  const AddCourseParams({
    required this.title,
    required this.subject,
    required this.description,
    required this.level,
    required this.pricePerSessionQAR,
    required this.durationMinutes,
    required this.sessionMode,
  });
}