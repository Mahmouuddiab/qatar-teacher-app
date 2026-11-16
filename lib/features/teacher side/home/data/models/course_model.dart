import 'package:qatar_teachers/core/params/add_course_params.dart';
import '../../domain/entities/course_entity.dart';

class CourseModel extends CourseEntity {
  const CourseModel({
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

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int,
      teacherId: json['teacherId'] as int,
      teacherName: json['teacherName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      description: json['description'] as String? ?? '',
      level: json['level'] as String? ?? '',
      pricePerSessionQAR: json['pricePerSessionQAR'] as num? ?? 0,
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      sessionMode: json['sessionMode'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

/// Request model: AddCourseParams -> JSON body
class AddCourseRequestModel {
  final String title;
  final String subject;
  final String description;
  final String level;
  final num pricePerSessionQAR;
  final int durationMinutes;
  final String sessionMode;

  const AddCourseRequestModel({
    required this.title,
    required this.subject,
    required this.description,
    required this.level,
    required this.pricePerSessionQAR,
    required this.durationMinutes,
    required this.sessionMode,
  });

  factory AddCourseRequestModel.fromParams(AddCourseParams p) {
    return AddCourseRequestModel(
      title: p.title,
      subject: p.subject,
      description: p.description,
      level: p.level,
      pricePerSessionQAR: p.pricePerSessionQAR,
      durationMinutes: p.durationMinutes,
      sessionMode: p.sessionMode,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'subject': subject,
    'description': description,
    'level': level,
    'pricePerSessionQAR': pricePerSessionQAR,
    'durationMinutes': durationMinutes,
    'sessionMode': sessionMode,
  };
}
