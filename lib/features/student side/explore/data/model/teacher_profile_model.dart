import '../../domain/entity/teacher_profile_entity.dart';

class TeacherProfileModel extends TeacherProfileEntity {
  const TeacherProfileModel({
    required super.teacherId,
    required super.name,
    required super.bio,
    required super.qualifications,
    required super.hourlyRateQAR,
    required super.subjects,
    required super.languages,
    required super.rating,
    required super.yearsOfExperience,
    required super.completedSessions,
  });

  factory TeacherProfileModel.fromJson(Map<String, dynamic> json) {
    List<String> strings(dynamic v) =>
        v is List ? v.map((e) => e.toString()).toList() : <String>[];

    return TeacherProfileModel(
      teacherId: (json['teacherId'] ?? json['id'] ?? 0) as int,
      name: (json['name'] ?? '') as String,
      bio: (json['bio'] ?? '') as String,
      qualifications: (json['qualifications'] ?? '') as String,
      hourlyRateQAR: (json['hourlyRateQAR'] ?? 0) as num,
      subjects: strings(json['subjects']),
      languages: strings(json['languages']),
      rating: (json['rating'] ?? 0) as num,
      yearsOfExperience: (json['yearsOfExperience'] ?? 0) as int,
      completedSessions: (json['completedSessions'] ?? 0) as int,
    );
  }
}