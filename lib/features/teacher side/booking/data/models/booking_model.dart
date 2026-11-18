import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.studentId,
    required super.studentName,
    required super.courseId,
    required super.subject,
    required super.mode,
    required super.sessionDate,
    required super.totalPriceQAR,
    required super.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: (json['id'] ?? 0) as int,
      studentId: (json['studentId'] ?? 0) as int,
      studentName: (json['studentName'] ?? '').toString(),
      courseId: (json['courseId'] ?? 0) as int,
      subject: (json['subject'] ?? '').toString(),
      mode: (json['mode'] ?? '').toString(),
      sessionDate: DateTime.parse(json['sessionDate'] as String),
      totalPriceQAR: (json['totalPriceQAR'] ?? 0) as num,
      status: (json['status'] ?? '').toString(),
    );
  }
}