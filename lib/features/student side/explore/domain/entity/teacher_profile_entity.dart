class TeacherProfileEntity {
  final int teacherId;
  final String name;
  final String bio;
  final String qualifications;
  final num hourlyRateQAR;
  final List<String> subjects;
  final List<String> languages;
  final num rating;
  final int yearsOfExperience;
  final int completedSessions;

  const TeacherProfileEntity({
    required this.teacherId,
    required this.name,
    required this.bio,
    required this.qualifications,
    required this.hourlyRateQAR,
    required this.subjects,
    required this.languages,
    required this.rating,
    required this.yearsOfExperience,
    required this.completedSessions,
  });
}