import '../../domain/entities/student_booking_entity.dart';

class StudentBookingModel extends StudentBookingEntity {
  const StudentBookingModel({
    required super.id,
    required super.teacherId,
    required super.teacherName,
    required super.courseId,
    required super.mode,
    required super.subject,
    required super.sessionDate,
    required super.totalPriceQAR,
    required super.status,
  });

  factory StudentBookingModel.fromJson(Map<String, dynamic> json) {
    return StudentBookingModel(
      id: (json['id'] ?? 0) as int,
      teacherId: (json['teacherId'] ?? 0) as int,
      teacherName: (json['teacherName'] ?? '').toString(),
      courseId: (json['courseId'] ?? 0) as int,
      mode: (json['mode'] ?? '').toString(),
      subject: (json['subject'] ?? '').toString(),
      sessionDate: DateTime.parse(json['sessionDate'] as String),
      totalPriceQAR: (json['totalPriceQAR'] ?? 0) as num,
      status: (json['status'] ?? '').toString(),
    );
  }
}