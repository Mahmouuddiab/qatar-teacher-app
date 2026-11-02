class UpdateTeacherProfileParams {
  const UpdateTeacherProfileParams({
    required this.bio,
    required this.qualifications,
    required this.hourlyRateQAR,
    required this.subjects,
    required this.languages,
  });

  final String? bio;
  final String? qualifications;
  final double hourlyRateQAR;
  final List<String> subjects;
  final List<String> languages;

  Map<String, dynamic> toJson() => {
    'bio': bio,
    'qualifications': qualifications,
    'hourlyRateQAR': hourlyRateQAR,
    'subjects': subjects,
    'languages': languages,
  };
}
