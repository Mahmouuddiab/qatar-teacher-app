class ProfileEntity {
  final int teacherId;
  final String name;
  final String? bio;
  final String? qualifications;
  final double hourlyRateQAR;
  final List<String> subjects;
  final List<String> languages;
  final double rating;
  final int yearsOfExperience;
  final int completedSessions;

  const ProfileEntity({
    required this.teacherId,
    required this.name,
    this.bio,
    this.qualifications,
    required this.hourlyRateQAR,
    required this.subjects,
    required this.languages,
    required this.rating,
    required this.yearsOfExperience,
    required this.completedSessions,
  });
}