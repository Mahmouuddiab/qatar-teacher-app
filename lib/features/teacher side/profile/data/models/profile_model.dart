import '../../domain/entity/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.teacherId,
    required super.name,
    super.bio,
    super.qualifications,
    required super.hourlyRateQAR,
    required super.subjects,
    required super.languages,
    required super.rating,
    required super.yearsOfExperience,
    required super.completedSessions,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      teacherId: (json['teacherId'] as num).toInt(),
      name: json['name'] as String,
      bio: json['bio'] as String?,
      qualifications: json['qualifications'] as String?,
      hourlyRateQAR: (json['hourlyRateQAR'] as num).toDouble(),
      subjects: (json['subjects'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList() ??
          [],
      languages: (json['languages'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList() ??
          [],
      rating: (json['rating'] as num).toDouble(),
      yearsOfExperience: (json['yearsOfExperience'] as num).toInt(),
      completedSessions: (json['completedSessions'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacherId': teacherId,
      'name': name,
      'bio': bio,
      'qualifications': qualifications,
      'hourlyRateQAR': hourlyRateQAR,
      'subjects': subjects,
      'languages': languages,
      'rating': rating,
      'yearsOfExperience': yearsOfExperience,
      'completedSessions': completedSessions,
    };
  }
}