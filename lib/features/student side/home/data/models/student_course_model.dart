import '../../domain/entities/student_course_entity.dart';

class StudentCourseModel extends StudentCourseEntity {
  const StudentCourseModel({
    required super.id,
    required super.teacherId,
    required super.teacherName,
    required super.title,
    required super.subject,
    required super.description,
    required super.level,
    required super.pricePerSessionQAR,
    required super.durationMinutes,
    required super.sessionMode,
    required super.isActive,
    required super.createdAt,
  });

  factory StudentCourseModel.fromJson(Map<String, dynamic> json) {
    return StudentCourseModel(
      id: (json['id'] ?? 0) as int,
      teacherId: (json['teacherId'] ?? 0) as int,
      teacherName: (json['teacherName'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      subject: (json['subject'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      level: (json['level'] ?? '').toString(),
      pricePerSessionQAR: (json['pricePerSessionQAR'] ?? 0) as num,
      durationMinutes: (json['durationMinutes'] ?? 0) as int,
      sessionMode: (json['sessionMode'] ?? '').toString(),
      isActive: (json['isActive'] ?? false) as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}